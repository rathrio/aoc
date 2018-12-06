use std::env;

fn have_opposite_polarity(char1: &char, char2: &char) -> bool {
    match char1 {
        'a'...'z' => char1.to_string().to_uppercase() == char2.to_string(),
        'A'...'Z' => char1.to_string().to_lowercase() == char2.to_string(),
        _ => false,
    }
}

fn react(units: &Vec<char>) -> Vec<char> {
    let mut compressed: Vec<char> = Vec::new();

    let mut index = 0;
    while index < units.len() {
        let unit = units[index];
        if index == units.len() - 1 {
            compressed.push(unit);
            break;
        }
        let next_unit = units[index + 1];

        if have_opposite_polarity(&unit, &next_unit) {
            index += 2;
        } else {
            compressed.push(unit);
            index += 1;
        }
    }

    compressed
}

fn part1() {
    let contents = include_str!("input.txt");
    let mut units: Vec<char> = contents.chars().collect();

    loop {
        let compressed = react(&units);

        if compressed.len() == units.len() {
            println!("{}", compressed.len());
            break;
        }

        units = compressed;
    }
}

fn part2() {

}

fn main() {
    let args: Vec<String> = env::args().collect();

    if &args[1] == "1" {
        part1();
    } else {
        part2();
    }
}
