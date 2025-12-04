module day04;
import std::io;
import std::collections::list;

fn int main(String[] args) => @pool() {
	List{String}[2] lists = parse_input();

	ulong result = 0;
	ulong removed = 0;
	bool current = false;
	while((removed = remove_rolls(lists[(int)current], lists[(int)!current])) != 0) {
		result += removed;
		current = !current;
	}

	io::printn(result);

	return 0;
}

fn List{String}[2] parse_input(Allocator allocator = tmem) {
	List{String}[2] ret;
	ret[0].init(allocator);
	ret[1].init(allocator);

	while(try String row = io::readline(allocator)) {
		ret[0].push(row);
		ret[1].push(row.copy(allocator));
	}

	return ret;
}

fn void print_rolls(List{String} list) {
	for(isz i = 0; i < list.len(); i++) {
		io::printn(list[i]);
	}
}

fn ulong remove_rolls(List{String} output, List{String} input) {
	ulong accessible = 0;
	isz row_count = input.len();
	isz col_count = input[0].len;
	for(isz row = 0; row < row_count; row++) {
		for(isz col = 0; col < col_count; col++) {
			output[row][col] = input[row][col];
			if(input[row][col] != '@') { continue; }
			short rolls_around = 0;
			for(isz checked_row = max(0, row - 1); checked_row <= min(row + 1, row_count - 1); checked_row++) {
				for(isz checked_col = max(0, col - 1); checked_col <= min(col + 1, col_count - 1); checked_col++) {
					if(input[checked_row][checked_col] == '@') { rolls_around += 1; }
				}
			}
			if(rolls_around < 5) {
				output[row][col] = '.';
				accessible += 1;
			}
		}
	}
	return accessible;
}
