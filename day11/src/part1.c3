module aoc::day11;
import std::io;
import std::collections::linkedlist;
import std::collections::map;

fn long part1() => @pool() {
    Graph graph = read_graph();
    assert(graph.you != -1);
    assert(graph.out != -1);
    io::printn(graph);
    HashMap{usz, long} visited;
    visited.tinit();
    return graph.find_all_paths(&visited, graph.you);
}

fn long Graph.find_all_paths(self, HashMap{usz, long}* visited, usz current) {
    if(current == self.out) {
        return 1;
    }
    long ret = 0;

    foreach(next : self.nodes[current].next) {
        ret += self.find_all_paths(visited, next);
    }

    (*visited)[current] = ret;
    return ret;
}
