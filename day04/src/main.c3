module day04;
import std::io;
import std::collections::list;

fn int main(String[] args) => @pool() {
	List{String} list;
	list.tinit();
	while(try String row = io::treadline()) {
		list.push(row);
	}

	io::printn(count_rolls(list));

	for(int i = 0; i < list.len(); i++) {
		io::printn(list[i]);
	}
	return 0;
}

fn ulong count_rolls(List{String} list) {
	ulong accessible = 0;
	isz row_count = list.len();
	isz col_count = list[0].len;
	for(isz row = 0; row < row_count; row++) {
		for(isz col = 0; col < col_count; col++) {
			if(list[row][col] != '@') { continue; }
			short rolls_around = 0;
			for(isz checked_row = max(0, row - 1); checked_row <= min(row + 1, row_count - 1); checked_row++) {
				for(isz checked_col = max(0, col - 1); checked_col <= min(col + 1, col_count - 1); checked_col++) {
					if(list[checked_row][checked_col] == '@') { rolls_around += 1; }
				}
			}
			if(rolls_around < 5) {
				accessible += 1;
			}
		}
	}
	return accessible;
}
