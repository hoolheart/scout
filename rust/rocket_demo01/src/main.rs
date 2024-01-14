#[macro_use] extern crate rocket;

use rocket_demo01::services::tests;

#[launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/", routes![tests::index, tests::salute])
        .mount("/api/v0", routes![tests::salute])
}
