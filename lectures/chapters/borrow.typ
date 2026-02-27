#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.6": *
#import "@preview/touying:0.6.0": *
#import themes.metropolis: *
#import "@preview/cetz:0.3.1"
#import "@preview/fletcher:0.5.3" as fletcher: node, edge
#import "@preview/ctheorems:1.1.3": *
#import "@preview/numbly:0.1.0": numbly

== Проблема висящих указателей

#codly(highlights: (
  (line: 2, start: 5, fill: blue),
  (line: 5, start: 23, fill: red)
))
```c
Vec *vec_new() {
    Vec vec;
    vec.data = NULL;
    vec.length = 0;
    vec.capacity = 0; return &vec;
}
int main() {
  Vec* v = vec_new();
  std::cout << v;
}
```

Мы бы хотели отслеживать "время жизни" переменных.

#pagebreak()

#codly(highlights: (
  (line: 6, start: 5, fill: blue),
  (line: 8, start: 3, fill: red)
))
```cpp
int main() {
  std::vector<int> v = std::vector<int>(2);
  v.push_back(42);
  int& x = v[0];
  for (int i = 0; i < 5; ++i) {
    v.push_back(i);
  }
  std::cout << x; // Undefined behaviour
}
```

Мы хотим запрещать чтение, когда изменение состояния объекта может привести к негативным последствиям.

== Гонка данных (data race)
```cpp
void inc(int& x) {
    for(int i = 0; i < 100000; ++i) {
        x++;
    }
}
int main() {
    int x = 0;
    std::thread t1(inc, &x), t2(inc, &x);
    t1.join(); t2.join();
    std::cout << x << std::endl;
}
```
Оба потока изменяют переменную, что создаёт проблемы.

== Проверка заимствований

Чтобы обеспечить безопасность при работе c ссылками на этапе компиляции в Rust используется механизм проверки заимствований (borrow checker).

#pagebreak()

Правило №1. Никакая ссылка не может "пережить" (outlive) объект, на который она ссылается. 


#codly(highlights: (
  (line: 5, fill: red, start: 0, tag: "❌"),
))
```rs
fn main() {
  let r: &i32;
  {
    let x = 5;
    r = &x; // Ошибка: borrowed value does not live enough
  }
  println!("{}", r); // Вопрос: что будет, если убрать println!?
}
```

#pagebreak()

```rs
fn main() {
    let stdin = io::stdin();
    let mut input = stdin.lock().lines();

    let args: Vec<&str> = {
        let line: String = input.next().unwrap().unwrap();
        line.split_whitespace().collect::<Vec<_>>()
    };
}
```

#pagebreak()

```rs
fn main() {
  let x = 1;
  let r: &i32;
  {
    let y = 2;
    r = f(&x, &y);
  }
  println(*r);
}

fn f(x: &i32, y: &i32) -> &i32 {
  if *x > *y { x } else { y }
}
```

#pagebreak()

```rs

fn main() {
    let x = 1;
    let r: &i32;
    {
        let y = 2;
        r = f(&x, &y);
    }
    println!("{}", *r);
}

fn f<'a: 'c, 'b: 'c, 'c>(x: &'a i32, y: &'b i32) -> &'c i32 {
    if *x > *y { x } else { y }
}

```

#pagebreak()

```rs
fn main() {
    let stdin = io::stdin();
    let mut input = stdin.lock().lines();
    let args: Vec<String> = {
        let line = input.next().unwrap().unwrap();
        line.split_whitespace().map(|s| s.to_string()).collect()
    };
}
```

== Больше примеров

- https://github.com/gohy907/git-trainer/blob/issue/src/ui.rs#L309

== Проверка заимствований

Правило №2. В любой момент к области памяти может быть:
- либо эксклюзивный доступ на запись (через исходную переменную или ссылку)
- либо совместный доступ на чтение

#codly(highlights: (
  (line: 3, fill: red, start: 0),
))
```rs
fn main() {
    let mut x = 42;
    let y = &mut x;
    let z = &x; // Ошибка: can't borrow as immutable because it is also borrowed as mutable
    assert_eq!(*y, 42); // Что будет, если убрать здесь assert_eq?
}
```

#pagebreak()

```rs
fn compute(input: &u32, output: &mut u32) {
    if *input > 10 {
        *output = 1;
    }
    if *input > 5 {
        *output *= 2;
    }
    // remember that `output` will be `2` if `input > 10`
}
```

#pagebreak()

```rs
fn compute(input: &u32, output: &mut u32) {
    let cached_input = *input; // keep `*input` in a register
    if cached_input > 10 {
        *output = 2;
    } else if cached_input > 5 {
        *output *= 2;
    }
```

#pagebreak()

Правило №3. Объект, на который существует хотя бы одна ссылка фактически "заморожен". Его нельзя модифицировать ни откуда за исключением самой ссылки.

#slide(composer: (1fr, 1fr))[
#codly(highlights: (
  (line: 2, start: 0, fill: red, tag: "❌"),
  (line: 3, start: 0, fill: red, tag: "❌")
))
```rs
let mut x = 3;
let y = &mut x;
let y = &x;
x = 4;
println!("{}", y);
```
][
#codly(highlights: (
  (line: 2, start: 0, fill: green, tag:"✅"),
  (line: 4, start: 0, fill: red, tag: "❌"),
))
```rs
let mut x = 3;
let y = &mut x;
*y = 4;
x = 4;
println!("{}", y);
```
]

#pagebreak()

А что будет в этом случае?
```rs
let mut x = 3;
let y = &mut x;
*y = 4;
x = 5;
println!("{}", x);
```

== "Заморозка" владельца

```rs
struct Wrapper {
  value: Box<i32>,
}

fn main() {
  let mut w = Wrapper {
    value: Box::new(92),
  };
  let r: &i32 = &*w.value;

  w.value = Box::new(93);
  println!("{}", *r);
}
```

#pagebreak()

Правило №4: Пока существует активная ссылка на поле структуры, нельзя совершать действий над структурой, которые могут сделать эту ссылку невалидной.