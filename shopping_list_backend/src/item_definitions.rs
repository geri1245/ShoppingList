use std::sync::{Arc, Mutex};

use serde::{Deserialize, Serialize};

use crate::database_manager;

#[derive(Debug, Serialize, Deserialize)]
pub struct Item {
    pub name: String,
    pub quantity: u32,
    pub main_category: String,
    pub sub_category: String,
}

// Used to find items in the database (as quantity doesn't matter in those cases)
pub struct ItemToFind<'a> {
    pub name: &'a str,
    pub main_category: &'a str,
    pub sub_category: &'a str,
}

impl<'a> ItemToFind<'a> {
    pub fn from_item(item: &'a Item) -> Self {
        Self {
            name: &item.name,
            main_category: &item.main_category,
            sub_category: &item.sub_category,
        }
    }
}

#[derive(Clone)]
pub struct AppState {
    pub db_manager: Arc<Mutex<database_manager::DatabaseManager>>,
}
