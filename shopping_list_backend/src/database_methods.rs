use std::{
    collections::HashMap,
    sync::{Arc, Mutex},
};

use crate::{database_manager::DatabaseManager, item_definitions::ItemToFind, Item};

pub async fn get_all_items(db_manager: &Arc<Mutex<DatabaseManager>>) -> anyhow::Result<Vec<Item>> {
    let db_manager = db_manager.lock().unwrap();

    db_manager.get_all_items()
}

pub async fn get_all_items_seen(
    db_manager: &Arc<Mutex<DatabaseManager>>,
) -> anyhow::Result<HashMap<String, Vec<String>>> {
    let db_manager = db_manager.lock().unwrap();

    let items = db_manager.get_seen_items()?;
    let mut category_to_items_map: HashMap<String, Vec<String>> = HashMap::new();

    for (category, name) in items.into_iter() {
        if let Some(items) = category_to_items_map.get_mut(&category) {
            items.push(name.to_lowercase());
        } else {
            category_to_items_map.insert(category, vec![name.to_lowercase()]);
        }
    }

    Ok(category_to_items_map)
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
