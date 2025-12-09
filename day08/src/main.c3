module day08;
import std::io;
import std::collections::list;
import std::collections::set;
import std::sort;

fn int main(String[] args) => @pool() {
	io::printn(part2());
	return 0;
}

fn ulong part1() {
	Vertex[] vertices = read_vertices();
	Edge[] edges = vertices.calculate_edges();
	sort::quicksort(edges, &Edge.cmp);

	List{ConnectedComponent} components;
	components.tinit(1000);

	foreach(&edge : edges[:1000]) {
		put_to_connected_components(&components, *edge);
	}
	sort::quicksort(&components, fn int(ConnectedComponent* lhs, ConnectedComponent* rhs) => -lhs.cmp(rhs));
	ulong result = array::@reduce(components.array_view()[:3], 1, fn(accumulator, component, ulong) => accumulator * component.len());
	return result;
}

fn ulong part2() {
	Vertex[] vertices = read_vertices();
	Edge[] edges = vertices.calculate_edges();
	sort::quicksort(edges, &Edge.cmp);

	List{ConnectedComponent} components;
	components.tinit(1000);

	foreach(&edge : edges) {
		put_to_connected_components(&components, *edge);
		if(components.len() == 1 && components[0].len() == vertices.len) {
			return vertices[edge.v1].x * vertices[edge.v2].x;
		}
	}

	return 0;
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

struct Vertex {
	long x;
	long y;
	long z;
}

fn ulong Vertex.distance2(self, Vertex other) {
	long dx = self.x-other.x;
	long dy = self.y-other.y;
	long dz = self.z-other.z;
	return (ulong)(dx*dx + dy*dy + dz*dz);
}
fn usz? Vertex.to_format(&self, Formatter* formatter) @dynamic {
	return formatter.printf("(%d, %d, %d)", self.x, self.y, self.z)!;
}

struct Edge {
	usz v1;
	usz v2;
	ulong dist;
}

fn usz? Edge.to_format(&self, Formatter* formatter) @dynamic {
	return formatter.printf("dist(%d, %d, %d)", self.v1, self.v2, self.dist)!;
}

fn int Edge.cmp(lhs, Edge rhs) => cmp(lhs.dist, rhs.dist);

alias ConnectedComponent = HashSet{usz};
fn int ConnectedComponent.cmp(&lhs, ConnectedComponent* rhs) => cmp(lhs.len(), rhs.len());
fn int ConnectedComponent.rcmp(&lhs, ConnectedComponent* rhs) => rcmp(lhs.len(), rhs.len());

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

fn int cmp(ulong l, ulong r) {
	if(l == r) {
		return 0;
	} else if(l < r) {
		return -1;
	} else {
		return 1;
	}
}

fn int rcmp(ulong l, ulong r) {
	return -cmp(l, r);
}
