use std::env;

const NUM_GENERATIONS: u64 = 50_000_000_000;

#[derive(Debug)]
struct Plants {
    state: Vec<char>,
    zero_index: isize,
    rules: Vec<(String, bool)>,
}

impl Plants {
    fn spread(&mut self) {
        let prev_state = self.state.clone();

        for i in 2..self.state.len() - 2 {
            let part: String = prev_state[i - 2..=i + 2].iter().collect();

            if let Some((_, live)) = self.rules.iter().find(|(notes, _)| *notes == part) {
                self.state[i] = if *live { '#' } else { '.' };
            } else {
                self.state[i] = '.';
            }
        }
    }

    fn num_alive(&self) -> usize {
        self.state.iter().filter(|c| **c == '#').count()
    }

    fn pot_numbers_sum(&self) -> isize {
        let mut sum = 0;
        for (index, item) in self.state.iter().enumerate() {
            let pot_number = index as isize - self.zero_index;
            if *item == '#' {
                sum += pot_number;
            }
        }
        sum
    }

    fn pattern(&self) -> String {
        let s = self.state.iter().collect::<String>();
        String::from(s.trim_matches('.'))
    }

    fn pad(&mut self) {
        for _i in 0..4 {
            self.state.insert(0, '.');
        }

        for _i in 0..20 {
            self.state.push('.');
        }

        self.zero_index = 4;
    }
}

fn parse_plants() -> Plants {
    let contents = include_str!("input.txt");
    let mut lines = contents.lines();
    let header = lines.next().unwrap();
    let parts: Vec<&str> = header.split(':').collect();
    lines.next();

    let rules: Vec<(String, bool)> = lines
        .map(|line| {
            let rule: Vec<&str> = line.split(" => ").collect();
            let notes = rule[0];
            let live = rule[1] == "#";
            (String::from(notes), live)
        })
        .collect();

    let mut plants = Plants {
        state: parts[1].trim().chars().collect(),
        zero_index: 0,
        rules: rules,
    };

    plants.pad();
    plants
}

fn part1() {
    let mut plants = parse_plants();

    for _gen in 1..=20 {
        plants.spread();
    }

    println!("{}", plants.pot_numbers_sum());
}

fn part2() {
    let mut plants = parse_plants();

    let mut prev_pattern = String::from("");
    for generation in 1..=NUM_GENERATIONS {
        plants.spread();
        plants.state.push('.');

        let pattern = plants.pattern();
        if pattern == prev_pattern {
            let to_add = (NUM_GENERATIONS - generation) * plants.num_alive() as u64;
            println!("{}", plants.pot_numbers_sum() + to_add as isize);
            break;
        }

        prev_pattern = pattern;
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if &args[1] == "1" {
        part1();
    } else {
        part2();
    }
}
