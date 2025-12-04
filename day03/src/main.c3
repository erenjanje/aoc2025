module day03;
import std::io;
import std::math;

fn int main(String[] args) => @pool() {
	int total = 0;
	while(try String bank = io::treadline()) {
		total += process_bank(bank);
	}
	io::printfn("%d", total);
	return 0;
}

fn int process_bank(String bank) {
	uptr first_digit_position = max_of_bank(bank[..(bank.len - 2)]);
	uptr second_digit_position = max_of_bank(bank[(first_digit_position+1)..]) + first_digit_position + 1;
	char first_digit_char = bank[first_digit_position];
	char second_digit_char = bank[second_digit_position];
	int joltage = (first_digit_char - '0') * 10 + second_digit_char - '0';
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
