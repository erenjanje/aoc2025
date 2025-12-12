module aoc::day12;
import std::io;
import std::collections::list;

fn Input parse(Allocator allocator = tmem) => @pool() {
    Input ret;
    for(usz i = 0; i < 6; i++) {
        String index = io::treadline()!!;
        String[3] rows = (String[3]){io::treadline(), io::treadline(), io::treadline()}!!;
        io::treadline()!!;
        ret.presents[i] = new_shape(rows);
    }

    List{Tree} trees;
    trees.tinit();
    while(try String tree_description = io::treadline()) {
        Tree tree = {};

        usz colon_position = tree_description.index_of_char(':')!!;
        String shape_description = tree_description[..(colon_position - 1)];
        String needs_description = tree_description[(colon_position + 2)..];

        usz x_position = shape_description.index_of_char('x')!!;
        String row_description = shape_description[..(x_position - 1)];
        String col_description = shape_description[(x_position + 1)..];
        tree.shape = (int[2]){row_description.to_int(), col_description.to_int()}!!;

        String[] needs_descriptions = needs_description.tsplit(" ", skip_empty: true);
        for(usz i = 0; i < 6; i++) {
            tree.needs[i] = needs_descriptions[i].to_int()!!;
        }

        trees.push(tree);
    }

    ret.trees = trees.to_array(allocator);

    return ret;
}

alias Present = bool[3][3];

macro char bool.chr(self) => self ? '#' : '.';

fn usz? Present.to_format(&self, Formatter* formatter) @dynamic {
    *self = self.flip();
	return formatter.printf("\n%c%c%c\n%c%c%c\n%c%c%c\n", (*self)[0][0].chr(), (*self)[0][1].chr(), (*self)[0][2].chr(), (*self)[1][0].chr(), (*self)[1][1].chr(), (*self)[1][2].chr(), (*self)[2][0].chr(), (*self)[2][1].chr(), (*self)[2][2].chr())!;
}


fn Present new_shape(String[3] inputs) {
    Present ret = {};
    for(usz i = 0; i < 3; i++) {
        for(usz j = 0; j < 3; j++) {
            ret[i][j] = inputs[i][j] == '#';
        }
    }
    return ret;
}

struct Tree {
    int[2] shape;
    int[6] needs;
}

fn usz? Tree.to_format(&self, Formatter* formatter) @dynamic {
	return formatter.printf("(%s %s)", self.shape, self.needs)!;
}

struct Input {
    Present[6] presents;
    Tree[] trees;
}

fn usz? Input.to_format(&self, Formatter* formatter) @dynamic {
	return formatter.printf("(%s %s)", self.presents, self.trees)!;
}
