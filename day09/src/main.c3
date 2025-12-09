module day09;
import std::io;
import std::collections::list;
import std::math;
import std::core::mem::allocator;

fn int main(String[] args) {
	io::printn(part2());
	return 0;
}

fn ulong part1() => @pool() {
	Vertex[] vertices = read_vertices();
	vertices.print();
	vertices.outer_vertices().print();
	return find_biggest_rectangle(vertices);
}

fn ulong part2() => @pool() {
	Vertex[] vertices = read_vertices();
	// vertices.print();
	// vertices.outer_vertices().print();
	return find_biggest_rectangle(vertices, true);
}

// fn ulong part2() {
// 	Vertex[] vertices = read_vertices();
// 	return find_biggest_overlapping_rectangle(vertices);
// }

struct Vertex {
	long x;
	long y;
}

macro Vertex vertex(long x, long y)
	=> (Vertex){x, y};

fn usz? Vertex.to_format(&self, Formatter* formatter) @dynamic
	=> formatter.printf("(%d, %d)", self.x, self.y)!;

fn bool Vertex.is_contained_by(self, Vertex v1, Vertex v2)
	=> min(v1.x, v2.x) <= self.x && self.x <= max(v1.x, v2.x)
	&& min(v1.y, v2.y) <= self.y && self.y <= max(v1.y, v2.y);

fn Vertex Vertex.add(lhs, Vertex rhs) @operator(+) => (Vertex){lhs.x + rhs.x, lhs.y + rhs.y};
fn Vertex Vertex.sub(lhs, Vertex rhs) @operator(-) => (Vertex){lhs.x - rhs.x, lhs.y - rhs.y};
fn Vertex Vertex.sign(self) => (Vertex){math::sign(self.x), math::sign(self.y)};
fn Vertex Vertex.unm(self) => (Vertex){-self.x, -self.y};
fn Vertex Vertex.mul(lhs, long rhs) @operator(*) => (Vertex){lhs.x * rhs, lhs.y * rhs};
fn long Vertex.cross(lhs, Vertex rhs) => lhs.x*rhs.y - lhs.y*rhs.x;
fn bool Vertex.eq(lhs, Vertex rhs) @operator(==) => lhs.x == rhs.x && lhs.y == rhs.y;

fn void Vertex[].print(self) => @pool() {
	Rect bounding_box = self.bounding_box();
	long w = bounding_box.width();
	long h = bounding_box.height();
	io::printn(bounding_box);
	char[][] printed = allocator::new_array(tmem, char[], h);
	foreach(&row : printed) {
		*row = allocator::new_array(tmem, char, w);
		foreach(&c : *row) {
			*c = '.';
		}
	}

	self.@circumference(; Vertex curr) {
		printed[curr.y - bounding_box.min.y][curr.x - bounding_box.min.x] = 'X';
	};
	foreach(curr : self) {
		printed[curr.y - bounding_box.min.y][curr.x - bounding_box.min.x] = '#';
	}

	foreach(vertex : self) {
		printed[vertex.y - bounding_box.min.y][vertex.x - bounding_box.min.x] = '#';
	}

	for(long r = 0; r < bounding_box.min.y; r++) {
		for(long c = 0; c <= bounding_box.max.x; c++) {
			io::print(".");
		}
		for(long c = 0; c < 2; c++) {
			io::print(".");
		}
		io::printn("");
	}
	for(long r = 0; r < h; r++) {
		for(long c = 0; c < bounding_box.min.x; c++) {
			io::print(".");
		}
		for(long c = 0; c < w; c++) {
			io::printf("%c", printed[r][c]);
		}
		for(long c = 0; c < 2; c++) {
			io::print(".");
		}
		io::printn("");
	}
	for(long r = 0; r < 1; r++) {
		for(long c = 0; c <= bounding_box.max.x; c++) {
			io::print(".");
		}
		for(long c = 0; c < 2; c++) {
			io::print(".");
		}
		io::printn("");
	}
}

