use std::path::{Path, PathBuf};
use rocket::fs::{TempFile, NamedFile, relative};
use rocket::data::{Data, ToByteUnit};
use rocket::tokio;

#[post("/upload/<file_name>", format = "plain", data = "<file>")]
pub async fn upload(file_name: &str,
                    mut file: TempFile<'_>) -> std::io::Result<()> {
    file.persist_to(Path::new(relative!("static")).join(file_name)).await
}

#[get("/download/<file_name..>")]
pub async fn download(file_name: PathBuf) -> Option<NamedFile> {
    NamedFile::open(Path::new("static/").join(file_name)).await.ok()
}

#[post("/debug", data = "<data>")]
pub async fn debug(data: Data<'_>) -> std::io::Result<()> {
    data.open(1.kibibytes())
        .stream_to(tokio::io::stdout())
        .await?;

    Ok(())
}
