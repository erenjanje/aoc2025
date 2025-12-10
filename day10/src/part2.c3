module aoc::day10::part2;
import std::io;
import std::io::file;
import std::core::string;
import std::core::dstring;
import std::os::process;

fn long run() => @pool() {
    int line = 0;
    while(try String description = io::treadline()) {
        Machine machine = day10::parse_machine(description);
        String optimization = machine.get_optimization();
        File f = file::open(string::tformat("result/%d.lp", line), "w")!!;
        defer (void)f.close();

        f.write(optimization)!!;

        line += 1;
    }
    return 0;
}

fn String Machine.get_optimization(&self, Allocator allocator = tmem) => @pool() {
    DString ret = dstring::temp();

    ret.append_chars("Minimize\n obj:");
    for(usz i = 0; i < self.button_wiring.len; i++) {
        ret.append_chars(string::tformat(" x%d", i));
        if(i != self.button_wiring.len - 1) {
            ret.append_chars(" +");
        }
    }

    ret.append_chars("\nSubject To\n");
    for(usz i = 0; i < self.joltages.len; i++) {
        ret.append_chars(string::tformat(" c%d:", i));
        for(usz j = 0; j < self.button_wiring.len; j++) {
            if(self.button_wiring[j][i]) {
                ret.append_chars(string::tformat(" x%d +", j));
            }
        }
        ret.set(ret.len() - 1, '=');
        ret.append_chars(string::tformat(" %d\n", self.joltages[i]));
    }

    ret.append_chars("Bounds\n");
    for(usz i = 0; i < self.button_wiring.len; i++) {
        ret.append_chars(string::tformat(" 0 <= x%d\n", i));
    }

    ret.append_chars("End\n");

    return ret.str_view().copy(allocator);
}
