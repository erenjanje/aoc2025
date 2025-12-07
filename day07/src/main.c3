module day07;
import std::io;
import std::collections::map;
import std::core::mem::allocator;

fn int main(String[] args) => @pool() {
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
	return 0;
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
