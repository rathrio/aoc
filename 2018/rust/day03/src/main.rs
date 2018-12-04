use std::collections::HashMap;

fn main() {
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