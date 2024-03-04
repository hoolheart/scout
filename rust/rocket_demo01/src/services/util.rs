use rocket::data::{Data, ToByteUnit};
use rocket::fairing::AdHoc;
use rocket::fs::{relative, FileServer, NamedFile, TempFile};
use rocket::tokio;
use std::path::{Path, PathBuf};

#[post("/upload/<file_name>", format = "plain", data = "<file>")]
async fn upload(file_name: &str, mut file: TempFile<'_>) -> std::io::Result<()> {
    file.persist_to(Path::new(relative!("static")).join(file_name))
        .await
}

#[get("/download/<file_name..>")]
async fn download(file_name: PathBuf) -> Option<NamedFile> {
    NamedFile::open(Path::new("static/").join(file_name))
        .await
        .ok()
}

#[post("/debug", data = "<data>")]
async fn debug(data: Data<'_>) -> std::io::Result<()> {
    data.open(1.kibibytes())
        .stream_to(tokio::io::stdout())
        .await?;

    Ok(())
}

pub fn stage() -> AdHoc {
    AdHoc::on_ignite("Public utilities", |rocket| async {
        rocket
            .mount("/public/static", FileServer::from(relative!("static")))
            .mount("/public", routes![upload, download, debug,])
    })
}
