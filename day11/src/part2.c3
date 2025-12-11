module aoc::day11;
import std::io;
import std::collections::set;
import std::collections::map;

fn long part2() => @pool() {
    Graph graph = read_graph();
    assert(graph.svr != -1);
    assert(graph.fft != -1);
    assert(graph.dac != -1);
    assert(graph.out != -1);
    io::printn(graph);
    HashMap{TableElement, long} results;
    results.tinit();
    return graph.find_all_paths_through(graph.svr, &results);
}

struct TableElement {
    usz current;
    bool found_fft;
    bool found_dac;
}

fn uint TableElement.hash(&self) => self.current.hash() + self.found_fft.hash() + self.found_dac.hash();
fn bool TableElement.equals(self, TableElement other) @operator(==)
    => self.current == other.current && self.found_fft == other.found_fft && self.found_dac == other.found_dac;

fn long Graph.find_all_paths_through(self, usz current, HashMap{TableElement, long}* table, bool found_fft = false, bool found_dac = false) => @pool() {
    TableElement element = {current, found_fft, found_dac};
    if(table.has_key(element)) {
        return table.get(element)!!;
    }

    if(current == self.out) {
        if(found_fft && found_dac) {
            return 1;
        } else {
            return 0;
        }
    }
    long ret = 0;
    found_fft = found_fft || (current == self.fft);
    found_dac = found_dac || (current == self.dac);

    foreach(next : self.nodes[current].next) {
        ret += self.find_all_paths_through(next, table, found_fft, found_dac);
    }
    
    table.set(element, ret);

    return ret;
}
