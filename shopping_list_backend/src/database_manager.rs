// use crate::string_utils::{add_to_string_with_wrapping_characters, append_as_string};

use anyhow::anyhow;
use rusqlite::types::FromSql;
use rusqlite::{Connection, Error, Result, Row};

const ITEMS_TABLE_NAME: &'static str = "ShoppingList";
const ITEMS_SEEN_TABLE_NAME: &'static str = "ItemsSeen";
const NAME_COLUMN_NAME: &'static str = "name";
const MAIN_CATEGORY_COLUMN_NAME: &'static str = "mainCategory";
const SUB_CATEGORY_COLUMN_NAME: &'static str = "subCategory";
const QUANTITY_COLUMN_NAME: &'static str = "quantity";
const DATE_ADDED_COLUMN_NAME: &'static str = "dateAdded";

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

use crate::item_definitions::ItemToFind;
use crate::Item;

impl DatabaseManager {
    fn create_tables(&self) -> Result<()> {
        let table_creation_queries = format!(
            "CREATE TABLE IF NOT EXISTS {ITEMS_TABLE_NAME} (
                {NAME_COLUMN_NAME}            TEXT COLLATE NOCASE,
                {QUANTITY_COLUMN_NAME}        INTEGER,
                {MAIN_CATEGORY_COLUMN_NAME}   TEXT COLLATE NOCASE,
                {SUB_CATEGORY_COLUMN_NAME}    TEXT COLLATE NOCASE,
                primary key ({NAME_COLUMN_NAME}, {MAIN_CATEGORY_COLUMN_NAME}, {SUB_CATEGORY_COLUMN_NAME})
            );
             CREATE TABLE IF NOT EXISTS {ITEMS_SEEN_TABLE_NAME} (
                {NAME_COLUMN_NAME}              TEXT COLLATE NOCASE,
                {MAIN_CATEGORY_COLUMN_NAME}     TEXT COLLATE NOCASE,
                {SUB_CATEGORY_COLUMN_NAME}      TEXT COLLATE NOCASE,
                {DATE_ADDED_COLUMN_NAME}        TEXT,
                primary key ({NAME_COLUMN_NAME}, {MAIN_CATEGORY_COLUMN_NAME}, {SUB_CATEGORY_COLUMN_NAME})
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

    pub fn get_all_items(&self) -> anyhow::Result<Vec<Item>> {
        self.get_all(
            &|row| {
                Ok(Item {
                    name: row.get(NAME_COLUMN_NAME)?,
                    quantity: row.get(QUANTITY_COLUMN_NAME)?,
                    main_category: row.get(MAIN_CATEGORY_COLUMN_NAME)?,
                    sub_category: row.get(SUB_CATEGORY_COLUMN_NAME)?,
                })
            },
            Table::Items,
        )
    }

    pub fn get_seen_items(&self) -> anyhow::Result<Vec<(String, String)>> {
        self.get_all(
            &|row| {
                Ok((
                    row.get(MAIN_CATEGORY_COLUMN_NAME)?,
                    row.get(NAME_COLUMN_NAME)?,
                ))
            },
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

    pub fn get_where(&self, item_to_find: ItemToFind) -> anyhow::Result<QueryResult<Item>> {
        let query =
            format!("Select * from {ITEMS_TABLE_NAME} WHERE {NAME_COLUMN_NAME}=?1 AND {MAIN_CATEGORY_COLUMN_NAME}=?2 AND {SUB_CATEGORY_COLUMN_NAME}=?3;");
        let mut statement = self.connection.prepare(&query)?;

        let mut iter = statement.query_map(
            &[
                item_to_find.name,
                item_to_find.main_category,
                item_to_find.sub_category,
            ],
            |row| {
                Ok(Item {
                    name: row.get(NAME_COLUMN_NAME)?,
                    quantity: row.get(QUANTITY_COLUMN_NAME)?,
                    main_category: row.get(MAIN_CATEGORY_COLUMN_NAME)?,
                    sub_category: row.get(SUB_CATEGORY_COLUMN_NAME)?,
                })
            },
        )?;

        match iter.next() {
            Some(row) => match row {
                Ok(item) => Ok(QueryResult::Ok(item)),
                Err(error) => Err(anyhow!(error)),
            },
            None => Ok(QueryResult::NoRowsReturned),
        }
    }

    pub fn contains(&self, item_to_find: ItemToFind) -> anyhow::Result<bool> {
        match self.get_where(item_to_find) {
            Ok(QueryResult::Ok(_)) => Ok(true),
            Ok(QueryResult::NoRowsReturned) => Ok(false),
            Err(error) => Err(anyhow!(error)),
        }
    }

    pub fn add_to_items(&self, item: &Item) -> anyhow::Result<()> {
        let query = format!(
            "INSERT INTO {ITEMS_TABLE_NAME} ({NAME_COLUMN_NAME}, {QUANTITY_COLUMN_NAME}, {MAIN_CATEGORY_COLUMN_NAME}, {SUB_CATEGORY_COLUMN_NAME}) VALUES (?1, ?2, ?3, ?4);"
        );

        self.connection.execute(
            &query,
            &[
                &item.name,
                &item.quantity.to_string(),
                &item.main_category,
                &item.sub_category,
            ],
        )?;

        Ok(())
    }

    pub fn add_to_items_seen(&self, item: &Item) -> anyhow::Result<()> {
        let query = format!(
            "INSERT INTO {ITEMS_SEEN_TABLE_NAME} ({NAME_COLUMN_NAME}, {MAIN_CATEGORY_COLUMN_NAME}, {SUB_CATEGORY_COLUMN_NAME}, {DATE_ADDED_COLUMN_NAME}) VALUES (?1, ?2, ?3, date());"
        );

        self.connection.execute(
            &query,
            &[&item.name, &item.main_category, &item.sub_category],
        )?;

        Ok(())
    }

    pub fn delete_item(&self, item: &Item) -> anyhow::Result<()> {
        let query = format!("DELETE FROM {ITEMS_TABLE_NAME} WHERE {NAME_COLUMN_NAME}=?1 AND {MAIN_CATEGORY_COLUMN_NAME}=?2 AND {SUB_CATEGORY_COLUMN_NAME}=?3;");
        self.connection.execute(
            &query,
            &[&item.name, &item.main_category, &item.sub_category],
        )?;

        Ok(())
    }

    pub fn delete_item_from_seen(&self, item: &Item) -> anyhow::Result<()> {
        let query = format!("DELETE FROM {ITEMS_SEEN_TABLE_NAME} WHERE {NAME_COLUMN_NAME}=?1 AND {MAIN_CATEGORY_COLUMN_NAME}=?2 AND {SUB_CATEGORY_COLUMN_NAME}=?3;");
        self.connection.execute(
            &query,
            &[&item.name, &item.main_category, &item.sub_category],
        )?;

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
