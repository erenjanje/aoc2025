module day05;
import std::io;
import std::collections::range;
import std::collections::list;
import std::time::clock;
import range_list;

fn int main(String[] args) => @pool() {
	RangeList{ulong} ranges;
	ranges.tinit();
	while(try String line = io::treadline()) {
		if(line.len == 0) { break; }
		String[] splitted = line.tsplit("-");
		Range{ulong} range = (Range{ulong}){.start = splitted[0].to_ulong(), .end = splitted[1].to_ulong()}!!;
		ranges.push(range);
	}

	ulong naive = 0;
	ulong fast = 0;
	@pool() {
		RangeList{ulong} temp;
		Clock start = clock::now();
		for(int i = 0; i < 10000; i++) {
			temp = ranges.slow_merge();
		}
		Clock end = clock::now();
		naive = (ulong)(end - start);
	};

	@pool() {
		RangeList{ulong} temp;
		Clock start = clock::now();
		for(int i = 0; i < 10000; i++) {
			temp = ranges.merge();
		}
		Clock end = clock::now();
		fast = (ulong)(end - start);
	};

	io::printfn("Naive merge\t%gms", (double)naive * 1e-6);
	io::printfn("Fast merge\t%gms", (double)fast * 1e-6);
	io::printfn("Speedup factor\t%gx", (double)naive / (double)fast);
	ranges = ranges.merge();

	int result = 0;
	ulong total = 0;
	foreach(range : ranges) {
		total += range.len();
	}
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
	io::printfn("Part 1: %d", result);
	io::printfn("Part 2: %d", total);
	return 0;
}


