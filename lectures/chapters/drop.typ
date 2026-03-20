#import "../globals.typ": *

= Освобождение ресурсов (Drop)

== Ошибки при освобождении памяти
```c
// Double free
void vec_free(Vec *vec) {
    free(vec);
    free(vec->data);
}
```

Мы хотим как минимум возложить ответственность за освобождение ресурсов на сущности, которые их используют.

---
#codly(highlights: (
  (line: 8, start: 3, fill: red),
))
```cpp
struct String {
  const char *p;
  String() { p = new char[10]; }
  ~String() { delete[] p; }
};
int main() {
  auto p = String();
  auto v = p;
}
```
Мы хотим, чтобы язык по возможности не делал неявных копирований

---

Решение:
- В Rust запрещено неявное копирование для нетривиальных структур, для этого она должна иметь метод `clone()`, который реализует глубокое копирование.
- На этапе компиляции Rust на основе информации о времени жизни каждого объекта знает, в какой момент его необходимо разрушить

Освобождение памяти выполняет функция  `drop`, реализованная для конкретного типа.

== Drop в Rust

```rs
struct Guard {
    file: std::fs::File,
    counter: usize,
}
impl Drop for Guard {
    fn drop(&mut self) {
        if let Err(e) = self.file.flush() {
            eprintln!("flush failed: {}", e);
        }
        println!("Guard {} closed", self.counter);
    }
}
```

---

```rs
fn main() {
    let guard = Guard {
        file: std::fs::File::create("log.txt").unwrap(),
        counter: 0,
    };
}
```
После выхода из области видимости компилятор вызывает так называемый drop glue.

== Drop glue

```rs
drop_in_place<Foo>
  ├── вызвать Drop::drop(&mut foo)   ← пользовательский код (если есть impl Drop for Foo)
  └── рекурсивно: drop_in_place для каждого поля
        drop_in_place<String>
          └── drop_in_place<Vec<u8>>
                ├── Vec::drop()       ← impl Drop освобождает данные
                └── drop_in_place<RawVec<u8>>
                      └── RawVec::drop() ← free(ptr)
```

---

"Домашка": Как определить функцию `drop` в Rust?

#codly(highlights: (
  (line: 7, fill: red, start: 0, tag: "❌"),
))
```rs
fn drop[<?>](?) -> ? {
  ?
}

let pizza = String::from("with pineapple");
drop(pizza);
println!("My pizza :( {}", s); // Ошибка
```

== Порядок вызова `drop`

```rs
struct C {
    _a: A,
    _b: B,
}
fn main() {
    let _s = C { _a: A, _b: B };
}
// C
// A
// B
```

== Manually Drop

Иногда может возникнуть необходимость запретить вызывать `Drop`, для этого можно воспользоваться контейнером `ManuallyDrop` из стандартной библиотеки.

---

```rs
struct Foo(String);
impl Drop for Foo { fn drop(&mut self) { println!("Foo dropped"); } }

fn main() {
    // В цикле копятся утечки
    loop {
      let mut foo = ManuallyDrop::new(Foo(String::from("Hello")));
      foo.0.make_ascii_uppercase();
    }
}
```
Еще есть функция `std::mem::forget`, которая принимает владение и забывает про объект (как думаете, что она делает внутри?).

Но как же *memory safety*?!

== Drop flags

```rs
let condition = get_condition_from_user(); // неизвестно в compile time
let x;

if condition {
    x = Box::new(42); // x инициализирована только в этой ветке
    println!("{}", x);
}
```

== Частичное перемещение (Partial Move)

```rs
struct Point {
    x: String,
    y: String,
}
fn main() {
    let point = Point {
        x: "left".to_string(),
        y: "right".to_string()
    };
    let x = point.x;
    println!("x = {}", x);
    println!("y = {}", point.y);
}
```
