mod database_manager;
mod database_methods;
mod item_definitions;
mod string_utils;

use axum::{
    http::StatusCode,
    routing::{get, post},
    Extension, Json, Router,
};
use database_methods::{
    add_item, get_all_items, get_all_items_seen, remove_item, remove_item_from_seen,
};
use item_definitions::{AppState, Item, ItemWithoutQuantity};
use serde::{Deserialize, Serialize};
use std::{
    net::SocketAddr,
    sync::{Arc, Mutex},
};
use tokio::join;

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
        .route("/get_items", get(get_items_handler))
        .route("/delete_item", post(delete_item_handler))
        .route(
            "/delete_item_from_seen",
            post(delete_item_from_seen_handler),
        )
        .layer(Extension(app_state));

    let address = SocketAddr::from(([0, 0, 0, 0], 12568));
    let listener = tokio::net::TcpListener::bind(address).await.unwrap();
    tracing::debug!("listening on {}", address);
    axum::serve(listener, router).await.unwrap();

    Ok(())
}

async fn get_items_handler(state: Extension<Arc<AppState>>) -> (StatusCode, Json<Response>) {
    let items_fut = get_all_items(&state.0.db_manager);
    let items_seen_fut = get_all_items_seen(&state.0.db_manager);
    let (items_res, items_seen_res) = join!(items_fut, items_seen_fut);
    match (items_res, items_seen_res) {
        (Ok(items), Ok(items_seen)) => (StatusCode::OK, Json(Response { items, items_seen })),
        _ => (StatusCode::CONFLICT, Json(Response::empty())),
    }
}

async fn add_item_handler(
    state: Extension<Arc<AppState>>,
    Json(payload): Json<Item>,
) -> (StatusCode, Json<()>) {
    if add_item(&state.0.db_manager, &payload).await {
        (StatusCode::OK, Json(()))
    } else {
        (StatusCode::CONFLICT, Json(()))
    }
}

async fn delete_item_handler(
    state: Extension<Arc<AppState>>,
    Json(payload): Json<Item>,
) -> (StatusCode, Json<()>) {
    if remove_item(&state.0.db_manager, &payload).await {
        (StatusCode::OK, Json(()))
    } else {
        (StatusCode::CONFLICT, Json(()))
    }
}

async fn delete_item_from_seen_handler(
    state: Extension<Arc<AppState>>,
    Json(payload): Json<Item>,
) -> (StatusCode, Json<()>) {
    if remove_item_from_seen(&state.0.db_manager, &payload).await {
        (StatusCode::OK, Json(()))
    } else {
        (StatusCode::CONFLICT, Json(()))
    }
}

#[derive(Debug, Serialize, Deserialize)]
struct Response {
    items: Vec<Item>,
    items_seen: Vec<ItemWithoutQuantity>,
}

impl Response {
    pub fn empty() -> Self {
        Response {
            items: Vec::new(),
            items_seen: Vec::new(),
        }
    }
}
