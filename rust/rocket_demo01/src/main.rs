#[macro_use] extern crate rocket;
use rocket::fs::{FileServer, relative};
use rocket_demo01::services::{tests, task, util};

#[launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/public/static", FileServer::from(relative!("static")))
        .mount("/public", routes![
            util::upload,
            util::debug,
        ])
        .mount("/test", routes![
            tests::index,
            tests::salute,
            tests::compare,
            tests::max,
            tests::count_tapped,
            tests::tap,
            tests::untap,
        ])
        .mount("/task", routes![
            task::get_all_tasks,
            task::commit_task,
        ])
}
