// use crate::string_utils::{add_to_string_with_wrapping_characters, append_as_string};

use anyhow::anyhow;
use rusqlite::types::FromSql;
use rusqlite::{Connection, Error, Result, Row};

const ITEMS_TABLE_NAME: &'static str = "ShoppingList";
const ITEMS_SEEN_TABLE_NAME: &'static str = "ItemsSeen";

pub enum QueryResult<T> {
    Ok(T),
    NoRowsReturned,
}

pub enum Table {
    Items,
    ItemsSeen,
}

pub const fn table_to_table_name(table: Table) -> &'static str {
    match table {
        Table::Items => ITEMS_TABLE_NAME,
        Table::ItemsSeen => ITEMS_SEEN_TABLE_NAME,
    }
}

pub struct DatabaseManager {
    connection: Connection,
    _user_name: String,
}

use crate::ShoppingItem;

impl DatabaseManager {
    fn create_tables(&self) -> Result<()> {
        let table_creation_queries = format!(
            "CREATE TABLE IF NOT EXISTS {ITEMS_TABLE_NAME} (
                Name            TEXT,
                Quantity        INTEGER,
                Category        TEXT,
                primary key (Name, Category)
            );
             CREATE TABLE IF NOT EXISTS {ITEMS_SEEN_TABLE_NAME} (
                Category        TEXT,
                Name            TEXT,
                Date            TEXT,
                primary key (Name, Category)
            );"
        );
        self.connection.execute_batch(&table_creation_queries)
    }

    pub fn new(database_path: &str, user_name: String) -> Result<DatabaseManager> {
        let conn = Connection::open(database_path)?;
        let db_manager = DatabaseManager {
            connection: conn,
            _user_name: user_name,
        };

        db_manager.create_tables()?;

        Ok(db_manager)
    }

    pub fn get_all_items(&self) -> anyhow::Result<Vec<ShoppingItem>> {
        self.get_all(
            &|row| {
                Ok(ShoppingItem {
                    name: row.get("Name")?,
                    quantity: row.get("Quantity")?,
                    category: row.get("Category")?,
                })
            },
            Table::Items,
        )
    }

    pub fn get_seen_items(&self) -> anyhow::Result<Vec<(String, String)>> {
        self.get_all(
            &|row| Ok((row.get("Category")?, row.get("Name")?)),
            Table::ItemsSeen,
        )
    }

    pub fn get_all<ReturnType, ConversionFunction>(
        &self,
        func: &ConversionFunction,
        table: Table,
    ) -> anyhow::Result<Vec<ReturnType>>
    where
        ConversionFunction: Fn(&Row<'_>) -> rusqlite::Result<ReturnType>,
    {
        let table_name = table_to_table_name(table);
        let query = format!("Select * from {table_name};");
        let mut statement = self.connection.prepare(&query)?;

        let items = statement
            .query_map([], func)?
            .filter_map(|result_item| result_item.ok())
            .collect();

        Ok(items)
    }

    pub fn get_where(
        &self,
        name: &String,
        category: &String,
    ) -> anyhow::Result<QueryResult<ShoppingItem>> {
        let query = format!("Select * from {ITEMS_TABLE_NAME} WHERE Name=?1 AND Category=?2;");
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

    pub fn add_to_items(&self, item: &ShoppingItem) -> anyhow::Result<()> {
        let query = format!(
            "INSERT INTO {ITEMS_TABLE_NAME} (Name, Quantity, Category) VALUES (?1, ?2, ?3);"
        );

        self.connection.execute(
            &query,
            &[&item.name, &item.quantity.to_string(), &item.category],
        )?;

        Ok(())
    }

    pub fn add_to_items_seen(&self, item: &ShoppingItem) -> anyhow::Result<()> {
        let query = format!(
            "INSERT INTO {ITEMS_SEEN_TABLE_NAME} (Category, Name, Date) VALUES (?1, ?2, date());"
        );

        self.connection
            .execute(&query, &[&item.category, &item.name])?;

        Ok(())
    }

    pub fn delete_item(&self, item: &ShoppingItem) -> anyhow::Result<()> {
        let query = format!("DELETE FROM {ITEMS_TABLE_NAME} WHERE Name=?1 AND Category=?2;");
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
