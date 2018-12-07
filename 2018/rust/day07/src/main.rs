use std::collections::HashMap;
use std::env;

#[derive(Debug)]
struct Instruction {
    prerequisite: char,
    step: char,
}

fn parse_instructions() -> Vec<Instruction> {
    let contents = include_str!("input.txt");

    contents
        .lines()
        .map(|line| {
            let parts: Vec<&str> = line.split_whitespace().collect();
            let prerequisite = parts[1].chars().next().unwrap();
            let step = parts[7].chars().next().unwrap();
            Instruction { prerequisite, step }
        })
        .collect()
}

fn part1() {
    let instructions = parse_instructions();
    let mut prerequisites: HashMap<char, Vec<char>> = HashMap::new();

    "ABCDEFGHIJKLMNOPQRSTUVWXYZ".chars().for_each(|c| {
        prerequisites.insert(c, Vec::new());
    });

    instructions.iter().for_each(|i| {
        let step = i.step;
        prerequisites.get_mut(&step).unwrap().push(i.prerequisite);
    });

    let mut steps: Vec<char> = instructions.iter().map(|i| i.step).collect();
    steps.sort();
    steps.dedup();

    let mut available_steps: Vec<char> = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        .chars()
        .filter(|c| !steps.contains(c))
        .collect();

    let mut path: Vec<char> = Vec::new();

    loop {
        if available_steps.is_empty() {
            break;
        }

        available_steps.sort();
        let next_step = available_steps.remove(0);
        path.push(next_step);

        let candidates: Vec<char> = instructions
            .iter()
            .filter(|i| i.prerequisite == next_step)
            .map(|i| i.step)
            .collect();

        let mut next_available_steps: Vec<char> = candidates
            .iter()
            .cloned()
            .filter(|c| {
                prerequisites[c]
                    .iter()
                    .all(|p| path.contains(p))
            })
            .filter(|c| !(path.contains(c) || available_steps.contains(c)))
            .collect();

        available_steps.append(&mut next_available_steps);
    }

    let result = path.iter().map(|c| c.to_string()).collect::<String>();
    println!("{}", result);
}

fn part2() {}

fn main() {
    let args: Vec<String> = env::args().collect();

    if &args[1] == "1" {
        part1();
    } else {
        part2();
    }
}
