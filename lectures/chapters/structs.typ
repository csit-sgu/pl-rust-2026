#import "../globals.typ": *

= Структуры

== Создание структур

```rs
#[derive(Clone, Copy)]
struct Point {
  x: f64,
  y: f64
}

let a = Point {x: 3, y: 4};
let b = Point::new(3.0, 4.0);
let c = Point {x: 4, y: ..a};
```

== Реализация структур

Набор полей и реализация методов в Rust определяется отдельно:
```rs
struct Point {
  x: f64,
  y: f64
}
impl Point { // Реализация
  pub fn new(x: f64, y: f64) -> Self {
    Self { x, y }
  }
}
```

---

Давайте добавим ещё пару методов с `self`
```rs
impl Point {
  fn distance(&self, other: Self) -> f64 {
    let Point {x: x1, y: y1} = &self;
    let Point {x: x2, y: y2} = other;
    ((x1 - y1).powi(2) + (x2 - y2).powi(2)).sqrt()
  }
  fn destroy(self) {}
}
```

`Self` — псевдоним для типа, для которого реализуется поведение

---

"Получателем" (reciever) может быть и какой-то контейнер с `Self` внутри.
```rs
struct Foo {
    x: u32,
}
impl Foo {
    pub fn scream(self: Box<Self>) {
        println!("I'm inside the box!")
    }
}
fn main() {
    let foo_in_box = Box::new(Foo { x: 42 });
    foo_in_box.scream();
}
```

---

== Структуры-кортежи
```rs
struct Point(f64, f64);

impl Point {
  fn x(&self) -> f64 {
    self.0;
  }
}
```

== Паттерн `newtype`

```rs
struct Kilometers(f64);
struct Miles(f64);
```

Вопрос: Когда разумно использовать `newtype`?

== Абстрактные структуры (generics)
```rs
struct SillyVector<T> {
  cnt: usize,
  data: Vec<T>,
}
impl<T> SillyVector<T> { // вот тут
  pub fn push(&mut self, x: T) {
    self.data.push(x);
  }
}
```

Вопрос: Зачем два раза упоминается тип `T`?

---

Использование абстрактных структур

```rs
let y = Vector::<i32>::new();
let z: Vector<i32> = Vector {
  cnt: 0, data: Vec::new(),
}
let z:  Vector::<i32> = Vector {
  cnt: 0, data: Vec::new(),
}
```

== Turbofish

Обратите внимание на строчку
```rs
let y = Vector::<i32>::new();
```

Наличие дополнительных `::` перед типом называется "turbofish" и используется для разрешения неоднозначности между указанием типа и оператором < в выражении.

---

== Использование ссылок в структурах

```rs
struct Borrowed<'a> {
    name: &'a str,
    surname: &'b str,
}
```

Использование ссылок в структурах является редким случаем, однако если это необходимо, то нужно явно указать время жизни для таких ссылок.

Если структура содержит ссылку, то программист должен помнить, что время жизни этой структуры должно быть не больше времени жизни ссылки внутри неё.

== Типы нулевого размера (Zero-Sized Types)

```rs
struct Tag;

let t = Tag;
assert!(std::mem::size_of::<Tag>() = 0);
```

== Типы переменного размера (Dynamically Sized Types)

Это типы, чей размер неизвестен во время компиляции.

Пока что мы знаем только про `[i32]` и `str`:
```rs
let arr: [i32; 5] = [10, 20, 30, 40, 50];
let slice: &[i32] = &arr[1..4]; // A slice from index 1 to 3
println!("Size of array reference: {} bytes", mem::size_of_val(&arr));
println!("Size of slice reference: {} bytes", mem::size_of_val(&slice));
```

О ещё одной категории DST поговорим позже.

== Перечисления (Enums)

```rs
enum MyEnum {
  First, Second, Third
}
```
```rs
enum GenericEnum<T> {
  First(i32),
  Second(i64, Example<T>),
}
```

Размер перечисления равен размеру самого длинного варианта + память под дискриминант.

== Пустые типы

Можно определить вот такое перечисление
```rs
enum Void {}
```

== "Рекурсивные" перечисления

Будет ли работать?
```rs
enum Expr {
  BinOp { lhs: Expr, rhs: Expr },
  Unit,
  Negation(Expr),
}
```

---

```rs
enum Expr {
  BinOp { lhs: Box<Expr>, rhs: Box<Expr> },
  Unit,
  Negation(Box<Expr>),
}
```

== Методы в перечислениях

---

`Enum` может реализовывать методы:
```rs
enum Option<T> {
  Some(T), None
}
impl<T> Option<T> {
  fn is_some() {
    match self {
      Option::Some(_) => true,
      _ => false
    }
  }
}
```

== Сопоставление с образцом

Rust уже знакомым образом позволяет "разбирать" структуры при присваивании:
```rs
let tuple = (13, 37);
let (x, _) = tuple;
let p = Point { x: 3.0, y: 4.0 };
let Point { x, y } = p;
println!("{}", x); // 13
```

Иногда необходимо, чтобы блок управления зависел от результата присваивания. Работает так же для `while`.
```rs
let opt = Some(42);
if let Some(i) = opt { println!("Some work!"); }
```

Для более сложных случаев есть `match` (аналогично другим языкам):
```rs
match age() {
  0 => println("So small!"),
  n @ 1..=12 => println!("I'm a chind of age {n}"),
  n @ 13..=19 => println!("I'm a teen of age {n}"),
  n => println!("Ded of age {n}"),
}

match r {
  Ok(v) => ...
  Err(_) => ...
}
```

== Полезные особенности `match`

- `match` является выражением
- можно сопоставлять с несколькими образцами в одной ветке:
```rs
match n {
  1 => ...,
  2 | 3 | 5 | 7 => ...
}
```
- можно делать дополнительные проверки (guards):
```rs
match p {
  (x, y) if x == y => ...
}
```
---
- можно сопоставлять подмножество полей структуры
```rs
match foo {
  Foo { x: (1, b), .. } => {
    ...
  }
}
```
---
- можно назначать имена для частей списков

```rs
let s = [1, 2, 3, 4];
let mut t = &s[..];
loop {
  match t {
    [head, tail @ ..] => {
      println!("{head}");
      t = &tail;
    }
    _ => break;
  }
}
```

== Заимствование в `match`

#codly(highlights: (
  (line: 4, fill: red, start: 0, tag: "❌"),
  (line: 7, fill: red, start: 0, tag: "❌"),
))
```rs
fn main() {
    let maybe_name = Some(String::from("Alice"));
    match maybe_name {
        Some(n) => println!("Hello, {n}"),
        _ => println!("Hello, world"),
    }
    println!("Hello again, {}", maybe_name.unwrap_or("world".into()));
}
```

`Partial move occurs...`

---

#codly(highlights: (
  (line: 4, fill: green, start: 13, end: 19),
))
```rs
fn main() {
    let maybe_name = Some(String::from("Alice"));
    match maybe_name {
        Some(ref n) => println!("Hello, {n}"),
        _ => println!("Hello, world"),
    }
    println!("Hello again, {}", maybe_name.unwrap_or("world".into()));
}
```
