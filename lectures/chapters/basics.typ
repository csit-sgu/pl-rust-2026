#import "../globals.typ": *

= Основы языка

== Hello, World!

```rust
#![no_main]

#[link_section = ".text"]
#[no_mangle]
pub static main: [u32; 9] = [
    3237986353, 3355442993,
    120950088, 822083584,
    252621522, 1699267333,
    745499756, 1919899424,
    169960556,
];
```
```sh rustc hello.rs && ./hello ```

---

```rs
fn main() {
    let message = "Hello, world!";
    println!("{}", message);
}
```

```sh rustc hello.rs && ./hello ```

---

Вариант запуска с `cargo`:
```sh
cargo new proj
cd proj
# edit src/main.rs
cargo run
```

== Целые числа

#align(center)[
  #table(
    columns: (auto, auto, auto, auto, auto, auto, auto),
    inset: 10pt,
    align: center,
    table.header(
      [*кол-во бит*], [*8*], [*16*], [*32*], [*64*], [*128*], [*32/64*]
    ),
    "Знаковые",
    `i8`,
    `i16`,
    `i32`,
    `i64`,
    `i128`,
    `isize`,
    "Беззнаковые",
    `u8`,
    `u16`,
    `u32`,
    `u64`,
    `u128`,
    `usize`,
  )
]

== Примеры

#codly(
  highlights: (
    (line: 8, fill: red),
  ),
)
```rs
let x = 32;
let y: i64 = 92_000_000;
let y = 92_000_000i64;
let z = 0xffff_ffff + 0o777 + 0b1;
let byte = b'a';
assert_eq(byte, 65);

let x = (let y = 3); // x = y = 3 in C++
```

== Работа с выражениями

Интересные особенности:
- От выражений можно вызывать методы (соответствующие типу)
```rs
(-92i32).abs()
```
- Нет оператора `++`
- Нет неявного преобразования над типами, нужно использовать ключевое слово `as` (только для примитивов).
- Переполнение целочисленного типа -- ошибка времени исполнения. Для контроля за поведением переполнения используется `wrapping_add`, `saturating_add` и `overflowing_add`.

== Вывод типов

Rust не требует явного указания типов. Если тип не указан, то он выводится из контекста.

```rs
let x = 2 + 4i32; // x - i32
```

Иногда тип не может быть выведен из контекста автоматически, тогда нужно указать его явно:
```rs
let guess: u32 = "42".parse().expect("Not a number!");
```

== Массивы

Статический массив объявляется как `[i8; 3]`, то есть размер массива -- часть типа.

Можно обращаться к части массива с помощью срезов:
```rs
let arr: [i32; 5] = [1, 2, 3, 4, 5];

let slice: &[i32] = &arr[1..3];
println!("{:?}", slice);
```

У срезов особое значение в контексте системы типов Rust.

== Динамические массивы

Динамические массивы реализуются структурой `Vec`:
```rs
let mut a = Vec::new()
a.push(1)
a.push(1)
a.push(1)
let a = vec![1, 1, 1];
let a = vec![1, 3];
```

Это аналог `std::vector` из C++.

== Блоки

Важно, что блок в Rust -- является выражением:
```rs
let x = {
  let y = 4;
  y
}
println!("{}", x);
```

---

```rs
let omelet = {
  let eggs = get_eggs(&mut refrigerator, 3);
  let bacon = open_bacon(&mut refrigerator);
  fry(egs, bacon)
};
```

Тип по умолчанию -- `()`, он же unit.

== Циклы

Кроме привычных `for` и `while` в Rust есть бесконечный цикл -- `loop`.

`while (true)` и `loop` -- различные конструкции с точки зрения языка.

#slide(composer: (1fr, 1fr))[
#codly(highlights: (
  (line: 8, fill: red, start: 0, tag: "❌"),
))
```rs
let uninit;
while true {
  if cond {
    uninit = 92;
    break;
  }
}
println!("{}", uninit)
```
][
```rs
let init;
loop {
  if cond {
    init = 92;
    break;
  }
}
println!("{}", init)
```
]

