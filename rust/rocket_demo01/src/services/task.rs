use std::vec::Vec;
use rocket::serde::{json::Json, Deserialize, Serialize};
use rocket::form::Form;
use rocket::http::Status;

#[derive(Serialize, Deserialize, FromForm)]
#[serde(crate = "rocket::serde")]
pub struct Task<'r> {
    id: &'r str,
    category: &'r str,
    description: &'r str,
    error: Option<&'r str>,
    started: bool,
    completed: bool,
}

#[derive(Serialize)]
#[serde(crate = "rocket::serde")]
pub struct Tasks<'r> {
    tasks: Vec<Task<'r>>,
}

#[get("/")]
pub fn get_all_tasks() -> Json<Tasks<'static>> {
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
pub fn commit_task_by_json(task: Json<Task<'_>>) -> (Status, &'static str) {
    comit_task(task.into_inner())
}

#[post("/", data = "<task>", rank = 1)]
pub fn commit_task_by_form(task: Form<Task<'_>>) -> (Status, &'static str) {
    comit_task(task.into_inner())
}

fn comit_task(task: Task) -> (Status, &'static str) {
    match task.id.len() {
        0 => (Status::BadRequest, "Empty ID"),
        _ => (Status::Accepted, "Success"),
    }
}
