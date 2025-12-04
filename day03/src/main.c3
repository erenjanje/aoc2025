module day03;
import std::io;
import std::math;
import std::time::clock;

fn int main(String[] args) => @pool() {
	ulong total = 0;
	ulong real_total = 0;
	const int REPEAT = 10000;
	Clock total_time;
	while(try String bank = io::treadline()) {
		Clock start = clock::now();
		for(int i = 0; i < REPEAT; i++) {
			ulong result = process_bank_okn(bank, 12);
			if(i == 0) {
				real_total += result;
			}
			total += result;
		}
		Clock end = clock::now();
		NanoDuration diff = end - start;
		total_time += diff;
	}
	io::printfn("Result %d (%d) in average time: %fms", real_total, total, (double)total_time / ((double)REPEAT * 1e6));
	return 0;
}

struct Histogram {
	short[10] histogram;
	short current_max;
}

fn Histogram histogram_new(String bank) {
	Histogram ret;
	foreach(char c : bank) {
		ret.add(c);
	}
	return ret;
}

fn void Histogram.add(&self, char c) {
	short digit = c - '0';
	self.histogram[digit] += 1;
	if(digit > self.current_max) {
		self.current_max = digit;
	}
}

fn short Histogram.remove(&self, char c) {
	short digit = c - '0';
	self.histogram[digit] -= 1;
	bool ret = self.current_max == digit;
	if(self.histogram[digit] == 0 && self.current_max == digit) {
		while(self.current_max > 0 && self.histogram[self.current_max] == 0) {
			self.current_max -= 1;
		}
	}
	return ret ? digit : 0;
}

fn ulong process_bank_on(String bank, int enabled_battery_count) {
	ulong joltage = 0;
	uptr next = bank.len - enabled_battery_count;
	short read_digits = 0;
	Histogram histogram = histogram_new(bank[..next]);
	foreach(char c : bank) {
		short digit = histogram.remove(c);
		if(digit) {
			read_digits += 1;
			joltage = 10 * joltage + digit;
			if(next < bank.len - 1) {
				next += 1;
				histogram.add(bank[next]);
			}
			if(read_digits == enabled_battery_count) {
				break;
			}
		}
	}
	return joltage;
}

fn ulong process_bank_okn(String bank, int enabled_battery_count) {
	ulong joltage = 0;
	uptr start = 0;
	for(int i = 0; i < enabled_battery_count; i++) {
		uptr digit_position = max_of_bank(bank[start..^(enabled_battery_count - i)]) + start;
		char digit = bank[digit_position];
		start = digit_position + 1;
		joltage = 10 * joltage + (long)(digit - '0');
	}
	return joltage;
}

fn uptr max_of_bank(String bank) {
	uptr ret = 0;
	for(uptr i = 0; i < bank.len; i++) {
		if(bank[i] > bank[ret]) {
			ret = i;
		}
	}
	
	return ret;
}
