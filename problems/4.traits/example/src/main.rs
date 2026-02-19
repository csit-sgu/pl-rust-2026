#![forbid(unsafe_code)]

struct Cat;
struct Dog;

trait Say {
  fn say(&self);
}

impl Say for Cat {
  fn say(&self) { println!("meow") }
}

impl Say for Dog {
  fn say(&self) { println!("woof-woof") }
}

fn force_say<T: Say>(t: &T) {
  t.say();
  t.say();
}