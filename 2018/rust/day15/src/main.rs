use std::env;

#[derive(Debug)]
enum Unit {
    Elf { hp: u8, x: u8, y: u8 },
    Goblin { hp: u8, x: u8, y: u8 },
}

fn parse_grid() -> Vec<Vec<char>> {
    let contents = include_str!("input.txt");
    let mut grid = vec![vec![' '; 32]; 32];
    let mut units: Vec<Unit> = Vec::new();

    for (y, line) in contents.lines().enumerate() {
        for (x, c) in line.chars().enumerate() {
            match c {
                'G' => {
                    units.push(Unit::Goblin {
                        hp: 200,
                        x: x as u8,
                        y: y as u8,
                    });
                    grid[y][x] = '.';
                }
                'E' => {
                    units.push(Unit::Elf {
                        hp: 200,
                        x: x as u8,
                        y: y as u8,
                    });
                    grid[y][x] = '.';
                }
                _ => {
                    grid[y][x] = c;
                }
            };
        }
    }

    grid
}

fn part1() {
    let grid = parse_grid();
    for line in grid {
        println!("{}", line.iter().collect::<String>());
    }
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
