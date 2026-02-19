use rand::Rng;
use std::cell::RefCell;

use crate::field::Field;

#[derive(Clone, Copy, Debug)]
pub struct Score(pub i32);

pub struct History<'a>(Vec<(&'a Player<'a>, Turn)>);

pub trait Strategy: std::fmt::Debug {
    fn play(&self, _: &Field) -> Turn;

    fn create_field(&self) -> Field;
}

#[derive(Debug)]
pub struct NaiveStrategy;

#[derive(Debug)]
pub enum Move {
    Up,
    Down,
    Left,
    Right,
    Stay,
}

#[derive(Debug)]
pub struct PlantBomb(pub bool);

#[derive(Debug)]
pub struct Turn(pub Move, pub PlantBomb);

impl Strategy for NaiveStrategy {
    fn play(&self, _: &Field) -> Turn {
        let mut rng = rand::rng();
        let x: u32 = rng.random();
        let y: u32 = rng.random();
        let player_move = match x % 4 {
            0 => Move::Up,
            1 => Move::Down,
            2 => Move::Left,
            3 => Move::Right,
            _ => Move::Stay,
        };
        let plant_bomb = match y % 2 {
            0 => PlantBomb(true),
            _ => PlantBomb(false),
        };

        Turn(player_move, plant_bomb)
    }

    fn create_field(&self) -> Field {
        unimplemented!()
    }
}

#[derive(Debug)]
pub struct Player<'a> {
    pub name: String,
    pub score: Score,
    pub lives: u8,
    pub field: RefCell<Field<'a>>,
    pub strategy: &'a dyn Strategy,
}

impl<'a> Player<'a> {
    pub fn new(
        name: &str,
        score: Score,
        lives: u8,
        field: RefCell<Field<'a>>,
        strategy: &'a dyn Strategy,
    ) -> Self {
        Player {
            name: name.to_string(),
            score,
            lives,
            field,
            strategy,
        }
    }

    pub fn play(&self) -> Turn {
        self.strategy.play(&self.field.borrow())
    }
}
