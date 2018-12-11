use std::env;

fn power(cell: (i32, i32)) -> i32 {
    let (x, y) = cell;
    let rack_id = x + 10;
    let mut level = rack_id * y;
    level += 1308;
    level *= rack_id;
    level = level / 100 % 10;
    level - 5
}

fn part1() {
    let mut current_max_power = -99_999;
    let mut current_max_cell: Option<(i32, i32)> = None;

    for x in 1..=298 {
        for y in 1..=298 {
            let square: [(i32, i32); 9] = [
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

fn part2() {}

fn main() {
    let args: Vec<String> = env::args().collect();

    if &args[1] == "1" {
        part1();
    } else {
        part2();
    }
}
