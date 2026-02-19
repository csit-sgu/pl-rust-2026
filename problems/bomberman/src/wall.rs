#[derive(Clone, Debug)]
pub struct Wall {
    pub destroyable: bool,
}

impl Wall {
    pub fn new(destroyable: bool) -> Self {
        Wall { destroyable }
    }
}
