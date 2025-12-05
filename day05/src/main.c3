module day05;
import std::io;
import std::collections::range;
import std::collections::list;
import std::time::clock;
import range_list;

alias InnerRange = Range{ulong};

fn int main(String[] args) => @pool() {
	List{InnerRange} ranges;
	ranges.tinit();
	while(try String line = io::treadline()) {
		if(line.len == 0) { break; }
		String[] splitted = line.tsplit("-");
		Range{ulong} range = (Range{ulong}){.start = splitted[0].to_ulong(), .end = splitted[1].to_ulong()}!!;
		ranges.push(range);
	}

	List{ulong} queries;
	queries.tinit();

	while(try String line = io::treadline()) {
		queries.push(line.to_ulong())!!;
	}

	{
		Clock start = clock::now();
		for(int i = 0; i < 10000; i++) {
			RangeList{ulong} ids = range_list::new(ranges.array_view());
			ulong total = 0;
			foreach(range : ids.list) {
				total += range.len();
			}
		}
		Clock end = clock::now();
		ulong took = (ulong)(end - start);
		io::printfn("Construction Took\t%gms", (double)took * 1e-6 / 10000);
	}

	RangeList{ulong} ids = range_list::new(ranges.array_view());

	{
		Clock start = clock::now();
		for(int i = 0; i < 10000000; i++) {
			int result = 0;
			foreach(id : queries) {
				result += (int)ids.contains(id);
			}
		}
		Clock end = clock::now();
		ulong took = (ulong)(end - start);
		io::printfn("Query Took\t\t%gms", (double)took * 1e-6 / 10000000);
	}

	int result = 0;
	ulong total = 0;
	foreach(range : ids.list) {
		total += range.len();
	}
	foreach(id : queries) {
		result += (int)ids.contains(id);
	}

	io::printfn("Part 1: %d", result);
	io::printfn("Part 2: %d", total);
	return 0;
}

// fn RangeList{ulong} RangeList{ulong}.slow_merge(&self, Allocator allocator = tmem) {
// 	RangeList{ulong} ret;
// 	ret.init(allocator);

// 	foreach(candidate_range : self) {
// 		bool merged = false;
// 		for(usz i = 0; i < ret.len(); i++) {
// 			if(ret[i].intersects(candidate_range)) {
// 				ret[i] = ret[i].merge(candidate_range);
// 				merged = true;
// 				break;
// 			}
// 		}
// 		if(!merged) {
// 			ret.push(candidate_range);
// 		} else {
// 			ret = ret.slow_merge();
// 		}
// 	}

// 	return ret;
// }