fn Rect Vertex[].bounding_box(self) {
	long min_x = ~(1l << 63l);
	long min_y = ~(1l << 63l);
	long max_x = 0;
	long max_y = 0;

	foreach(vertex : self) {
		min_x = min(min_x, vertex.x);
		min_y = min(min_y, vertex.y);
		max_x = max(max_x, vertex.x);
		max_y = max(max_y, vertex.y);
	}

	return rect(vertex(min_x, min_y), vertex(max_x, max_y));
}

macro Vertex[].@circumference(self; @body(Vertex v)) {
	for(usz i = 0; i < self.len; i++) {
		Vertex curr = self[i];
		Vertex next = self[(i + 1) % self.len];
		Vertex diff = (next - curr).sign();
		while(curr != next) {
			@body(curr);
			curr = curr + diff;
		}
	}
}

fn Vertex[] Vertex[].outer_vertices(self, Allocator allocator = tmem) {
	Vertex[] ret = allocator::new_array(allocator, Vertex, self.len);

	for(long i = 0; i < self.len; i++) {
		Vertex prev = self[((i - 1) % self.len + self.len) % self.len];
		Vertex curr = self[i];
		Vertex next = self[(i + 1) % self.len];

		Vertex e1 = (curr - prev).sign();
		Vertex e2 = (curr - next).sign();

		ret[i] = curr - (e1 + e2) * e1.cross(e2);
	}

	return ret;
}

struct Rect {
	Vertex min;
	Vertex max;
}

fn usz? Rect.to_format(&self, Formatter* formatter) @dynamic {
	return formatter.printf("rect(%s, %s)", self.min, self.max)!;
}

macro Rect rect(Vertex c1, Vertex c2)
	=> (Rect){(Vertex){min(c1.x, c2.x), min(c1.y, c2.y)}, (Vertex){max(c1.x, c2.x), max(c1.y, c2.y)}};

macro bool Rect.contains(self, Vertex v)
	=> self.min.x <= v.x && v.x <= self.max.x
	&& self.min.y <= v.y && v.y <= self.max.y;

macro bool Rect.intersects(self, Rect other)
	=> self.min.x <= other.max.x && self.max.x >= other.min.x
	&& self.min.y <= other.max.y && self.max.y >= other.min.y;

macro long Rect.width(self) => self.max.x - self.min.x + 1;
macro long Rect.height(self) => self.max.y - self.min.y + 1;

macro long Rect.area(self) => (((self.width() - 1) / 4) + 1) * (((self.height() - 1) / 4) + 1);

fn Vertex[] read_vertices(Allocator allocator = tmem) => @pool() {
	List{Vertex} ret;
	ret.tinit();

	while(try line = io::treadline()) {
		String[] splitted = line.tsplit(",");
		ret.push((Vertex){splitted[0].to_ulong() * 4, splitted[1].to_ulong() * 4})!!;
	}

	return ret.to_array(allocator);
}

fn ulong find_biggest_rectangle(Vertex[] vertices, bool remove_outer = false) => @pool() {
	ulong ret = 0;
	Vertex v1;
	Vertex v2;
	Vertex[] outer_vertices;
	if(remove_outer) {
		outer_vertices = vertices.outer_vertices();
	}
	for(usz i = 0; i < vertices.len; i++) {
		for(usz j = i + 1; j < vertices.len; j++) {
			Rect r = rect(vertices[i], vertices[j]);
			if(remove_outer) {
				bool outer = false;
				for(long o = 0; o < outer_vertices.len; o++) {
					Vertex curr = outer_vertices[o];
					Vertex next = outer_vertices[(o + 1) % outer_vertices.len];

					if(r.intersects(rect(curr, next))) {
						outer = true;
						break;
					}
				}
				if(outer) {
					continue;
				}
			}
			if(ret < r.area()) {
				ret = r.area();
				v1 = vertices[i];
				v2 = vertices[j];
			}
		}
	}
	io::printn(v1);
	io::printn(v2);
	return ret;
}
