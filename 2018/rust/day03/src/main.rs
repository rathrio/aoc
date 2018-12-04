use std::env;
use std::collections::HashMap;

fn part1() {
    let contents = include_str!("input.txt");
    let mut claims: HashMap<(u16, u16), u16> = HashMap::new();

    for line in contents.lines() {
        let chunks: Vec<&str> = line.split_whitespace().collect();
        let coordinates: Vec<&str> = chunks[2].split(",").collect();
        let top_left_x = coordinates[0].parse::<u16>().unwrap();
        let top_left_y = coordinates[1].trim_end_matches(":").parse::<u16>().unwrap();

        let dimensions: Vec<&str> = chunks[3].split("x").collect();
        let width = dimensions[0].parse::<u16>().unwrap();
        let height = dimensions[1].parse::<u16>().unwrap();

        for x in top_left_x..(top_left_x + width) {
            for y in top_left_y..(top_left_y + height) {
                let claim = (x, y);
                let already_claimed = claims.contains_key(&claim);

                if already_claimed {
                    let count = claims.get(&claim).unwrap() + 1;
                    claims.insert(claim, count);
                } else {
                    claims.insert(claim, 1);
                }
            }
        }
    }

    println!("{}", claims.iter().filter(|(_, count)| **count > 1).count());
}


fn part2() {
    let contents = include_str!("input.txt");
    let mut claims: HashMap<(u16, u16), (u16, u16)> = HashMap::new();
    let mut id_overlaps: HashMap<u16, bool> = HashMap::new();

    for line in contents.lines() {
        let chunks: Vec<&str> = line.split_whitespace().collect();
        let id = chunks[0].trim_start_matches("#").parse::<u16>().unwrap();
        let coordinates: Vec<&str> = chunks[2].split(",").collect();
        let top_left_x = coordinates[0].parse::<u16>().unwrap();
        let top_left_y = coordinates[1].trim_end_matches(":").parse::<u16>().unwrap();

        let dimensions: Vec<&str> = chunks[3].split("x").collect();
        let width = dimensions[0].parse::<u16>().unwrap();
        let height = dimensions[1].parse::<u16>().unwrap();

        let mut overlaps = false;

        for x in top_left_x..(top_left_x + width) {
            for y in top_left_y..(top_left_y + height) {
                let claim = (x, y);
                let already_claimed = claims.contains_key(&claim);

                if already_claimed {
                    overlaps = true;
                    let previous_claim_id = claims.get(&claim).unwrap().1;
                    id_overlaps.insert(previous_claim_id, true);
                } else {
                    claims.insert(claim, (1, id));
                }
            }
        }

        id_overlaps.insert(id, overlaps);
    }

    let id = id_overlaps
        .iter()
        .find(|(_, overlaps)| !**overlaps)
        .unwrap().0;

    println!("{}", id);
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if &args[1] == "1" {
        part1();
    } else {
        part2();
    }
}