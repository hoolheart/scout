use rocket::fairing::AdHoc;
use rocket::form::Form;
use rocket::http::Status;
use rocket::serde::{json::Json, Deserialize, Serialize};
use std::vec::Vec;

#[derive(Serialize, Deserialize, FromForm)]
#[serde(crate = "rocket::serde")]
struct Task<'r> {
    id: &'r str,
    category: &'r str,
    description: &'r str,
    error: Option<&'r str>,
    started: bool,
    completed: bool,
}

#[derive(Serialize)]
#[serde(crate = "rocket::serde")]
struct Tasks<'r> {
    tasks: Vec<Task<'r>>,
}

#[get("/")]
fn get_all_tasks() -> Json<Tasks<'static>> {
    Json(Tasks {
        tasks: vec![
            Task {
                id: "012345",
                category: "measure",
                description: "measure all weights",
                error: Some(""),
                started: true,
                completed: true,
            },
            Task {
                id: "555aaa",
                category: "calibrate",
                description: "calibrate system parameters",
                error: Some("no response"),
                started: true,
                completed: false,
            },
            Task {
                id: "weseic",
                category: "assess",
                description: "assess target performances",
                error: Some(""),
                started: false,
                completed: false,
            },
        ],
    })
}

#[post("/", format = "application/json", data = "<task>", rank = 0)]
fn commit_task_by_json(task: Json<Task<'_>>) -> (Status, &'static str) {
    comit_task(task.into_inner())
}

#[post("/", data = "<task>", rank = 1)]
fn commit_task_by_form(task: Form<Task<'_>>) -> (Status, &'static str) {
    comit_task(task.into_inner())
}

fn comit_task(task: Task) -> (Status, &'static str) {
    match task.id.len() {
        0 => (Status::BadRequest, "Empty ID"),
        _ => (Status::Accepted, "Success"),
    }
}

pub fn stage() -> AdHoc {
    AdHoc::on_ignite("Task interface", |rocket| async {
        rocket.mount(
            "/task",
            routes![get_all_tasks, commit_task_by_json, commit_task_by_form,],
        )
    })
}
