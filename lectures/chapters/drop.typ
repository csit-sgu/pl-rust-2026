#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.6": *
#import "@preview/touying:0.6.0": *
#import themes.metropolis: *
#import "@preview/cetz:0.3.1"
#import "@preview/fletcher:0.5.3" as fletcher: node, edge
#import "@preview/ctheorems:1.1.3": *
#import "@preview/numbly:0.1.0": numbly

== Ошибки при освобождении памяти
```c
// Double free
void vec_free(Vec *vec) {
    free(vec);
    free(vec->data);
}
```

Мы хотим как минимум возложить ответственность за освобождение ресурсов на сущности, которые их используют.

#pagebreak()
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

#pagebreak()

Решение:
- В Rust запрещено неявное копирование для нетривиальных структур, для этого она должна иметь метод `clone()`, который реализует глубокое копирование.
- На этапе компиляции Rust на основе информации о времени жизни каждого объекта знает, в какой момент его необходимо разрушить

Освобождение памяти выполняет функция  `drop`.

#pagebreak()

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