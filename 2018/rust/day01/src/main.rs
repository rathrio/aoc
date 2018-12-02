use std::env;
use std::process;
use std::collections::HashMap;

fn part1() {
    let mut current_frequency = 0;
    let contents = include_str!("input.txt");

    for line in contents.lines() {
        let change = line.parse::<i32>().unwrap();
        current_frequency += change;
    }

    println!("{}", current_frequency);
}

fn part2() {
    let mut current_frequency = 0;
    let mut reached = HashMap::new();
    reached.insert(0, true);

    let contents = include_str!("input.txt");

    loop {
        for line in contents.lines() {
            let change = line.parse::<i32>().unwrap();
            current_frequency += change;

            if reached.contains_key(&current_frequency) {
                println!("{}", current_frequency);
                process::exit(0);
            }

            reached.insert(current_frequency, true);
        }
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