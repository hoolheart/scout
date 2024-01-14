#[macro_use] extern crate rocket;
use rocket::fs::{FileServer, relative};
use rocket_demo01::services::{tests, task};

#[launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/public", FileServer::from(relative!("static")))
        .mount("/test", routes![
            tests::index,
            tests::salute,
            tests::compare,
            tests::max,
        ])
        .mount("/task", routes![
            task::get_all_tasks,
            task::commit_task,
        ])
}
