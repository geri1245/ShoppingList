// use crate::string_utils::{add_to_string_with_wrapping_characters, append_as_string};

use rusqlite::types::FromSql;
use rusqlite::{params, Connection, Error, Result};
use std::collections::HashMap;

// Recipes(RecipeID, Name, Categories, CookTime, PrepTime)
// Ingredients(IngredientID, Name, NutritionalData)
// RecipeIngredients(RecipeID, IngredientID, Phase, Quantity, Unit)

const TABLE_NAME: &'static str = "";

pub struct DatabaseManager {
    connection: Connection,
    _user_name: String,
}

impl DatabaseManager {
    // No need for the batch execution right now, but keep it for later, when more tables might be created
    fn create_tables(&self) -> Result<()> {
        format!("");
        let table_creation_queries = "CREATE TABLE IF NOT EXISTS ShoppingList (
                      Item            TEXT,
                      Quantity        INTEGER);";
        self.connection.execute_batch(table_creation_queries)
    }

    pub fn new(database_folder: &str, user_name: String) -> Result<DatabaseManager> {
        let conn = Connection::open(database_folder)?;
        let db_manager = DatabaseManager {
            connection: conn,
            _user_name: user_name,
        };
        db_manager.create_tables()?;
        Ok(db_manager)
    }

    pub fn add_item(item: String, quantity: u32) {
        "INSERT INTO Recipes (name, categories, cookTime, prepTime) VALUES (?1 ?2)";
    }

    // pub fn insert_recipe(&self, recipe: Recipe) -> Result<()> {
    //     let count_query = "SELECT COUNT(*) FROM Recipes WHERE userName = ?1 AND recipeName = ?2";
    //     let mut result = self.connection.prepare(count_query)?;
    //     let mut result_iter = result.query_map(params![recipe.user_name, recipe.name], |rows| {
    //         Ok(rows.get::<_, i32>(0)?)
    //     })?;
    //     let num_of_recipes = result_iter.next().unwrap_or(Ok(0))?;

    //     if num_of_recipes != 0 {
    //         return Ok(());
    //     }
    //     let query =
    //         "INSERT INTO Recipes (name, categories, cookTime, prepTime) VALUES (?1 ?2 ?3 ?4)";
    //     self.connection.execute(
    //         query,
    //         params![
    //             recipe.name,
    //             recipe.categories.join(" "),
    //             recipe.cook_time,
    //             recipe.prep_time
    //         ],
    //     )?;
    //     Ok(())
    // }

    // fn single_result_query<T: FromSql>(&self, query: &str) -> Result<T> {
    //     let mut statement = self.connection.prepare(&query)?;
    //     let mut iter = statement.query_map([], |row| Ok(row.get::<usize, T>(0)?))?;

    //     match iter.next() {
    //         Some(row) => row,
    //         None => Err(Error::QueryReturnedNoRows),
    //     }
    // }

    // pub fn insert_ingredients(&self, ingredients: &[&Ingredient]) -> Result<usize> {
    //     let mut query = "INSERT INTO Ingredients (ingredientName) VALUES ".to_owned();
    //     query.push_str(
    //         DatabaseManager::ingredients_to_comma_separated_string_with_parens(ingredients)
    //             .as_str(),
    //     );
    //     println!("{}", query);
    //     self.connection.execute(&query, [])
    // }

    // pub fn insert_recipe_ingredients(
    //     &self,
    //     recipe: &Recipe,
    //     recipe_id: u32,
    //     ingredient_name_to_id: &HashMap<String, u32>,
    // ) -> Option<usize> {
    //     let ingredients = &recipe.ingredients;
    //     let mut query =
    //         "INSERT INTO RecipeIngredients (recipeID, ingredientID, phase, quantity, unit) VALUES "
    //             .to_owned();

    //     for ingredient in ingredients {
    //         let ingredient_id = ingredient_name_to_id.get(&ingredient.name)?;
    //         query.push('(');
    //         query.push_str(recipe_id.to_string().as_str());
    //         query.push(',');
    //         query.push_str(ingredient_id.to_string().as_str());
    //         query.push(',');
    //         query.push_str(ingredient.phase.to_string().as_str());
    //         query.push(',');
    //         query.push_str(ingredient.quantity.to_string().as_str());
    //         query.push(',');
    //         append_as_string(&mut query, &ingredient.unit);
    //         query.push_str("),");
    //     }
    //     if ingredients.len() > 0 {
    //         query.pop();
    //     }

    //     match self.connection.execute(&query, []) {
    //         Ok(num) => Some(num),
    //         Err(e) => {
    //             println!("{:?}", e);
    //             None
    //         }
    //     }
    // }

    // pub fn query_ingredients(&self, ingredients: &[Ingredient]) -> Result<HashMap<String, u32>> {
    //     let mut query =
    //         "SELECT ingredientID, ingredientName from Ingredients where ingredientName in ("
    //             .to_owned();
    //     query.push_str(
    //         DatabaseManager::ingredients_to_comma_separated_string(&ingredients).as_str(),
    //     );
    //     query.push(')');
    //     let mut statement = self.connection.prepare(&query)?;
    //     let iter = statement.query_map([], |row| {
    //         Ok((row.get::<usize, u32>(0)?, row.get::<usize, String>(1)?))
    //     })?;

    //     // TODO: reserve properly with some size?
    //     let mut already_contained_ingredients = HashMap::with_capacity(8);
    //     for row in iter {
    //         let actual_row = row?;
    //         already_contained_ingredients.insert(actual_row.1, actual_row.0);
    //     }
    //     Ok(already_contained_ingredients)
    // }
}
