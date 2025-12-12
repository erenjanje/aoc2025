module aoc::day12;
import std::io;
import std::core::mem::allocator;
import std::collections::map;

fn long part1() {
    Input input = parse();
    long ret = 0;
    int i = 0;
    foreach(tree : input.trees) {
        i += 1;
        // io::printfn("Doing %d", i);
        if(tree.solve(input.presents)) {
            ret += 1;
        }
    }
    return ret;
}

fn bool Tree.solve(self, Present[6] presents) => @pool() {
    int area = 0;
    for(usz i = 0; i < 6; i++) {
        area += presents[i].area() * self.needs[i];
    }
    io::printfn("%d %d %d", area, self.shape[0] * self.shape[1], area - self.shape[0] * self.shape[1]);
    if(area > self.shape[0] * self.shape[1]) {
        return false;
    } else {
        return true;
    }
    isz first = self.needs.get_first_needed();
    bool[][] matrix = new_matrix(self.shape);
    HashMap{State, bool} table;
    table.tinit();
    for(int i = 0; i < self.shape[0] - 2; i++) {
        for(int j = 0; j < self.shape[1] - 2; j++) {
            int[2] pos = {i, j};
            for(int v = 0; v < 20; v++) {
                State state = {first, pos, v, self.needs};
                if(self.fits_with_this(state, &table, matrix, presents)) {
                    table[state] = true;
                    return true;
                }
            }
        }
    }
    return false;
}

struct State {
    isz current;
    int[2] pos;
    usz variant;
    int[6] needs;
}

fn usz? State.to_format(&self, Formatter* formatter) @dynamic {
	return formatter.printf("%d %s %d %s", self.current, self.pos, self.variant, self.needs)!;
}

fn uint State.hash(&self)
    => self.current.hash()
     + self.pos[0].hash() + self.pos[1].hash()
     + self.variant.hash()
     + self.needs[0].hash() + self.needs[1].hash() + self.needs[2].hash() + self.needs[3].hash() + self.needs[4].hash() + self.needs[5].hash();

fn bool State.equals(self, State other) @operator(==)
    => self.current == other.current
    && self.pos == other.pos
    && self.variant == other.variant
    && self.needs == other.needs;

fn bool Tree.fits_with_this(self, State state, HashMap{State, bool}* table, bool[][] matrix, Present[6] presents) => @pool() {
    if(state.current == -1) {
        return true;
    }
    if(table.has_key(state)) {
        return (*table)[state]!!;
    }

    Present put             = presents[state.current];
    Present put_rot90       = put.rotate();
    Present put_rot180      = put_rot90.rotate();
    Present put_rot270      = put_rot180.rotate();
    Present vflip           = put.vflip();
    Present vflip_rot90     = vflip.rotate();
    Present vflip_rot180    = vflip_rot90.rotate();
    Present vflip_rot270    = vflip_rot180.rotate();
    Present hflip           = put.hflip();
    Present hflip_rot90     = hflip.rotate();
    Present hflip_rot180    = hflip_rot90.rotate();
    Present hflip_rot270    = hflip_rot180.rotate();
    Present flip            = put.flip();
    Present flip_rot90      = flip.rotate();
    Present flip_rot180     = flip_rot90.rotate();
    Present flip_rot270     = flip_rot180.rotate();
    Present vhflip          = put.vflip().hflip();
    Present vhflip_rot90    = vhflip.rotate();
    Present vhflip_rot180   = vhflip_rot90.rotate();
    Present vhflip_rot270   = vhflip_rot180.rotate();

    Present[] tries = {
        put            ,
        put_rot90      ,
        put_rot180     ,
        put_rot270     ,
        vflip          ,
        vflip_rot90    ,
        vflip_rot180   ,
        vflip_rot270   ,
        hflip          ,
        hflip_rot90    ,
        hflip_rot180   ,
        hflip_rot270   ,
        flip           ,
        flip_rot90     ,
        flip_rot180    ,
        flip_rot270    ,
        vhflip         ,
        vhflip_rot90   ,
        vhflip_rot180  ,
        vhflip_rot270  ,
    };

    if(!tries[state.variant].can_be_put(state.pos, matrix)) {
        (*table)[state] = false;
        return false;
    }

    matrix = tries[state.variant].put(state.pos, matrix);

    state.needs[state.current] -= 1;

    bool ret = false;

    isz next_one = state.needs.get_first_needed();

    // io::printn(state);

    for(int i = 0; i < matrix.len - 2; i++) {
        for(int j = 0; j < matrix[0].len - 2; j++) {
            int[2] new_pos = {i, j};
            for(usz t = 0; t < tries.len; t++) {
                if(self.fits_with_this((State){next_one, new_pos, t, state.needs}, table, matrix, presents)) {
                    (*table)[state] = true;
                    return true;
                }
            }
        }
    }

    (*table)[state] = false;
    return false;
}

fn bool[][] Present.put(self, int[2] at, bool[][] matrix, Allocator allocator = tmem) {
    bool[][] ret = matrix.copy(allocator);
    for(usz i = 0; i < 3; i++) {
        for(usz j = 0; j < 3; j++) {
            if(self[i][j]) {
                ret[at[0] + i][at[1] + j] = true;
            }
        }
    }
    return ret;
}

fn bool Present.can_be_put(self, int[2] at, bool[][] matrix) {
    for(usz i = 0; i < 3; i++) {
        for(usz j = 0; j < 3; j++) {
            // io::print(at);
            // io::printfn("(%d %d)", i, j);
            if(self[i][j]&& matrix[at[0] + i][at[1] + j]) {
                return false;
            }
        }
    }
    return true;
}

fn int Present.area(self) =>
    (int)self[0][0] + (int)self[0][1] + (int)self[0][2] +
    (int)self[1][0] + (int)self[1][1] + (int)self[1][2] +
    (int)self[2][0] + (int)self[2][1] + (int)self[2][2];

fn Present Present.rotate(self)
    => (Present){
        {self[0][2], self[1][2], self[2][2]},
        {self[0][1], self[1][1], self[2][1]},
        {self[0][0], self[1][0], self[2][0]}
    };

fn Present Present.vflip(self)
    => (Present){
        {self[0][2], self[0][1], self[0][0]},
        {self[1][2], self[1][1], self[1][0]},
        {self[2][2], self[2][1], self[2][0]}
    };

fn Present Present.hflip(self)
    => (Present){
        {self[2][0], self[2][1], self[2][2]},
        {self[1][0], self[1][1], self[1][2]},
        {self[0][0], self[0][1], self[0][2]}
    };

fn Present Present.flip(self)
    => (Present){
        {self[0][0], self[1][0], self[2][0]},
        {self[0][1], self[1][1], self[2][1]},
        {self[0][2], self[1][2], self[2][2]}
    };


fn bool[][] new_matrix(int[2] shape, Allocator allocator = tmem) {
    bool[][] ret = allocator::new_array(allocator, bool[], shape[0]);
    for(usz i = 0; i < ret.len; i++) {
        ret[i] = allocator::new_array(allocator, bool, shape[1]);
    }
    return ret;
}

fn bool[][] bool[][].copy(self, Allocator allocator = tmem) {
    bool[][] ret = new_matrix((int[2]){self.len, self[0].len}, allocator);
    for(usz i = 0; i < ret.len; i++) {
        for(usz j = 0; j < ret[i].len; j++) {
            ret[i][j] = self[i][j];
        }
    }
    return ret;
}

fn isz int[6].get_first_needed(&self) {
    for(usz i = 0; i < 6; i++) {
        if((*self)[i] != 0) {
            return i;
        }
    }
    return -1;
}
