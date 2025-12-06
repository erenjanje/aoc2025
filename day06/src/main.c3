module day06;
import std::io;
import std::collections::list;
import std::collections::tuple;

fn int main(String[] args) => @pool() {
	List{Numbers} numbers;
	List{char} operators;
	read_input(&numbers, &operators);
	io::printn(numbers);
	io::printn(operators);
	List{ulong} result = apply(numbers, operators);
	ulong accumulator = 0;
	foreach(res : result) {
		accumulator += res;
	}
	io::printn(accumulator);
	return 0;
}

alias Numbers = List{ulong};

fn void read_input(List{Numbers}* out_numbers, List{char}* out_operators, Allocator allocator = tmem) => @pool() {
	List{Numbers} numbers;
	List{char} operators;

	numbers.init(allocator);
	operators.init(allocator);

	String line = io::treadline()!!;
	String[] splitted = line.tsplit(" ", skip_empty: true);
	for(usz i = 0; i < splitted.len; i++) {
		numbers.push((Numbers){});
		numbers[i].init(allocator);
		operators.push('\0');
	}

	while(true) {
		if(catch splitted[0].to_ulong()) {
			break;
		}

		for(usz i = 0; i < splitted.len; i++) {
			numbers[i].push(splitted[i].to_ulong())!!;
		}

		line = io::treadline()!!;
		splitted = line.tsplit(" ", skip_empty: true);
	}

	for(usz i = 0; i < splitted.len; i++) {
		operators[i] = splitted[i][0];
	}

	*out_numbers = numbers;
	*out_operators = operators;
}

fn List{ulong} apply(List{Numbers} numbers, List{char} operators, Allocator allocator = tmem) {
	List{ulong} ret;
	ret.init(allocator);
	ret.reserve(numbers.len());

	for(usz i = 0; i < numbers.len(); i++) {
		ulong accumulator = 1;
		switch(operators[i]) {
			case '+':
				accumulator -= 1;
				foreach(num : numbers[i]) {
					accumulator += num;
				}
				ret.push(accumulator);
			case '*':
				foreach(num : numbers[i]) {
					accumulator *= num;
				}
				ret.push(accumulator);
			default:
		}
	}

	return ret;
}
