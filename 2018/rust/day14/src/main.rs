use std::env;
use std::process;

fn digits(n: u8) -> Vec<u8> {
    let mut digits = Vec::new();
    let tens_digit = n / 10 % 10;
    if tens_digit != 0 {
        digits.push(tens_digit);
    }

    digits.push(n % 10);
    digits
}

fn part1() {
    let mut scoreboard: Vec<u8> = vec![3, 7];
    let mut elf_1 = 0;
    let mut elf_2 = 1;

    loop {
        if scoreboard.len() == 110_201 + 10 {
            break;
        }

        let elf_1_score = scoreboard[elf_1];
        let elf_2_score = scoreboard[elf_2];

        let sum = elf_1_score + elf_2_score;
        scoreboard.append(&mut digits(sum));

        elf_1 = (elf_1 + 1 + elf_1_score as usize) % scoreboard.len();
        elf_2 = (elf_2 + 1 + elf_2_score as usize) % scoreboard.len();
    }

    let result = &scoreboard[110_201..=110_210]
        .iter()
        .map(|n| n.to_string())
        .collect::<String>();
    println!("{}", result);
}

fn part2() {
    let mut scoreboard: Vec<u8> = vec![3, 7];
    let mut elf_1 = 0;
    let mut elf_2 = 1;

    loop {
        let elf_1_score = scoreboard[elf_1];
        let elf_2_score = scoreboard[elf_2];

        let sum = elf_1_score + elf_2_score;
        for digit in digits(sum).iter() {
            scoreboard.push(*digit);

            let len = scoreboard.len();
            if len >= 6
                && scoreboard[len - 6] == 1
                && scoreboard[len - 5] == 1
                && scoreboard[len - 4] == 0
                && scoreboard[len - 3] == 2
                && scoreboard[len - 2] == 0
                && scoreboard[len - 1] == 1
            {
                println!("{}", len - 6);
                process::exit(0);
            }
        }

        elf_1 = (elf_1 + 1 + elf_1_score as usize) % scoreboard.len();
        elf_2 = (elf_2 + 1 + elf_2_score as usize) % scoreboard.len();
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
