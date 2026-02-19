use std::{cell::RefCell, rc::Rc};

use draw::Drawer;
use field::{Field, FieldCell};

pub mod bomb;
pub mod draw;
pub mod field;
pub mod player;
pub mod wall;

fn main() {
    let field = RefCell::new(Field::new(10, 10));

    let mut console = draw::ConsoleDrawer::new();

    let mut p1 = Rc::new(player::Player::new(
        &"Bob".to_string(),
        player::Score(0),
        3,
        field.clone(),
        &player::NaiveStrategy,
    ));

    let mut p2 = Rc::new(player::Player::new(
        &"Alice".to_string(),
        player::Score(0),
        3,
        field.clone(),
        &player::NaiveStrategy,
    ));
    {
        let mut field_ref = field.borrow_mut();
        field_ref.place(FieldCell::Player(p1.clone()), 0, 0);
        field_ref.place(FieldCell::Player(p2.clone()), 9, 9);
    }

    loop {
        let mut field_ref = field.borrow_mut();
        for player in &[&mut p1, &mut p2] {
            let turn = player.play();
            let player_name = &player.name;
            println!("{player_name} turn: {:?}", turn);
            let rc = Rc::clone(player);
            let result = field_ref.apply_turn(rc, turn);
            if result.is_err() {
                println!("{player_name} turn: {:?}", result);
            }

            console.draw_field(&field_ref);
        }
    }
}
