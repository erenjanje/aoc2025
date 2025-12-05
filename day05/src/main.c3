module day05;
import std::io;
import std::collections::range;
import std::collections::list;

alias IdRange = Range{ulong};

fn int main(String[] args) => @pool() {
	List{IdRange} ranges;
	ranges.tinit();
	while(try String line = io::treadline()) {
		if(line.len == 0) { break; }
		String[] splitted = line.tsplit("-");
		IdRange range = (IdRange){.start = splitted[0].to_ulong(), .end = splitted[1].to_ulong()}!!;
		ranges.push(range);
	}

	int result = 0;
	while(try String line = io::treadline()) {
		ulong query = line.to_ulong()!!;
		foreach(range : ranges) {
			if(range.contains(query)) {
				result += 1;
				break;
			}
		}
	}
	// io::printn(ranges);
	io::printn(result);
	return 0;
}
