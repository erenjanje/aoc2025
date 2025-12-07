module day07;
import std::io;
import std::collections::map;
import std::collections::list;
import std::core::mem::allocator;

fn int main(String[] args) => @pool() {
	part2();
	return 0;
}

fn void part1() => @pool() {
	bool[] beams;
	{
		String row = io::treadline()!!;
		beams = allocator::new_array(tmem, bool, row.len);
		beams[row.index_of_char('S')!!] = true;
		print_beams(row, beams);
	}
	ulong split_count = 0;
	while(try String row = io::treadline()) {
		for(usz i = 0; i < row.len; i++) {
			if(beams[i] && row[i] == '^') {
				split_count += 1;
				beams[i] = false;
				if(i > 0) {
					beams[i-1] = true;
				}
				if(i < row.len-1) {
					beams[i+1] = true;
				}
			}
		}
		print_beams(row, beams);
	}
	io::printn(split_count);
}

fn void part2() => @pool() {
	String[] input = read_input();
	print_input(input);
	io::printn(count(input, 0, input[0].index_of_char('S')!!));
}

fn long count(String[] input, usz row, usz col, long[][] table = {}) => @pool() {
	if(table.len == 0) {
		table = create_matrix(input.len, input[0].len);
	}
	
	if(table[row][col] != -1) {
		return table[row][col];
	}

	long ret = 0;
	defer table[row][col] = ret;

	if(row == input.len - 1) {
		return ret = 1;
	}
	if(input[row + 1][col] == '^') {
		if(col > 0) {
			ret += count(input, row + 1, col - 1, table);
		}
		if(col < input[0].len-1) {
			ret += count(input, row + 1, col + 1, table);
		}
		return ret;
	} else {
		return ret = count(input, row + 1, col, table);
	}
}

fn String[] read_input(Allocator allocator = tmem) => @pool() {
	List{String} beams;
	beams.tinit();
	while(try String line = io::readline(allocator)) {
		beams.push(line);
	}
	return beams.to_array(allocator);
}

fn void print_input(String[] input) {
	foreach(String line : input) {
		io::printn(line);
	}
}

fn void print_beams(String row, bool[] beams) {
	for(usz i = 0; i < row.len; i++) {
		if(beams[i]) {
			io::printf("%c", '|');
		} else {
			io::printf("%c", row[i]);
		}
	}
	io::print("\n");
}

fn long[][] create_matrix(usz rows, usz cols, Allocator allocator = tmem) {
	long[][] ret = allocator::new_array(allocator, long[], rows);
	for(usz r = 0; r < rows; r++) {
		ret[r] = allocator::new_array(allocator, long, cols);
		for(usz c = 0; c < cols; c++) {
			ret[r][c] = -1;
		}
	}
	return ret;
}
