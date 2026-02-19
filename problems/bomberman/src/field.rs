use std::collections::HashMap;
use std::rc::Rc;

use crate::bomb::Bomb;
use crate::player::{Move, Player, Turn};
use crate::wall::Wall;

#[derive(Clone, Debug)]
pub enum FieldCell<'a> {
    Empty,
    Wall(Wall),
    Bomb(Bomb),
    Player(Rc<Player<'a>>),
}

impl<'a> FieldCell<'a> {
    pub fn update(&mut self) -> Option<Event> {
        match self {
            FieldCell::Bomb(bomb) => {
                bomb.tick();
                if bomb.health <= 0 {
                    Some(Event::BombExploded)
                } else {
                    None
                }
            }
            _ => None,
        }
    }
}

pub enum Event {
    BombExploded,
}

#[derive(Clone, Debug)]
pub struct Field<'a> {
    pub width: u16,
    pub height: u16,
    pub cells: Vec<FieldCell<'a>>,
    coords: HashMap<String, (u16, u16)>,
}

impl<'a> Field<'a> {
    pub fn new(width: u16, height: u16) -> Self {
        let mut cells = Vec::new();
        for _ in 0..height * width {
            cells.push(FieldCell::Empty);
        }
        Field {
            width,
            height,
            cells,
            coords: HashMap::new(),
        }
    }

    pub fn place(&mut self, c: FieldCell<'a>, x: u16, y: u16) {
        self.cells[x as usize + y as usize * self.width as usize] = c;
        if let FieldCell::Player(player) =
            &self.cells[x as usize + y as usize * self.width as usize]
        {
            self.coords.insert(player.name.clone(), (x, y));
        }
    }

    pub fn apply_turn(&mut self, p: Rc<Player<'a>>, turn: Turn) -> Result<(), String> {
        let bomb_is_planted = turn.1 .0;
        let (x, y) = self.coords.get(&p.name).unwrap();
        let (dx, dy): (i16, i16) = match turn.0 {
            Move::Up => (0, 1),
            Move::Down => (0, -1),
            Move::Left => (-1, 0),
            Move::Right => (1, 0),
            Move::Stay => (0, 0),
        };
        let new_x = *x as i16 + dx;
        let new_y = *y as i16 + dy;
        if new_x < 0 || new_x >= self.width as i16 || new_y < 0 || new_y >= self.height as i16 {
            return Err("Invalid move".to_string());
        }

        self.cells[*x as usize + *y as usize * self.width as usize] = FieldCell::Empty;

        if bomb_is_planted {
            self.place(FieldCell::Bomb(Bomb::new(3)), *x, *y);
        }

        self.place(FieldCell::Player(p.clone()), new_x as u16, new_y as u16);

        Ok(())
    }

    fn process_event(&mut self, event: Event) {}

    pub fn update(&mut self) {
    }

    // This function should create a new field from a string (previosly loaded from file)
    pub fn from_str(field_str: &str) -> Self {
        unimplemented!()
    }
}
