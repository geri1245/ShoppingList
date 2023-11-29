use std::sync::{Arc, Mutex};

use crate::{database_manager::DatabaseManager, ShoppingItem};

pub async fn add_item(db_manager: &Arc<Mutex<DatabaseManager>>, item: &ShoppingItem) -> bool {
    let db_manager = db_manager.lock().unwrap();

    return db_manager.add_item_if_not_present(&item);
}

pub async fn remove_item(db_manager: &Arc<Mutex<DatabaseManager>>, item: &ShoppingItem) -> bool {
    let db_manager = db_manager.lock().unwrap();

    db_manager.delete_item(item).is_ok()
}
