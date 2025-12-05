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

	io::printn(ranges);
	ranges = ranges.merge();
	io::printn(ranges);

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
	io::printn(result);
	io::printn(total);
	return 0;
}

fn bool IdRange.intersects(self, IdRange other)  {
	return other.contains(self.start) || other.contains(self.end) || self.contains(other.start) || self.contains(other.end);
}

fn IdRange IdRange.merge(self, IdRange other) {
	return (IdRange){.start = min(self.start, other.start), .end = max(self.end, other.end)};
}

fn List{IdRange} List{IdRange}.merge(self, Allocator allocator = tmem) {
	List{IdRange} new_range;
	new_range.init(allocator);

	foreach(candidate_range : self) {
		bool merged = false;
		for(usz i = 0; i < new_range.len(); i++) {
			if(new_range[i].intersects(candidate_range)) {
				new_range[i] = new_range[i].merge(candidate_range);
				merged = true;
				break;
			}
		}
		if(!merged) {
			new_range.push(candidate_range);
		} else {
			new_range = new_range.merge();
		}
	}

	return new_range;
}
