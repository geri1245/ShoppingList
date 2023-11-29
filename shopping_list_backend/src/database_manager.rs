// use crate::string_utils::{add_to_string_with_wrapping_characters, append_as_string};

use anyhow::anyhow;
use rusqlite::types::FromSql;
use rusqlite::{Connection, Error, Result};

pub enum QueryResult<T> {
    Ok(T),
    NoRowsReturned,
}

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
                    name: row.get("Name")?,
                    quantity: row.get("Quantity")?,
                    category: row.get("Category")?,
                })
            })?
            .filter_map(|result_item| result_item.ok())
            .collect();

        Ok(items)
    }

    pub fn get_where(
        &self,
        name: &String,
        category: &String,
    ) -> anyhow::Result<QueryResult<ShoppingItem>> {
        let query = format!("Select * from {TABLE_NAME} WHERE Name=?1 AND Category=?2;");
        let mut statement = self.connection.prepare(&query)?;

        let mut iter = statement.query_map(&[name, category], |row| {
            Ok(ShoppingItem {
                name: row.get("Name")?,
                quantity: row.get("Quantity")?,
                category: row.get("Category")?,
            })
        })?;

        match iter.next() {
            Some(row) => match row {
                Ok(item) => Ok(QueryResult::Ok(item)),
                Err(error) => Err(anyhow!(error)),
            },
            None => Ok(QueryResult::NoRowsReturned),
        }
    }

    pub fn contains(&self, name: &String, category: &String) -> anyhow::Result<bool> {
        match self.get_where(name, category) {
            Ok(QueryResult::Ok(_)) => Ok(true),
            Ok(QueryResult::NoRowsReturned) => Ok(false),
            Err(error) => Err(anyhow!(error)),
        }
    }

    pub fn add_item_if_not_present(&self, item: &ShoppingItem) -> bool {
        match self.contains(&item.name, &item.category) {
            Ok(true) => false,
            Ok(false) => match self.add_item(item) {
                Ok(_) => true,
                Err(_) => false,
            },
            Err(_) => false,
        }
    }

    pub fn add_item(&self, item: &ShoppingItem) -> anyhow::Result<()> {
        let query =
            format!("INSERT INTO {TABLE_NAME} (Name, Quantity, Category) VALUES (?1, ?2, ?3);");
        self.connection.execute(
            &query,
            &[&item.name, &item.quantity.to_string(), &item.category],
        )?;

        Ok(())
    }

    pub fn delete_item(&self, item: &ShoppingItem) -> anyhow::Result<()> {
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
