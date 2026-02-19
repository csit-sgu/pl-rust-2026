use std::{
    io::{stdout, Write},
    thread,
    time::Duration,
};

use crate::field::{Field, FieldCell};
use crossterm::{
    cursor,
    terminal::{Clear, ClearType},
    ExecutableCommand,
};

pub trait Drawer {
    fn draw_field(&mut self, field: &Field);
}

pub struct ConsoleDrawer {
    stdout: std::io::Stdout,
}

impl ConsoleDrawer {
    pub fn new() -> Self {
        let stdout = stdout();
        Self { stdout }
    }
}

impl Drawer for ConsoleDrawer {
    fn draw_field(&mut self, field: &Field) {
        self.stdout.execute(Clear(ClearType::All)).unwrap();
        for x in 0..field.width {
            for y in 0..field.height {
                self.stdout.execute(cursor::MoveTo(x, y)).unwrap();
                match &field.cells[x as usize + y as usize * field.width as usize] {
                    FieldCell::Empty => print!("."),
                    FieldCell::Wall(_) => print!("#"),
                    FieldCell::Bomb(_) => print!("x"),
                    FieldCell::Player(player) => print!("{}", player.name.chars().next().unwrap()),
                }
            }
            print!("\n");
        }
        self.stdout.flush().unwrap();

        thread::sleep(Duration::from_millis(2000)); // Sleep for 500 ms
    }
}
