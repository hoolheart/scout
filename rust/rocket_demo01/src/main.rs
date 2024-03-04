#[macro_use]
extern crate rocket;
use rocket_demo01::services::{task, tests, util};

#[launch]
fn rocket() -> _ {
    rocket::build()
        .attach(util::stage())
        .attach(task::stage())
        .attach(tests::stage())
}
