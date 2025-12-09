module day09;
import std::io;
import std::collections::list;
import std::math;

fn int main(String[] args) {
	io::printn(part1());
	return 0;
}

fn ulong part1() {
	Vertex[] vertices = read_vertices();
	return find_biggest_rectangle(vertices);
}

struct Vertex {
	long x;
	long y;
}

fn usz? Vertex.to_format(&self, Formatter* formatter) @dynamic {
	return formatter.printf("(%d, %d)", self.x, self.y)!;
}

fn long Vertex.area(self, Vertex other) => math::abs(self.x - other.x + 1) * math::abs(self.y - other.y + 1);

fn Vertex[] read_vertices(Allocator allocator = tmem) => @pool() {
	List{Vertex} ret;
	ret.tinit();

	while(try line = io::treadline()) {
		String[] splitted = line.tsplit(",");
		ret.push((Vertex){splitted[0].to_ulong() - 1, splitted[1].to_ulong() - 1})!!;
	}

	return ret.to_array(allocator);
}

fn ulong find_biggest_rectangle(Vertex[] vertices) {
	ulong ret = 0;
	for(usz i = 0; i < vertices.len; i++) {
		for(usz j = i + 1; j < vertices.len; j++) {
			ret = max(ret, vertices[i].area(vertices[j]));
		}
	}
	return ret;
}