---

Можно делать `break` на метки

```rs
'outer: while cond1 {
  while cond2 {
    break 'outer;
  }
}
```

== Управляющие конструкции

Многие управляющие конструкции в Rust -- тоже выражения:
```rs
let x = if true { 4 } else { 2 };
let from_loop = loop {
  break 3;
}
```

Актуально для `if`, `match`, `{}`, `loop` в сочетании с `break`.

---

== !

Иногда называется "ненаселенный" тип (англ. never).

```rs
let x: ! = loop {}
```
Может выступать в роли любого другого типа
```rs
let x: u32 = loop {}
```

---

== Аварийное завершение программы

Исключительная ошибка
```rs
panic!("something went wrong")
```
Функционал ещё не реализован
```rs
unimplemented!()
```
Код недостижим
```rs
unreachable!()
```

== Владение
Одной из ключевых концепций в Rust является модель владения.
- Каждое значение в Rust имеет своего владельца (переменную, поле, аргумент функции)
- В один момент может быть только один владелец
- Когда владелец выходит из области видимости, то захваченный ресурс освобождается

#codly(display-name: false)
#slide(composer: (1fr, 1fr))[
```rs
let x = 3;
let y = x; // Копирование
```
][
```cpp
int x = 3;
int y = x; // Копирование
```
]

---

```rs
#[derive(Clone, Copy)]
struct Point { x: f64, y: f64 }
```

Агрегаты из `Copy` типов тоже могут быть `Copy`.

---

#slide(composer: (1fr, 1fr))[

#codly(highlights: (
  (line: 3, fill: red, start: 0, tag: "❌"),
))
```rs
let x = String::from("s");
let y = x;
println!("{}", x);
```
][
#codly(highlights: (
  (line: 3, fill: green, start: 0, tag: "✅"),
))
```cpp
auto x = std::string("s");
auto y = x; // Копирование
std::cout << x;
```
]
#codly(display-name: true)

---

== Жизнь без ссылок

#codly(highlights: (
  (line: 8, fill: red, start: 0, tag: "❌"),
))
```rs
fn print_vec(xs: Vec<i32>) {
  for x in xs { println!("{}", x); }
}

fn main() {
  let xs = vec![1, 2, 3];
  print_vec(xs);
  print_vec(xs); // Ошибка: value used after move
}
```

== Ссылки

- не могут быть `NULL`
- гарантируют, что объект жив

```rs
let r: &mut i32 = &mut 92; // Любопытным: каким образом мы берём ссылку на константу?
*r += 1;
```

Берём ссылку на объект -- значит заимствуем его (borrow).

Выделение памяти на куче выполняется с помощью `Box`.
```rs
let x = Box::new(42);
```

== Срезы массивов (slices)

Rust позволяет хранить фрагмент массива в виде среза (slice):
```rs
let arr = [10, 20, 30, 40, 50];
let slice = &arr[0..4];
assert_eq!(mem::size_of_val(&arr)), 20);
assert_eq!(mem::size_of_val(&slice)), 16);
```

== Строки и срезы строк

В Rust "владеющие" строки представляются типом `String`:
```rs
let alice = String::from("Alice");
let almost_slice = &alice[1..];
let s = String::from('s');
let slices = [&s[..], almost_slice, &s[..]].concat();
println!("{}", slices);
```
Строки — тоже массивы, поэтому от них можно брать срез `&str`.

== Ссылки на ссылки

```rs
#[derive(Debug, Clone)]
struct T {
    i: i32,
}

fn f<'a>(rf: &mut &'a T, another: &'a T) {
    *rf = another;
}

fn main() {
    let a = T { i: 0 };
    let b = T { i: 1 };

    let mut a_ref = &a;

    f(&mut a_ref, &b);

    println!("{:?}", a_ref);
}
```
