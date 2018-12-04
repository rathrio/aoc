extern crate chrono;
use chrono::prelude::*;

use std::env;
use std::collections::HashMap;

#[derive(Debug)]
struct Record {
    date: DateTime<Utc>,
    message: String
}

fn parse_records() -> Vec<Record> {
    let contents = include_str!("input.txt");
    let mut records: Vec<Record> = contents.lines()
        .map(|line| {
            let chunks: Vec<&str> = line.split("]").collect();
            let date_string = chunks[0].trim_start_matches("[");
            let date = Utc.datetime_from_str(date_string, "%Y-%m-%d %H:%M").unwrap();
            let message = chunks[1].trim();

            Record { date, message: message.to_string() }
        })
        .collect();

    records.sort_by(|r1, r2| r1.date.cmp(&r2.date));
    records
}

fn guard_sleep_schedule() -> HashMap<u32, Vec<u32>> {
    let records = parse_records();

    let mut schedule: HashMap<u32, Vec<u32>> = HashMap::new();
    let mut current_guard_id: Option<u32> = None;
    let mut fall_minute: Option<u32> = None;

    for record in records {
        let message_parts: Vec<&str> = record.message.split_whitespace().collect();

        match message_parts[0] {
            "Guard" => {
                let id = message_parts[1].trim_start_matches("#").parse::<u32>().unwrap();
                current_guard_id = Some(id);

                if !schedule.contains_key(&id) {
                    schedule.insert(id, Vec::new());
                }
            },
            "falls" => {
                fall_minute = Some(record.date.minute());
            },
            "wakes" => {
                let wake_minute = record.date.minute();
                for sleep_minute in fall_minute.unwrap()..wake_minute {
                    schedule.get_mut(&current_guard_id.unwrap())
                        .unwrap()
                        .push(sleep_minute);
                }
            },
            _ => (),
        };
    }

    schedule
}

fn part1() {
    let schedule = guard_sleep_schedule();

    let (guard_id, sleep_minutes) = schedule.iter()
        .max_by_key(|(_, sleep_minutes)| sleep_minutes.len())
        .unwrap();

    let minute = sleep_minutes.iter()
        .max_by_key(|minute| sleep_minutes.iter().filter(|m| m == minute).count())
        .unwrap();

    println!("{}", guard_id * minute);
}

fn part2() {
    let schedule = guard_sleep_schedule();

    let sleep_frequencies: Vec<(u32, &u32, usize)> = (0..60).map(|minute| {
        let (guard_id, sleep_minutes) = schedule.iter()
            .max_by_key(|(_, minutes)| minutes.iter().filter(|m| **m == minute).count())
            .unwrap();

        let count = sleep_minutes.iter()
            .filter(|m| **m == minute)
            .count();

        (minute, guard_id, count)
    }).collect();

    let (minute, guard_id, _) = sleep_frequencies.iter()
        .max_by_key(|f| f.2)
        .unwrap();

    println!("{}", *guard_id * minute);
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if &args[1] == "1" {
        part1();
    } else {
        part2();
    }
}
