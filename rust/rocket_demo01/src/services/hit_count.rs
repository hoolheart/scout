use rocket::fairing::AdHoc;
use rocket::response::{Flash, Redirect};
use rocket::State;
use std::sync::atomic::{AtomicUsize, Ordering};

struct HitCount {
    count: AtomicUsize,
}

#[get("/")]
fn get_hit_count(count: &State<HitCount>) -> String {
    format!("{}", count.count.load(Ordering::Relaxed))
}

#[post("/")]
fn hit_once(count: &State<HitCount>) -> Flash<Redirect> {
    count
        .count
        .store(count.count.load(Ordering::Relaxed) + 1, Ordering::Relaxed);
    Flash::success(Redirect::to("/hit_count"), "Succeed to hit")
}

#[post("/clear")]
fn clear_hits(count: &State<HitCount>) -> Flash<Redirect> {
    count.count.store(0, Ordering::Relaxed);
    Flash::success(Redirect::to("/hit_count"), "Succeed to clear hits")
}

pub fn stage() -> AdHoc {
    AdHoc::on_ignite("Hit count manage", |rocket| async {
        rocket
            .manage(HitCount {
                count: AtomicUsize::new(0),
            })
            .mount("/hit_count", routes![get_hit_count, hit_once, clear_hits])
    })
}
