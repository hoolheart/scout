use std::path::Path;
use rocket::fs::TempFile;
use rocket::data::{Data, ToByteUnit};
use rocket::tokio;

#[post("/upload/<file_name>", format = "plain", data = "<file>")]
pub async fn upload(file_name: &str,
                    mut file: TempFile<'_>) -> std::io::Result<()> {
    file.persist_to(Path::new("static").join(file_name)).await
}

#[post("/debug", data = "<data>")]
pub async fn debug(data: Data<'_>) -> std::io::Result<()> {
    data.open(512.kibibytes())
        .stream_to(tokio::io::stdout())
        .await?;

    Ok(())
}
