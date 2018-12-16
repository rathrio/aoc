use std::env;
use std::process;

#[derive(Debug)]
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

#[derive(Debug)]
struct Cart {
    position: (usize, usize),
    direction: Direction,
    intersection_choice: u8,
    crashed: bool,
}

impl Cart {
    fn new(position: (usize, usize), direction: Direction) -> Cart {
        Cart {
            position,
            direction,
            intersection_choice: 1,
            crashed: false,
        }
    }

    fn mv(&mut self) -> (usize, usize) {
        let (x, y) = self.position;

        match self.direction {
            Direction::Up => self.position = (x, y - 1),
            Direction::Down => self.position = (x, y + 1),
            Direction::Left => self.position = (x - 1, y),
            Direction::Right => self.position = (x + 1, y),
        };

        self.position
    }

    fn turn(&mut self, cell: char) {
        match cell {
            '/' => {
                match self.direction {
                    Direction::Up => self.update_direction(Direction::Right),
                    Direction::Down => self.update_direction(Direction::Left),
                    Direction::Left => self.update_direction(Direction::Down),
                    Direction::Right => self.update_direction(Direction::Up),
                };
            }
            '\\' => {
                match self.direction {
                    Direction::Up => self.update_direction(Direction::Left),
                    Direction::Down => self.update_direction(Direction::Right),
                    Direction::Right => self.update_direction(Direction::Down),
                    Direction::Left => self.update_direction(Direction::Up),
                };
            }
            '+' => {
                self.choose_direction();
            }
            _ => (),
        }
    }

    fn update_direction(&mut self, direction: Direction) {
        self.direction = direction;
    }

    fn turn_left(&mut self) {
        match self.direction {
            Direction::Up => self.direction = Direction::Left,
            Direction::Down => self.direction = Direction::Right,
            Direction::Left => self.direction = Direction::Down,
            Direction::Right => self.direction = Direction::Up,
        }
    }

    fn turn_right(&mut self) {
        match self.direction {
            Direction::Up => self.direction = Direction::Right,
            Direction::Down => self.direction = Direction::Left,
            Direction::Left => self.direction = Direction::Up,
            Direction::Right => self.direction = Direction::Down,
        }
    }

    fn choose_direction(&mut self) {
        match self.intersection_choice {
            1 => {
                self.turn_left();
                self.intersection_choice = 2;
            }
            2 => {
                self.intersection_choice = 3;
            }
            3 => {
                self.turn_right();
                self.intersection_choice = 1;
            }
            _ => (),
        }
    }
}

fn parse_grid() -> (Vec<Vec<char>>, Vec<Cart>) {
    let contents = include_str!("input.txt");
    let mut cells: Vec<Vec<char>> = vec![vec![' '; 150]; 150];
    let mut carts: Vec<Cart> = Vec::new();

    for (y, line) in contents.lines().enumerate() {
        for (x, c) in line.chars().enumerate() {
            cells[y][x] = match c {
                '>' => {
                    carts.push(Cart::new((x, y), Direction::Right));
                    '-'
                }
                '<' => {
                    carts.push(Cart::new((x, y), Direction::Left));
                    '-'
                }
                '^' => {
                    carts.push(Cart::new((x, y), Direction::Up));
                    '|'
                }
                'v' => {
                    carts.push(Cart::new((x, y), Direction::Down));
                    '|'
                }
                _ => c,
            };
        }
    }

    (cells, carts)
}

fn part1() {
    let (grid, mut carts) = parse_grid();

    loop {
        carts.sort_by(|c1, c2| {
            let (c1_x, c1_y) = c1.position;
            let (c2_x, c2_y) = c2.position;

            (c1_y, c1_x).cmp(&(c2_y, c2_x))
        });

        for i in 0..carts.len() {
            let cart = carts.get_mut(i).unwrap();
            let (x, y) = cart.position;
            let cell = grid[y][x];
            cart.turn(cell);
            let new_position = cart.mv();
            let cart_positions: Vec<(usize, usize)> = carts.iter().map(|c| c.position).collect();
            if cart_positions
                .iter()
                .filter(|p| **p == new_position)
                .count()
                > 1
            {
                let (x, y) = new_position;
                println!("{},{}", x, y);
                process::exit(0);
            }
        }
    }
}

fn part2() {
    let (grid, mut carts) = parse_grid();

    loop {
        carts.sort_by(|c1, c2| {
            let (c1_x, c1_y) = c1.position;
            let (c2_x, c2_y) = c2.position;

            (c1_y, c1_x).cmp(&(c2_y, c2_x))
        });

        for i in 0..carts.len() {
            let cart = carts.get_mut(i).unwrap();
            if cart.crashed {
                continue;
            }

            let (x, y) = cart.position;
            let cell = grid[y][x];
            cart.turn(cell);
            let new_position = cart.mv();

            let crashed = carts.iter().filter(|c| !c.crashed && c.position == new_position).count();
            if crashed > 1 {
                carts
                    .iter_mut()
                    .filter(|c| !c.crashed && c.position == new_position)
                    .for_each(|c| c.crashed = true);
            }
        }

        if carts.iter().filter(|c| !c.crashed).count() == 1 {
            let cart = carts.iter().find(|c| !c.crashed).unwrap();
            let (x, y) = cart.position;
            println!("{},{}", x, y);
            process::exit(0);
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
