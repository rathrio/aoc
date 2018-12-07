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

fn build_prerequisites(instructions: &Vec<Instruction>) -> HashMap<char, Vec<char>> {
    let mut prerequisites: HashMap<char, Vec<char>> = HashMap::new();

    "ABCDEFGHIJKLMNOPQRSTUVWXYZ".chars().for_each(|c| {
        prerequisites.insert(c, Vec::new());
    });

    instructions.iter().for_each(|i| {
        let step = i.step;
        prerequisites.get_mut(&step).unwrap().push(i.prerequisite);
    });

    prerequisites
}

fn initial_steps(instructions: &Vec<Instruction>) -> Vec<char> {
    let mut steps: Vec<char> = instructions.iter().map(|i| i.step).collect();
    steps.sort();
    steps.dedup();

    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        .chars()
        .filter(|c| !steps.contains(c))
        .collect()
}

fn part1() {
    let instructions = parse_instructions();
    let prerequisites = build_prerequisites(&instructions);
    let mut available_steps = initial_steps(&instructions);

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
            .filter(|c| prerequisites[c].iter().all(|p| path.contains(p)))
            .filter(|c| !(path.contains(c) || available_steps.contains(c)))
            .collect();

        available_steps.append(&mut next_available_steps);
    }

    let result = path.iter().map(|c| c.to_string()).collect::<String>();
    println!("{}", result);
}

#[derive(Debug)]
struct Worker {
    workload: u8,
    step: Option<char>,
}

impl Worker {
    fn is_free(&self) -> bool {
        self.workload == 0
    }

    fn work(&mut self) {
        match self.workload {
            0 => (),
            _ => self.workload -= 1,
        }
    }

    fn idle(&mut self) {
        self.step = None;
    }

    fn assign(&mut self, step: char, workload: u8) {
        self.step = Some(step);
        self.workload = workload;
    }
}

fn part2() {
    let mut workloads: HashMap<char, u8> = HashMap::new();

    "ABCDEFGHIJKLMNOPQRSTUVWXYZ".chars().for_each(|c| {
        workloads.insert(c, c as u8 - b'A' + 61);
    });

    let instructions = parse_instructions();
    let prerequisites = build_prerequisites(&instructions);
    let mut available_steps = initial_steps(&instructions);

    let mut workers: Vec<Worker> = vec![
        Worker {
            workload: 0,
            step: None,
        },
        Worker {
            workload: 0,
            step: None,
        },
        Worker {
            workload: 0,
            step: None,
        },
        Worker {
            workload: 0,
            step: None,
        },
        Worker {
            workload: 0,
            step: None,
        },
    ];

    let mut seconds = -1;
    let mut path: Vec<char> = Vec::new();
    let mut in_progress: Vec<char> = Vec::new();

    loop {
        if available_steps.is_empty() && workers.iter().all(|w| w.is_free()) {
            break;
        }

        available_steps.sort();

        for i in 0..5 {
            let worker = &mut workers[i];
            worker.work();

            if !worker.is_free() {
                continue;
            }

            match worker.step {
                None => (),
                Some(step) => {
                    path.push(step);

                    let candidates: Vec<char> = instructions
                        .iter()
                        .filter(|i| i.prerequisite == step)
                        .map(|i| i.step)
                        .collect();

                    let mut next_available_steps: Vec<char> = candidates
                        .iter()
                        .cloned()
                        .filter(|c| prerequisites[c].iter().all(|p| path.contains(p)))
                        .filter(|c| {
                            !(path.contains(c)
                                || available_steps.contains(c)
                                || in_progress.contains(c))
                        })
                        .collect();

                    available_steps.append(&mut next_available_steps);
                }
            }

            if available_steps.is_empty() {
                worker.idle();
            } else {
                let next_step = available_steps.remove(0);
                in_progress.push(next_step);
                worker.assign(next_step, workloads[&next_step]);
            }
        }

        seconds += 1;
    }

    println!("{}", seconds);
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if &args[1] == "1" {
        part1();
    } else {
        part2();
    }
}
