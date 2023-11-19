mod database_manager;
mod database_methods;
mod string_utils;

use axum::{
    http::StatusCode,
    routing::{get, post},
    Extension, Json, Router,
};
use database_methods::add_item;
use serde::{Deserialize, Serialize};
use std::{
    net::SocketAddr,
    sync::{Arc, Mutex},
};

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt::init();

    let db_manager = Arc::new(Mutex::new(database_manager::DatabaseManager::new(
        "./my_db.sqlite3",
        "awesomeuser".into(),
    )?));

    let app_state = Arc::new(AppState { db_manager });

    let router = Router::new()
        .route("/add_item", post(add_item_handler))
        .route("/get_items", get(get_list_handler))
        .route("/delete_item", post(delete_item_handler))
        .layer(Extension(app_state));

    let addr = SocketAddr::from(([127, 0, 0, 1], 3000));
    tracing::debug!("listening on {}", addr);
    axum::Server::bind(&addr)
        .serve(router.into_make_service())
        .await
        .unwrap();

    Ok(())
}

async fn get_list_handler(state: Extension<Arc<AppState>>) -> Json<Vec<ShoppingItem>> {
    Json(state.0.db_manager.lock().unwrap().get_all().unwrap())
}

async fn add_item_handler(
    state: Extension<Arc<AppState>>,
    Json(payload): Json<ShoppingItem>,
) -> (StatusCode, Json<String>) {
    match add_item(&state.0.db_manager, &payload).await {
        Ok(added_successfully) => {
            if added_successfully {
                (StatusCode::OK, Json("".to_owned()))
            } else {
                (
                    StatusCode::NOT_ACCEPTABLE,
                    Json("Can't add item that is already in the database".to_owned()),
                )
            }
        }
        Err(error) => (StatusCode::NOT_MODIFIED, Json(error.to_string())),
    }
}

async fn delete_item_handler(
    state: Extension<Arc<AppState>>,
    Json(payload): Json<ShoppingItem>,
) -> (StatusCode, Json<()>) {
    state
        .0
        .db_manager
        .lock()
        .unwrap()
        .delete_item(&payload)
        .unwrap();

    (StatusCode::OK, Json(()))
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ShoppingItem {
    category: String,
    name: String,
    quantity: u32,
}

#[derive(Clone)]
pub struct AppState {
    db_manager: Arc<Mutex<database_manager::DatabaseManager>>,
}
