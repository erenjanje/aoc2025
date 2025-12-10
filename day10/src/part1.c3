module aoc::day10::part1;
import std::io;
import std::collections::set;
import std::collections::linkedlist;

fn long run() => @pool() {
    long total = 0;
    while(try String description = io::treadline()) {
        Machine machine = day10::parse_machine(description);
        long result = machine.push_buttons();
        total += result;
    }
    return total;
}

struct Context {
    LightState state;
    long depth;
}

fn long Machine.push_buttons(&self) => @pool() {
    HashSet{uint} visited;
    visited.tinit();
    LinkedList{Context} contexes;
    contexes.tinit();
    contexes.push((Context){(LightState){}, 0});

    while(try Context current = contexes.pop_front()) {
        if(current.state == self.lights) {
            return current.depth;
        }
        foreach(push : self.button_wiring) {
            LightState new_state = current.state ^ push;
            uint new_state_int = new_state.data[0];
            if(!visited.contains(new_state_int)) {
                contexes.push((Context){new_state, current.depth + 1});
                visited.add(new_state_int);
            }
        }
    }
    return 0;
}
