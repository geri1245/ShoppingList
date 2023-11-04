mod database_manager;
mod string_utils;

use axum::{
    extract::State,
    http::StatusCode,
    routing::{get, post},
    Json, Router,
};
use serde::{Deserialize, Serialize};
use std::{
    net::SocketAddr,
    sync::{Arc, Mutex},
};

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    // initialize tracing
    tracing_subscriber::fmt::init();

    let db_manager = Arc::new(Mutex::new(database_manager::DatabaseManager::new(
        "./my_db.sq3",
        "awesomeuser".into(),
    )?));

    // db_manager.add_item()?;
    // db_manager.add_item("sonka".into(), 3)?;
    // let items = db_manager.lock().unwrap().get_all();
    // dbg!(items);

    // build our application with a route
    let router: Router<AppState> =
        Router::new()
            .route("/add_item", post(add_item))
            .with_state(AppState {
                db_manager: db_manager.clone(),
            });

    let router: Router<()> = router
        .route("/get_items", get(get_list))
        .with_state(AppState {
            db_manager: db_manager.clone(),
        });

    let addr = SocketAddr::from(([127, 0, 0, 1], 3000));
    tracing::debug!("listening on {}", addr);
    axum::Server::bind(&addr)
        .serve(router.into_make_service())
        .await
        .unwrap();

    Ok(())
}

async fn get_list(state: State<AppState>) -> Json<Vec<ShoppingItem>> {
    Json(state.0.db_manager.lock().unwrap().get_all().unwrap())
}

async fn add_item(
    state: State<AppState>,
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

// the input to our `create_user` handler
#[derive(Deserialize)]
struct CreateUser {
    username: String,
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
