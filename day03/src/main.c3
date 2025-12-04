module day03;
import std::io;
import std::math;

fn int main(String[] args) => @pool() {
	ulong total = 0;
	while(try String bank = io::treadline()) {
		total += process_bank(bank, 12);
	}
	io::printfn("%d", total);
	return 0;
}

fn ulong process_bank(String bank, int enabled_battery_count) {
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
