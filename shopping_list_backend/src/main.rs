mod database_manager;
mod database_methods;
mod string_utils;

use axum::{
    http::StatusCode,
    routing::{get, post},
    Extension, Json, Router,
};
use database_methods::{add_item, get_all_items, get_all_items_seen, remove_item};
use serde::{Deserialize, Serialize};
use std::{
    collections::HashMap,
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
        .route("/get_items_seen", get(get_items_seen_handler))
        .route("/delete_item", post(delete_item_handler))
        .layer(Extension(app_state));

    let address = SocketAddr::from(([0, 0, 0, 0], 3000));
    let listener = tokio::net::TcpListener::bind(address).await.unwrap();
    tracing::debug!("listening on {}", address);
    axum::serve(listener, router).await.unwrap();

    Ok(())
}

async fn get_list_handler(
    state: Extension<Arc<AppState>>,
) -> (StatusCode, Json<Vec<ShoppingItem>>) {
    match get_all_items(&state.0.db_manager).await {
        Ok(items) => (StatusCode::OK, Json(items)),
        Err(_) => (StatusCode::CONFLICT, Json(vec![])),
    }
}

async fn get_items_seen_handler(
    state: Extension<Arc<AppState>>,
) -> (StatusCode, Json<HashMap<String, Vec<String>>>) {
    match get_all_items_seen(&state.0.db_manager).await {
        Ok(items) => (StatusCode::OK, Json(items)),
        Err(_) => (StatusCode::CONFLICT, Json(HashMap::new())),
    }
}

async fn add_item_handler(
    state: Extension<Arc<AppState>>,
    Json(payload): Json<ShoppingItem>,
) -> (StatusCode, Json<()>) {
    if add_item(&state.0.db_manager, &payload).await {
        (StatusCode::OK, Json(()))
    } else {
        (StatusCode::CONFLICT, Json(()))
    }
}

async fn delete_item_handler(
    state: Extension<Arc<AppState>>,
    Json(payload): Json<ShoppingItem>,
) -> (StatusCode, Json<()>) {
    if remove_item(&state.0.db_manager, &payload).await {
        (StatusCode::OK, Json(()))
    } else {
        (StatusCode::CONFLICT, Json(()))
    }
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ShoppingItem {
    name: String,
    quantity: u32,
    category: String,
}

#[derive(Clone)]
pub struct AppState {
    db_manager: Arc<Mutex<database_manager::DatabaseManager>>,
}
