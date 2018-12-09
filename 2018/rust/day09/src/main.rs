use std::collections::HashMap;
use std::env;

fn parse_input() -> (usize, usize) {
    let contents = include_str!("input.txt");
    let parts = contents.split_whitespace().collect::<Vec<&str>>();
    (
        parts[0].parse::<usize>().unwrap(),
        parts[6].parse::<usize>().unwrap(),
    )
}

#[derive(Debug)]
struct Circle {
    buffer: Vec<usize>,
}

impl Circle {
    fn new() -> Circle {
        Circle { buffer: Vec::new() }
    }

    fn remove(&mut self, index: usize) -> usize {
        self.buffer.remove(index)
    }

    fn insert(&mut self, index: usize, element: usize) {
        self.buffer.insert(index, element);
    }

    fn buffer_index(&self, index: isize) -> isize {
        if index == 0 && self.buffer.is_empty() {
            return index;
        }

        let result = index % self.buffer.len() as isize;
        if result == 0 {
            return self.buffer.len() as isize;
        }

        result
    }
}

fn highest_score(players: usize, last_marble: usize) -> usize {
    let mut scores: HashMap<usize, usize> = HashMap::new();

    let mut circle = Circle::new();
    circle.insert(0, 0);

    let mut buffer_index: isize = 0;

    for (marble, player) in (1..=players).cycle().enumerate() {
        let current_marble = marble + 1;
        if current_marble == last_marble {
            break;
        }

        if current_marble % 23 == 0 {
            *scores.entry(player).or_insert(0) += current_marble;
            buffer_index = circle.buffer_index(circle.buffer.len() as isize - 7 + buffer_index);
            *scores.get_mut(&player).unwrap() += circle.remove(buffer_index as usize);
        } else {
            buffer_index = circle.buffer_index(buffer_index as isize + 2);
            circle.insert(buffer_index as usize, current_marble);
        }
    }

    *scores.values().max().unwrap()
}

fn part1() {
    let (players, last_marble) = parse_input();
    println!("{}", highest_score(players, last_marble));
}

fn part2() {
    let (players, last_marble) = parse_input();
    println!("{}", highest_score(players, last_marble * 100));
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if &args[1] == "1" {
        part1();
    } else {
        part2();
    }
}
