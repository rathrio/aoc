use std::env;
use std::fs;
use std::process;
use std::collections::HashMap;

fn part1() {
    let mut current_frequency = 0;

    let contents = fs::read_to_string("input.txt")
        .expect("Something went wrong reading the input");

    for line in contents.lines() {
        let op = line.chars().next().unwrap();
        let change_str = line.get(1..).unwrap();
        let change = change_str.parse::<i32>().unwrap();

        if op == '+' {
            current_frequency += change;
        } else {
            current_frequency -= change;
        }
    }

    println!("{}", current_frequency);
}

fn part2() {
    let mut current_frequency = 0;
    let mut reached = HashMap::new();
    reached.insert(0, true);

    let contents = fs::read_to_string("input.txt")
        .expect("Something went wrong reading the input");

    loop {
        for line in contents.lines() {
            let op = line.chars().next().unwrap();
            let change_str = line.get(1..).unwrap();
            let change = change_str.parse::<i32>().unwrap();

            if op == '+' {
                current_frequency += change;
            } else {
                current_frequency -= change;
            }

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