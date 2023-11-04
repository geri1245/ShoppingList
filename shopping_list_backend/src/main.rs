mod database_manager;
mod string_utils;

use axum::{
    http::StatusCode,
    routing::{get, post},
    Extension, Json, Router,
};
use serde::{Deserialize, Serialize};
use std::{
    net::SocketAddr,
    sync::{Arc, Mutex},
};

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt::init();

    let db_manager = Arc::new(Mutex::new(database_manager::DatabaseManager::new(
        "./my_db.sq3",
        "awesomeuser".into(),
    )?));

    let app_state = Arc::new(AppState { db_manager });

    let router = Router::new()
        .route("/add_item", post(add_item))
        .route("/get_items", get(get_list))
        .layer(Extension(app_state));

    let addr = SocketAddr::from(([127, 0, 0, 1], 3000));
    tracing::debug!("listening on {}", addr);
    axum::Server::bind(&addr)
        .serve(router.into_make_service())
        .await
        .unwrap();

    Ok(())
}

async fn get_list(state: Extension<Arc<AppState>>) -> Json<Vec<ShoppingItem>> {
    Json(state.0.db_manager.lock().unwrap().get_all().unwrap())
}

async fn add_item(
    state: Extension<Arc<AppState>>,
    Json(payload): Json<ShoppingItem>,
) -> (StatusCode, Json<()>) {
    state
        .0
        .db_manager
        .lock()
        .unwrap()
        .add_item(&payload)
        .unwrap();

    (StatusCode::OK, Json(()))
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ShoppingItem {
    name: String,
    quantity: u32,
}

#[derive(Clone)]
struct AppState {
    db_manager: Arc<Mutex<database_manager::DatabaseManager>>,
}

// the output to our `create_user` handler
#[derive(Serialize)]
struct User {
    id: u64,
    username: String,
}
