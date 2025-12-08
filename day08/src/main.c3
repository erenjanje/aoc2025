module day08;
import std::io;
import std::collections::list;
import std::collections::set;
import std::sort;

struct Vertex {
	int x;
	int y;
	int z;
}

macro bool Vertex.equals(self, Vertex other) @operator(==) {
	return self.x == other.x && self.y == other.y && self.z == other.z;
}

fn ulong Vertex.distance2(self, Vertex other) {
	return (ulong)((self.x-other.x)*(self.x-other.x) + (self.y-other.y)*(self.y-other.y) + (self.z-other.z)*(self.z-other.z));
}

struct Edge {
	usz v1;
	usz v2;
	ulong dist;
}

fn usz? Vertex.to_format(&self, Formatter* formatter) @dynamic {
	return formatter.printf("(%d, %d, %d)", self.x, self.y, self.z)!;
}

fn usz? Edge.to_format(&self, Formatter* formatter) @dynamic {
	return formatter.printf("dist(%d, %d, %d)", self.v1, self.v2, self.dist)!;
}

fn int Edge.cmp(lhs, Edge rhs) {
	if(lhs.dist == rhs.dist) {
		return 0;
	} else if(lhs.dist < rhs.dist) {
		return -1;
	} else {
		return 1;
	}
}

fn Vertex[] read_vertices(Allocator allocator = tmem) => @pool() {
	List{Vertex} ret;
	ret.tinit();

	while(try line = io::treadline()) {
		String[] coords = line.tsplit(",");
		ret.push((Vertex){coords[0].to_int(), coords[1].to_int(), coords[2].to_int()})!!;
	}

	return ret.to_array(allocator);
}

fn Edge[] Vertex[].calculate_edges(vertices, Allocator allocator = tmem) {
	List{Edge} ret;
	ret.tinit();
	ret.reserve(vertices.len * (vertices.len + 1) / 2);

	for(usz i = 0; i < vertices.len; i++) {
		for(usz j = i + 1; j < vertices.len; j++) {
			ret.push((Edge){i, j, vertices[i].distance2(vertices[j])});
		}
	}

	return ret.to_array(allocator);
}

alias ConnectedComponent = HashSet{usz};

fn int ConnectedComponent.cmp(&lhs, ConnectedComponent* rhs) {
	if(lhs.len() == rhs.len()) {
		return 0;
	} else if(lhs.len() < rhs.len()) {
		return -1;
	} else {
		return 1;
	}
}

fn int main(String[] args) => @pool() {
	Vertex[] vertices = read_vertices();
	Edge[] edges = vertices.calculate_edges();
	sort::quicksort(edges, &Edge.cmp);

	List{ConnectedComponent} components;
	components.tinit(1000);

	foreach(&edge : edges[:1000]) {
		put_to_connected_components(&components, *edge);
	}
	sort::quicksort(components.array_view(), fn int(ConnectedComponent* lhs, ConnectedComponent* rhs) => -lhs.cmp(rhs));
	io::printn(components);
	ulong result = 1;
	foreach(&component : components.array_view()[:3]) {
		io::printf("%d ", component.len());
		result *= component.len();
	}
	io::printn(" ");
	io::printn(result);

	return 0;
}

fn void put_to_connected_components(List{ConnectedComponent}* components, Edge edge, Allocator allocator = tmem) {
	isz found = -1;
	for(usz i = 0; i < components.len(); i++) {
		ConnectedComponent* component = &(*components)[i];
		bool contains1 = component.contains(edge.v1);
		bool contains2 = component.contains(edge.v2);

		if(contains1 || contains2) {
			if(found == -1) {
				component.add_all((usz[]){edge.v1, edge.v2});
				found = i;
			} else {
				(*components)[found].add_all_from(component);
				components.remove_at(i);
				i -= 1;
			}
		}
	}

	if(found == -1) {
		ConnectedComponent new_component;
		new_component.init(allocator, capacity: 2);
		new_component.add_all((usz[]){edge.v1, edge.v2});
		components.push(new_component);
	}
}
