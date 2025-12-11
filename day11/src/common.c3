module aoc::day11;
import std::io;
import std::collections::list;
import std::collections::map;

struct Node {
    usz[] next;
}

struct Graph {
    Node[] nodes;
    isz you;
    isz out;
    isz svr;
    isz dac;
    isz fft;
}

fn usz? Node.to_format(&self, Formatter* formatter) @dynamic {
    return formatter.printf("%s", self.next)!;
}

fn usz? Graph.to_format(&self, Formatter* formatter) @dynamic {
    return formatter.printf("(you: %d, out: %d) %s", self.you, self.out, self.nodes)!;
}

fn Graph read_graph(Allocator allocator = tmem) => @pool() {
    Graph ret;
    List{Node} nodes;
    nodes.tinit();

    HashMap{String, usz} mapping;
    mapping.tinit();

    while(try String line = io::treadline()) {
        usz separator = line.index_of_char(':')!!;
        String from = line[..(separator-1)];
        String[] to = line[(separator+1)..].tsplit(" ", skip_empty: true);
        List{usz} next;
        next.tinit(to.len);
        foreach(n : to) {
            next.push(get_or_create(&mapping, &nodes, n));
        }
        nodes[get_or_create(&mapping, &nodes, from)].next = next.to_array(allocator);
    }

    io::printn(mapping);

    return (Graph){nodes.to_array(allocator), mapping["you"] ?? -1, mapping["out"] ?? -1, mapping["svr"] ?? -1, mapping["dac"] ?? -1, mapping["fft"] ?? -1};
}

fn usz get_or_create(HashMap{String, usz}* mapping, List{Node}* nodes, String node) {
    if(mapping.has_key(node)) {
        return mapping.get(node)!!;
    } else {
        usz pos = nodes.len();
        nodes.push((Node){});
        mapping.set(node, pos);
        return pos;
    }
}
