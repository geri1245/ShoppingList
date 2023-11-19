use std::sync::{Arc, Mutex};

use crate::{database_manager::DatabaseManager, ShoppingItem};

pub async fn add_item(
    db_manager: &Arc<Mutex<DatabaseManager>>,
    item: &ShoppingItem,
) -> anyhow::Result<bool> {
    let db_manager = db_manager.lock().unwrap();
    if !db_manager.contains(&item.name)? {
        db_manager.add_item(item)?;
        return Ok(true);
    } else {
        return Ok(false);
    }
}
