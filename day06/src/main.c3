module day06;
import std::io;
import std::collections::list;
import std::collections::tuple;
import std::core::mem::allocator;

fn int main(String[] args) => @pool() {
	part2();
	return 0;
}

alias Numbers = List{ulong};

fn void part1() => @pool() {
	List{Numbers} numbers;
	List{char} operators;
	read_input_part1(&numbers, &operators);
	io::printn(numbers);
	io::printn(operators);
	List{ulong} result = apply(numbers, operators);
	ulong accumulator = 0;
	foreach(res : result) {
		accumulator += res;
	}
	io::printn(accumulator);
}

fn void read_input_part1(List{Numbers}* out_numbers, List{char}* out_operators, Allocator allocator = tmem) => @pool() {
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

fn void part2() => @pool() {
	List{String} input;
	input.tinit();

	while(try line = io::treadline()) {
		input.push(line);
	}

	List{String} transposed = transpose(input);

	ulong ret = 0;
	ulong accumulator = 0;
	char operator;
	foreach(line : transposed) {
		if(line[^1] == '+') {
			ret += accumulator;
			operator = '+';
			accumulator = 0;
		} else if(line[^1] == '*') {
			ret += accumulator;
			operator = '*';
			accumulator = 1;
		}

		ulong number = line[..^2].trim().to_ulong()!!;

		if(operator == '+') {
			accumulator += number;
		} else if(operator == '*') {
			accumulator *= number;
		}
		io::printfn("%c\t%d\t%d", operator, number, accumulator);
	}
	ret += accumulator;
	
	io::printn(ret);
}

fn List{String} transpose(List{String} list, Allocator allocator = tmem) {
	usz rows = list.len();
	usz cols = list[0].len;
	List{String} ret;
	ret.init(allocator);
	ret.reserve(cols);

	for(usz c = 0; c < cols; c++) {
		char[] pushed = allocator::new_array(allocator, char, rows);
		for(usz r = 0; r < rows; r++) {
			pushed[r] = list[r][c];
		}
		if(((String)pushed).trim().len != 0) {
			ret.push((String)pushed);
		}
	}

	return ret;
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
