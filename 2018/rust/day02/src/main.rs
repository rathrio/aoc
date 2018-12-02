use std::env;
use std::process;
use std::collections::HashMap;

fn part1() {
    let contents = include_str!("input.txt");

    let mut counts = HashMap::new();
    counts.insert(2, 0);
    counts.insert(3, 0);

    for line in contents.lines() {
        let mut contains_2 = false;
        let mut contains_3 = false;

        for char in line.chars() {
            let char_count = line.chars().filter(|c| *c == char).count();

            match char_count {
                2 => contains_2 = true,
                3 => contains_3 = true,
                _ => (),
            }
        }

        if contains_2 {
            let new_count = counts.get(&2).unwrap() + 1;
            counts.insert(2, new_count);
        }

        if contains_3 {
            let new_count = counts.get(&3).unwrap() + 1;
            counts.insert(3, new_count);
        }
    }


    let checksum = counts.get(&2).unwrap() * counts.get(&3).unwrap();
    println!("{}", checksum);
}

fn part2() {
    let contents = include_str!("input.txt");

    for (index, line) in contents.lines().enumerate() {
        for other_line in contents.lines().skip(index + 1) {
            let pairs = line.chars().zip(other_line.chars());
            let mut edit_cost = 0;

            for pair in pairs {
                let (c1, c2) = pair;
                if c1 != c2 {
                    edit_cost += 1;
                }

                if edit_cost > 1 {
                    break;
                }
            }

            if edit_cost == 1 {
                line
                    .chars()
                    .zip(other_line.chars())
                    .filter(|(c1, c2)| c1 == c2)
                    .map(|(c1, _)| c1)
                    .for_each(|char| print!("{}", char));

                println!();
                process::exit(0);
            }
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
