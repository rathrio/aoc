use std::env;

fn have_opposite_polarity(char1: &char, char2: &char) -> bool {
    char1 != char2 && char1.to_ascii_uppercase() == char2.to_ascii_uppercase()
}

fn react(units: &Vec<char>) -> Vec<char> {
    let mut compressed = Vec::with_capacity(units.len());

    for unit in units {
        if compressed.len() == 0 {
            compressed.push(*unit);
        } else {
            if have_opposite_polarity(unit, compressed.last().unwrap()) {
                compressed.pop();
            } else {
                compressed.push(*unit);
            }
        }
    }

    compressed
}

fn part1() {
    let contents = include_str!("input.txt");
    let units: Vec<char> = contents.chars().collect();
    let compressed = react(&units);
    println!("{}", compressed.len());
}

fn part2() {
    let contents = include_str!("input.txt");
    let units: Vec<char> = contents.chars().collect();

    let (_, length) = "abcdefghijkmnlopqrstuvwxzy".chars()
        .map(|c| {
            let filtered_units: Vec<char> = units.iter()
                .cloned()
                .filter(|unit| unit.to_ascii_lowercase() != c)
                .collect();

            (c, react(&filtered_units).len())
        })
        .min_by_key(|p| p.1)
        .unwrap();

    println!("{}", length);
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if &args[1] == "1" {
        part1();
    } else {
        part2();
    }
}
