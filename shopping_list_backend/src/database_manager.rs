// use crate::string_utils::{add_to_string_with_wrapping_characters, append_as_string};

use rusqlite::types::FromSql;
use rusqlite::{Connection, Error, Result};

// Recipes(RecipeID, Name, Categories, CookTime, PrepTime)
// Ingredients(IngredientID, Name, NutritionalData)
// RecipeIngredients(RecipeID, IngredientID, Phase, Quantity, Unit)

const TABLE_NAME: &'static str = "ShoppingList";

pub struct DatabaseManager {
    connection: Connection,
    _user_name: String,
}

use crate::ShoppingItem;

impl DatabaseManager {
    fn create_table(&self) -> Result<()> {
        let table_creation_queries = format!(
            "CREATE TABLE IF NOT EXISTS {TABLE_NAME} (
                Item            TEXT,
                Quantity        INTEGER,
                Category        TEXT);"
        );
        self.connection.execute_batch(&table_creation_queries)
    }

    pub fn new(database_path: &str, user_name: String) -> Result<DatabaseManager> {
        let conn = Connection::open(database_path)?;
        let db_manager = DatabaseManager {
            connection: conn,
            _user_name: user_name,
        };

        db_manager.create_table()?;

        Ok(db_manager)
    }

    pub fn get_all(&self) -> Result<Vec<ShoppingItem>> {
        let query = format!("Select * from {TABLE_NAME}");
        let mut statement = self.connection.prepare(&query)?;

        let items = statement
            .query_map([], |row| {
                Ok(ShoppingItem {
                    category: "default".to_owned(),
                    name: row.get(0)?,
                    quantity: row.get(1)?,
                })
            })?
            .filter_map(|result_item| result_item.ok())
            .collect();

        Ok(items)
    }

    pub fn get_where(&self, name: &String) -> Result<ShoppingItem> {
        let query = format!("Select * from {TABLE_NAME} WHERE Item=?1");
        let mut statement = self.connection.prepare(&query)?;

        let mut iter = statement.query_map([&name], |row| {
            Ok(ShoppingItem {
                category: "default".to_owned(),
                name: row.get(0)?,
                quantity: row.get(1)?,
            })
        })?;

        match iter.next() {
            Some(row) => match row {
                Ok(item) => Ok(item),
                Err(_) => Err(Error::ExecuteReturnedResults),
            },
            None => Err(Error::QueryReturnedNoRows),
        }
    }

    pub fn contains(&self, name: &String) -> Result<bool> {
        match self.get_where(name) {
            Ok(_) => Ok(true),
            Err(error) => {
                if error == Error::QueryReturnedNoRows {
                    Ok(false)
                } else {
                    Err(error)
                }
            }
        }
    }

    pub fn add_item(&self, item: &ShoppingItem) -> Result<()> {
        let query = format!("INSERT INTO {TABLE_NAME} (Item, Quantity) VALUES (?1, ?2)");
        self.connection
            .execute(&query, &[&item.name, &item.quantity.to_string()])?;

        Ok(())
    }

    pub fn delete_item(&self, item: &ShoppingItem) -> Result<()> {
        let query = format!("DELETE FROM {TABLE_NAME} WHERE Item=?1");
        self.connection.execute(&query, &[&item.name])?;

        Ok(())
    }

    fn _single_result_query<T: FromSql>(&self, query: &str) -> Result<T> {
        let mut statement = self.connection.prepare(&query)?;
        let mut iter = statement.query_map([], |row| Ok(row.get::<usize, T>(0)?))?;

        match iter.next() {
            Some(row) => row,
            None => Err(Error::QueryReturnedNoRows),
        }
    }
}
