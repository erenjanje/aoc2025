from typing import NamedTuple, TypeAlias
from functools import reduce
import sys

class Vertex(NamedTuple):
    x: int
    y: int
    z: int

class Edge(NamedTuple):
    v1: int
    v2: int
    dist: int
    @classmethod
    def create(cls, v1: int, v2: int, vertices: list[Vertex]):
        return cls(v1, v2, (vertices[v1].x - vertices[v2].x)**2 + (vertices[v1].y - vertices[v2].y)**2 + (vertices[v1].z - vertices[v2].z)**2)
    
ConnectedComponent: TypeAlias = set[int]

def read_vertices() -> list[Vertex]:
    ret: list[Vertex] = []
    for line in sys.stdin:
        splitted = line.split(",")
        v = Vertex(int(splitted[0]), int(splitted[1]), int(splitted[2]))
        ret.append(v)
    return ret

def calculate_edges(vertices: list[Vertex]) -> list[Edge]:
    ret: list[Edge] = []
    for i in range(len(vertices)):
        for j in range(i + 1, len(vertices)):
            ret.append(Edge.create(i, j, vertices))
    return ret

def put_to_connected_components(components: list[ConnectedComponent], edge: Edge):
    found: int = -1
    i: int = 0
    while i < len(components):
        component = components[i]
        if edge.v1 in component or edge.v2 in component:
            if found == -1:
                component.update((edge.v1, edge.v2))
                found = i
            else:
                components[found].update(component)
                del components[i]
                i -= 1
        i += 1
    if found == -1:
        components.append({edge.v1, edge.v2})


def part1():
    vertices: list[Vertex] = read_vertices()
    edges: list[Edge] = calculate_edges(vertices)
    components: list[ConnectedComponent] = []
    edges.sort(key=lambda e: e.dist)
    for edge in edges[:1000]:
        put_to_connected_components(components, edge)
    components.sort(key=lambda component: -len(component))
    result: int = reduce(lambda accumulator, component: accumulator * len(component), components[:3], 1)
    print(result)

def part2():
    vertices: list[Vertex] = read_vertices()
    edges: list[Edge] = calculate_edges(vertices)
    components: list[ConnectedComponent] = []
    edges.sort(key=lambda e: e.dist)
    for edge in edges:
        put_to_connected_components(components, edge)
        if len(components) == 1 and len(components[0]) == len(vertices):
            print(vertices[edge.v1].x * vertices[edge.v2].x)
            break

if __name__ == '__main__':
    part1()