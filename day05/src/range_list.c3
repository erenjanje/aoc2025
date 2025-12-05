module range_list{Type};
import std::collections::range;
import std::collections::list;
import std::sort;

alias InnerRange = Range{Type};
alias RangeList = List{InnerRange};

fn bool Range{Type}.intersects(self, Range{Type} other) @private {
	return other.contains(self.start) || other.contains(self.end) || self.contains(other.start) || self.contains(other.end);
}

fn Range{Type} Range{Type}.merge(self, Range{Type} other) @private {
	return (Range{Type}){.start = min(self.start, other.start), .end = max(self.end, other.end)};
}

fn RangeList RangeList.merge(&self, Allocator allocator = tmem) {
	RangeList{Type} copy;
	copy.init(allocator);
	copy.reserve(self.len());
	copy.push_all(self.array_view());

	RangeList ret;
	ret.init(allocator);
	ret.reserve(self.len());

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
		ret.push(copy[current]);
		current = candidate - 1;
	}

	return ret;
}

fn RangeList RangeList.slow_merge(&self, Allocator allocator = tmem) {
	RangeList ret;
	ret.init(allocator);

	foreach(candidate_range : self) {
		bool merged = false;
		for(usz i = 0; i < ret.len(); i++) {
			if(ret[i].intersects(candidate_range)) {
				ret[i] = ret[i].merge(candidate_range);
				merged = true;
				break;
			}
		}
		if(!merged) {
			ret.push(candidate_range);
		} else {
			ret = ret.merge();
		}
	}

	return ret;
}
