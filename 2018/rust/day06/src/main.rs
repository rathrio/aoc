use std::collections::HashMap;
use std::collections::HashSet;
use std::env;

fn distance(c1: &(i16, i16), c2: &(i16, i16)) -> u16 {
    ((c1.0 - c2.0).abs() + (c1.1 - c2.1).abs()) as u16
}

fn parse_coordinates() -> Vec<(i16, i16)> {
    let contents = include_str!("input.txt");

    contents
        .lines()
        .map(|line| {
            let parts = line.split(", ").collect::<Vec<&str>>();
            let x = parts[0].parse::<i16>().unwrap();
            let y = parts[1].parse::<i16>().unwrap();

            (x, y)
        })
        .collect::<Vec<(i16, i16)>>()
}

fn part1() {
    let coordinates = parse_coordinates();
    let mut clusters: HashMap<(i16, i16), Vec<(i16, i16)>> = HashMap::new();
    for coordinate in coordinates.iter() {
        clusters.insert(*coordinate, Vec::new());
    }

    let min_x = coordinates.iter().min_by_key(|(x, _)| x).unwrap().0;
    let max_x = coordinates.iter().max_by_key(|(x, _)| x).unwrap().0;
    let min_y = coordinates.iter().min_by_key(|(_, y)| y).unwrap().1;
    let max_y = coordinates.iter().max_by_key(|(_, y)| y).unwrap().1;

    let mut ignore: HashSet<(i16, i16)> = HashSet::new();

    for x in min_x..=max_x {
        for y in min_y..=max_y {
            let location = (x, y);

            let mut distances: Vec<(&(i16, i16), u16)> = coordinates
                .iter()
                .map(|c| (c, distance(&location, c)))
                .collect();

            distances.sort_by(|d1, d2| d1.1.cmp(&d2.1));

            if distances[0].1 == distances[1].1 {
                continue;
            }

            let (coordinate, _) = distances[0];
            if x == min_x || x == max_x || y == min_y || y == max_y {
                ignore.insert(*coordinate);
            } else {
                clusters.get_mut(coordinate).unwrap().push(location);
            }
        }
    }

    let largest_area = clusters
        .iter()
        .filter(|(coordinate, _)| !ignore.contains(coordinate))
        .max_by_key(|(_, locations)| locations.len())
        .unwrap()
        .1.len();

    println!("{}", largest_area);
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
