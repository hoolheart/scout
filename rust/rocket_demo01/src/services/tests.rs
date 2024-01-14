use std::cmp::Ordering;
use rocket::http::uri::{Segments, fmt::Path};

#[get("/")]
pub fn index() -> &'static str {
    "Hello, Rocket!"
}

#[get("/salute/<name>")]
pub fn salute(name: &str) -> String {
    format!("Hello, {}!", name)
}

#[get("/compare/<num1>/<num2>")]
pub fn compare(num1: i32, num2: i32) -> &'static str {
    match num1.cmp(&num2) {
        Ordering::Less => "less",
        Ordering::Greater => "greater",
        Ordering::Equal => "equal",
    }
}

#[get("/max/<segments..>")]
pub fn max(segments: Segments<Path>) -> String {
    if segments.len() == 0 {
        String::from("empty")
    } else {
        let mut rst: i32 = 0;
        let mut found: bool = false;
        for segment in segments {
            let num: i32 = match segment.parse() {
                Ok(val) => val,
                Err(_) => {
                    return format!("Invalid segment {}!", segment);
                }
            };
            if (!found) || (num > rst) {
                rst = num;
            }
            found = true;
        }
        format!("Found max: {}!", rst)
    }
}
