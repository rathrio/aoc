use std::env;

const SERIAL_NUMBER: i64 = 1308;

fn power(cell: (i64, i64)) -> i64 {
    let (x, y) = cell;
    let rack_id = x + 10;
    let mut level = rack_id * y;
    level += SERIAL_NUMBER;
    level *= rack_id;
    level = level / 100 % 10;
    level - 5
}

fn part1() {
    let mut current_max_power = -99_999;
    let mut current_max_cell: Option<(i64, i64)> = None;

    for x in 1..=298 {
        for y in 1..=298 {
            let square: [(i64, i64); 9] = [
                (x, y),
                (x + 1, y),
                (x + 2, y),
                (x, y + 1),
                (x + 1, y + 1),
                (x + 2, y + 1),
                (x, y + 2),
                (x + 1, y + 2),
                (x + 2, y + 2),
            ];

            let total_power = square.iter().map(|cell| power(*cell)).sum();

            if total_power > current_max_power {
                current_max_power = total_power;
                current_max_cell = Some((x, y));
            }
        }
    }

    let (x, y) = current_max_cell.unwrap();
    println!("{},{}", x, y);
}

fn part2() {
    let mut grid: Vec<Vec<i64>> = vec![vec![0; 300]; 300];

    for y in 0..grid.len() {
        for x in 0..grid.len() {
            grid[y][x] = power((x as i64, y as i64));
        }
    }

    let mut current_max_power = -99_999;
    let mut current_max_cell: Option<(i64, i64)> = None;
    let mut s = 15;
    loop {
        if s == 19 {
            break;
        }

        for x in 0..grid.len() - s {
            for y in 0..grid.len() - s {
                let mut total_power = 0;

                for xx in x..x + s {
                    for yy in y..y + s {
                        total_power += grid[yy][xx];
                    }
                }

                if total_power > current_max_power {
                    current_max_power = total_power;
                    current_max_cell = Some((x as i64, y as i64));
                }
            }
        }

        s += 1;
    }

    let (x, y) = current_max_cell.unwrap();
    println!("{},{},{}", x, y, s);
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if &args[1] == "1" {
        part1();
    } else {
        part2();
    }
}
