use std::env;

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
}

impl Cart {
    fn next_position(&self) -> (usize, usize) {
        let (x, y) = self.position;

        match self.direction {
            Direction::Up => (x, y - 1),
            Direction::Down => (x, y + 1),
            Direction::Left => (x - 1, y),
            Direction::Right => (x + 1, y),
        }
    }

    fn update_position(&mut self, position: (usize, usize)) {
        self.position = position;
    }

    fn update_direction(&mut self, direction: Direction) {
        self.direction = direction;
    }

    fn choose_direction(&mut self) {
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
                    carts.push(Cart {
                        position: (x, y),
                        direction: Direction::Right,
                    });
                    '-'
                }
                '<' => {
                    carts.push(Cart {
                        position: (x, y),
                        direction: Direction::Left,
                    });
                    '-'
                }
                '^' => {
                    carts.push(Cart {
                        position: (x, y),
                        direction: Direction::Up,
                    });
                    '|'
                }
                'v' => {
                    carts.push(Cart {
                        position: (x, y),
                        direction: Direction::Down,
                    });
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
        for cart in carts.iter_mut() {
            let next_position = cart.next_position();
            cart.update_position(next_position);

            let (next_x, next_y) = next_position;
            let next_cell = grid[next_y][next_x];
            match next_cell {
                '/' => {
                    match cart.direction {
                        Direction::Up => cart.update_direction(Direction::Right),
                        Direction::Left => cart.update_direction(Direction::Down),
                        _ => (),
                    };
                }
                '\\' => {
                    match cart.direction {
                        Direction::Up => cart.update_direction(Direction::Left),
                        Direction::Right => cart.update_direction(Direction::Down),
                        _ => (),
                    };
                }
                '+' => {
                    cart.choose_direction();
                }
                _ => (),
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
