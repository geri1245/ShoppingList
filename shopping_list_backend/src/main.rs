use std::collections::HashMap;
// use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
use rusqlite::{params, Connection, Result};

// #[get("/")]
// async fn hello() -> impl Responder {
//     HttpResponse::Ok().body("Hello world!")
// }

// #[post("/echo")]
// async fn echo(req_body: String) -> impl Responder {
//     HttpResponse::Ok().body(req_body)
// }

// async fn manual_hello() -> impl Responder {
//     HttpResponse::Ok().body("Hey there!")
// }

// #[actix_web::main]
// async fn main() -> std::io::Result<()> {
//     HttpServer::new(|| {
//         App::new()
//             .service(hello)
//             .service(echo)
//             .route("/hey", web::get().to(manual_hello))
//     })
//     .bind("127.0.0.1:8080")?
//     .run()
//     .await
// }

mod database_manager;
mod string_utils;

fn main() -> Result<()> {
    let db_manager =
        database_manager::DatabaseManager::new("./users.db3", "dummyUser".to_string())?;

    // let existing_ingredients = db_manager.query_ingredients(&recipe.ingredients)?;
    // let num_of_missing_ingredients = recipe.ingredients.len() - existing_ingredients.len();
    // println!("{:?}", num_of_missing_ingredients);
    // if num_of_missing_ingredients > 0 {
    //     let mut missing_ingredients = Vec::with_capacity(num_of_missing_ingredients);
    //     for ingredient in &recipe.ingredients {
    //         if !existing_ingredients.contains_key(&ingredient.name) {
    //             missing_ingredients.push(ingredient);
    //         }
    //     }
    //     db_manager.insert_ingredients(&missing_ingredients[..])?;
    // }

    // let all_ingredients = db_manager.query_ingredients(&recipe.ingredients)?;
    // println!("{:?}", all_ingredients.get(&recipe.ingredients[1].name));
    // let ingredients = db_manager.insert_recipe_ingredients(&recipe, 12, &all_ingredients);

    Ok(())
}
