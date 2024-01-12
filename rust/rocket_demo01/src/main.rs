#[macro_use] extern crate rocket;

#[get("/")]
fn index() -> &'static str {
    "Hello, Rocket!"
}

#[get("/salute/<name>")]
fn salute(name: &str) -> String {
    format!("Hello, {}!", name)
}

#[launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/", routes![index, salute])
        .mount("/api/v0", routes![salute])
}
