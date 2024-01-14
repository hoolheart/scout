use std::vec::Vec;
use rocket::serde::{json::Json, Deserialize, Serialize};
use rocket::http::Status;

#[derive(Serialize, Deserialize)]
#[serde(crate = "rocket::serde")]
pub struct Task<'r> {
    id: &'r str,
    category: &'r str,
    description: &'r str,
    error: &'r str,
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
                error: "",
                started: true,
                completed: true,
            },
            Task {
                id: "555aaa",
                category: "calibrate",
                description: "calibrate system parameters",
                error: "no response",
                started: true,
                completed: false,
            },
            Task {
                id: "weseic",
                category: "assess",
                description: "assess target performances",
                error: "",
                started: false,
                completed: false,
            },
        ],
    })
}

#[post("/", data = "<task>")]
pub fn commit_task(task: Json<Task<'_>>) -> (Status, &'static str) {
    if task.id.len() == 0 {
        (Status::BadRequest, "Empty ID")
    } else {
        (Status::Accepted, "Success")
    }
}
