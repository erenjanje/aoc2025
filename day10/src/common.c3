module aoc::day10;
import std::collections::bitset;
import std::collections::set;
import std::io;
import std::core::mem::allocator;

const BITNUM = 10;
alias LightState = BitSet{BITNUM};

struct Machine {
    LightState lights;
    LightState[] button_wiring;
    int[] joltages;
}

fn usz? LightState.to_format(&self, Formatter* formatter) @dynamic {
    for(usz i = 0; i < BITNUM; i++) {
        if((*self)[i]) {
            formatter.printf("%c", '1')!;
        } else {
            formatter.printf("%c", '0')!;
        }
    }
    return BITNUM;
}

fn bool LightState.eq(self, LightState other) @operator(==) => self.data[0] == other.data[0];

fn Machine parse_machine(String description, Allocator allocator = tmem) => @pool() {
    Machine ret;

    usz start_of_lights = 0;
    usz end_of_lights = description.index_of_char(']')!!;
    String lights_description = description[(start_of_lights + 1)..(end_of_lights - 1)];

    for(usz i = 0; i < lights_description.len; i++) {
        if(lights_description[i] == '#') {
            ret.lights.set(i);
        } else {
            ret.lights.unset(i);
        }
    }

    usz start_of_wiring = end_of_lights + 1;
    usz end_of_wiring = description.index_of_char('{')!!;
    String[] wiring_descriptions = description[(start_of_wiring + 1)..(end_of_wiring - 1)].tsplit(" ", skip_empty: true);
    ret.button_wiring = allocator::new_array(allocator, LightState, wiring_descriptions.len);
    for(usz i = 0; i < wiring_descriptions.len; i++) {
        String[] splitted = wiring_descriptions[i][1..^2].tsplit(",");
        LightState pushed;
        foreach(split : splitted) {
            usz index = split.to_ulong()!!;
            pushed[index] = true;
        }
        ret.button_wiring[i] = pushed;
    }

    usz start_of_joltages = end_of_wiring + 1;
    usz end_of_joltages = description.len - 2;
    String joltage_string = description[start_of_joltages..end_of_joltages];
    String[] joltages_string = joltage_string.tsplit(",");
    ret.joltages = allocator::new_array(allocator, int, joltages_string.len);
    for(usz i = 0; i < joltages_string.len; i++) {
        ret.joltages[i] = joltages_string[i].to_int()!!;
    }

    return ret;
}
