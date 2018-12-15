use std::env;

#[derive(Debug, Copy, Clone)]
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

#[derive(Debug, Copy, Clone)]
struct Cart {
    position: (usize, usize),
    direction: Direction,
    intersection_choice: u8,
}

impl Cart {
    fn new(position: (usize, usize), direction: Direction) -> Cart {
        Cart {
            position,
            direction,
            intersection_choice: 1,
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

    // let contents = include_str!("sample.txt");
    // let mut cells: Vec<Vec<char>> = vec![vec![' '; 13]; 6];

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

        for cart in carts.iter_mut() {
            let (x, y) = cart.position;
            let cell = grid[y][x];
            match cell {
                '/' => {
                    match cart.direction {
                        Direction::Up => cart.update_direction(Direction::Right),
                        Direction::Down => cart.update_direction(Direction::Left),
                        Direction::Left => cart.update_direction(Direction::Down),
                        Direction::Right => cart.update_direction(Direction::Up),
                    };
                }
                '\\' => {
                    match cart.direction {
                        Direction::Up => cart.update_direction(Direction::Left),
                        Direction::Down => cart.update_direction(Direction::Right),
                        Direction::Right => cart.update_direction(Direction::Down),
                        Direction::Left => cart.update_direction(Direction::Up),
                    };
                }
                '+' => {
                    cart.choose_direction();
                }
                _ => (),
            }

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
                break;
            }
        }
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
