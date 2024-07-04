use std::sync::{Arc, Mutex};

use crate::{
    database_manager::DatabaseManager,
    item_definitions::{ItemToFind, ItemWithoutQuantity},
    Item,
};

pub async fn get_all_items(db_manager: &Arc<Mutex<DatabaseManager>>) -> anyhow::Result<Vec<Item>> {
    let db_manager = db_manager.lock().unwrap();

    db_manager.get_all_items()
}

pub async fn get_all_items_seen(
    db_manager: &Arc<Mutex<DatabaseManager>>,
) -> anyhow::Result<Vec<ItemWithoutQuantity>> {
    let db_manager = db_manager.lock().unwrap();

    db_manager.get_seen_items()
}

pub async fn add_item(db_manager: &Arc<Mutex<DatabaseManager>>, item: &Item) -> bool {
    let db_manager = db_manager.lock().unwrap();

    match db_manager.contains(ItemToFind::from_item(item)) {
        Ok(true) => false,
        Ok(false) => match db_manager.add_to_items(item) {
            Ok(_) => {
                // Ignore the result, it's not that important to add it to items seen
                _ = db_manager.add_to_items_seen(item);
                true
            }
            Err(_) => false,
        },
        Err(_) => false,
    }
}

pub async fn remove_item(db_manager: &Arc<Mutex<DatabaseManager>>, item: &Item) -> bool {
    let db_manager = db_manager.lock().unwrap();

    db_manager.delete_item(item).is_ok()
}

pub async fn remove_item_from_seen(db_manager: &Arc<Mutex<DatabaseManager>>, item: &Item) -> bool {
    let db_manager = db_manager.lock().unwrap();

    db_manager.delete_item_from_seen(item).is_ok()
}
