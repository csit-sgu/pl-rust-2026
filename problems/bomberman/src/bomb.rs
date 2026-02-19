#[derive(Clone, Debug)]
pub struct Bomb {
    pub durability: i32,
    pub health: i32,
}

impl Bomb {
    pub fn new(durability: i32) -> Self {
        Bomb {
            durability,
            health: durability,
        }
    }

    pub fn tick(&mut self) {
        self.health -= 1;
    }
}
