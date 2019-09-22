extern crate tera;
extern crate serde_json;

use serde_json::Value;
use tera::{Tera, Context};
use std::fs;

fn main() {

    let tmpl = match Tera::new("templates/*") {
        Ok(tmpl) => tmpl,
        Err(e) => {
            println!("Parsing error(s): {}", e);
                         ::std::process::exit(1);
        }
    };

    let config_json = fs::read_to_string("configure.json").expect("Could not read json config");
    let config_value: Value = serde_json::from_str(&config_json).expect("Could not deserialize json config");
    let ctx = Context::from_value(config_value).expect("Could not greate context from JSON encoded blob");

    let rendered = tmpl.render("interfaces", ctx.clone());
    match rendered {
        Ok(r) => println!("{}", r),
        Err(e) => {
            println!("Rendering errors(s): {}", e);
        },
    }
    //let serialized =  ctx.into_json();
    //println!("serialized = {}", serialized);
}
