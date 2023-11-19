// use crate::string_utils::{add_to_string_with_wrapping_characters, append_as_string};

use rusqlite::types::FromSql;
use rusqlite::{Connection, Error, Result};

const TABLE_NAME: &'static str = "ShoppingList";

pub struct DatabaseManager {
    connection: Connection,
    _user_name: String,
}

use crate::ShoppingItem;

impl DatabaseManager {
    fn _create_table(&self) -> Result<()> {
        let table_creation_queries = format!(
            "CREATE TABLE IF NOT EXISTS {TABLE_NAME} (
                Name            TEXT,
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

        db_manager._create_table()?;

        Ok(db_manager)
    }

    pub fn get_all(&self) -> Result<Vec<ShoppingItem>> {
        let query = format!("Select * from {TABLE_NAME};");
        let mut statement = self.connection.prepare(&query)?;

        let items = statement
            .query_map([], |row| {
                Ok(ShoppingItem {
                    name: row.get(0)?,
                    quantity: row.get(1)?,
                    category: row.get(2)?,
                })
            })?
            .filter_map(|result_item| result_item.ok())
            .collect();

        Ok(items)
    }

    pub fn get_where(&self, name: &String, category: &String) -> Result<ShoppingItem> {
        let query = format!("Select * from {TABLE_NAME} WHERE Name=?1 AND Category=?2;");
        let mut statement = self.connection.prepare(&query)?;

        let mut iter = statement.query_map(&[&name, &category], |row| {
            Ok(ShoppingItem {
                name: row.get(0)?,
                quantity: row.get(1)?,
                category: row.get(2)?,
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

    pub fn contains(&self, name: &String, category: &String) -> Result<bool> {
        match self.get_where(name, category) {
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
        let query =
            format!("INSERT INTO {TABLE_NAME} (Name, Quantity, Category) VALUES (?1, ?2, ?3);");
        self.connection.execute(
            &query,
            &[&item.name, &item.quantity.to_string(), &item.category],
        )?;

        Ok(())
    }

    pub fn delete_item(&self, item: &ShoppingItem) -> Result<()> {
        let query = format!("DELETE FROM {TABLE_NAME} WHERE Name=?1 AND Category=?2;");
        self.connection
            .execute(&query, &[&item.name, &item.category])?;

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
