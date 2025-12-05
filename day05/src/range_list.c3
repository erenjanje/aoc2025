module range_list{Type};
import std::collections::range;
import std::collections::list;
import std::sort;
import std::io;

struct RangeList {
	List{Range{Type}} list;
}

alias InnerRange = Range{Type};

fn RangeList new(Range{Type}[] ranges, Allocator allocator = tmem) => @pool() {
	RangeList ret;
	ret.list.init(allocator);
	ret.list.reserve(ranges.len);

	List{InnerRange} copy;
	copy.tinit();
	copy.reserve(ranges.len);
	copy.push_all(ranges);

	sort::quicksort(copy.array_view(), fn int(Range{Type} lhs, Range{Type} rhs) => lhs.start == rhs.start ? 0 : (lhs.start < rhs.start ? -1 : 1));

	for(usz current = 0; current < copy.len(); current++) {
		usz candidate;
		for(candidate = current + 1; candidate < copy.len(); candidate++) {
			if(copy[current].intersects(copy[candidate])) {
				copy[current] = copy[current].merge(copy[candidate]);
			} else {
				break;
			}
		}
		ret.list.push(copy[current]);
		current = candidate - 1;
	}

	return ret;
}

fn bool RangeList.contains(&self, Type point) {
	foreach(range : self.list) {
		if(range.contains(point)) {
			return true;
		}
	}
	return false;
}

fn bool Range{Type}.intersects(self, Range{Type} other) @private {
	return other.contains(self.start) || other.contains(self.end) || self.contains(other.start) || self.contains(other.end);
}

fn Range{Type} Range{Type}.merge(self, Range{Type} other) @private {
	return (Range{Type}){.start = min(self.start, other.start), .end = max(self.end, other.end)};
}
