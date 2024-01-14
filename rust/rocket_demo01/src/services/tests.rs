#[get("/")]
pub fn index() -> &'static str {
    "Hello, Rocket!"
}

#[get("/salute/<name>")]
pub fn salute(name: &str) -> String {
    format!("Hello, {}!", name)
}
