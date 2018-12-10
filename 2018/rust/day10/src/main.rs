extern crate regex;

use regex::Regex;
use std::env;

#[derive(Debug)]
struct Position {
    x: i32,
    y: i32,
    vx: i32,
    vy: i32,
}

impl Position {
    fn mv(&mut self) {
        self.x += self.vx;
        self.y += self.vy;
    }
}

fn bounding_box(positions: &[Position]) -> (i32, i32, i32, i32) {
    let min_x = positions.iter().min_by_key(|p| p.x).unwrap().x;
    let max_x = positions.iter().max_by_key(|p| p.x).unwrap().x;
    let min_y = positions.iter().min_by_key(|p| p.y).unwrap().y;
    let max_y = positions.iter().max_by_key(|p| p.y).unwrap().y;

    (min_x, max_x, min_y, max_y)
}

fn parse_positions() -> Vec<Position> {
    let re = Regex::new(
        r"position=<\s*(?P<x>-?\d+),\s*(?P<y>-?\d+)>\svelocity=<\s*(?P<vx>-?\d+),\s*(?P<vy>-?\d+)>",
    )
    .unwrap();

    let contents = include_str!("input.txt");
    contents
        .lines()
        .map(|line| {
            let caps = re.captures(line).unwrap();

            Position {
                x: caps["x"].parse().unwrap(),
                y: caps["y"].parse().unwrap(),
                vx: caps["vx"].parse().unwrap(),
                vy: caps["vy"].parse().unwrap(),
            }
        })
        .collect()
}

fn part1() {
    let mut positions = parse_positions();
    let mut current_width = 200_000;

    loop {
        let (min_x, max_x, min_y, max_y) = bounding_box(&positions);

        let new_width = max_x - min_x;
        if new_width < current_width {
            current_width = new_width;
        } else {
            // If the points start spreading again we're done.
            break;
        }

        // Defer rendering until bounding box is small enough.
        if current_width < 80 {
            let mut s = String::new();
            for y in min_y..=max_y {
                for x in min_x..=max_x {
                    // Prebuilding a grid would be more efficient, but since the
                    // bounding box is so small at this point, I don't care.
                    if positions.iter().any(|p| p.x == x && p.y == y) {
                        s.push_str("#");
                    } else {
                        s.push_str(".");
                    }
                }
                s.push_str("\n");
            }

            println!("{}[2J", 27 as char);
            println!("{}", s);
        }

        for p in positions.iter_mut() {
            p.mv();
        }
    }
}

fn part2() {
    let mut positions = parse_positions();
    let mut current_width = 200_000;
    let mut second = 0;

    loop {
        let (min_x, max_x, _, _) = bounding_box(&positions);

        let new_width = max_x - min_x;
        if new_width < current_width {
            current_width = new_width;
        } else {
            // If the points start spreading again we're done.
            println!("{}", second - 1);
            break;
        }

        for p in positions.iter_mut() {
            p.mv();
        }
        second += 1;
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
