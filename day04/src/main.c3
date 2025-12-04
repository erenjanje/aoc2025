module day04;
import std::io;
import std::collections::list;

fn int main(String[] args) => @pool() {
	List{String} list;
	list.tinit();
	while(try String row = io::treadline()) {
		list.push(row);
	}

	for(int i = 0; i < list.len(); i++) {
		io::printn(list[i]);
	}
	return 0;
}


