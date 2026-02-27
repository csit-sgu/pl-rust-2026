#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.6": *
#import "@preview/touying:0.6.0": *
#import themes.metropolis: *
#import "@preview/cetz:0.3.1"
#import "@preview/fletcher:0.5.3" as fletcher: node, edge
#import "@preview/ctheorems:1.1.3": *
#import "@preview/numbly:0.1.0": numbly

#let input-codly(file, from, to, lang) = {
  let input = read(file)
  let splitted = input.split("\n")
  let slice = splitted.slice(from - 1, to)
  let result = slice.join("\n")
  raw(lang: lang, result, block: true)
}

== Про Rust

- 1.0 в 2015 году
- нет сборщика мусора, но есть автоматическая работа с памятью
- минимальный _runtime_ (среда окружения)
- конкурент C++
- фокус на memory safety
- испытал влияние SML/OCaml, Haskell, C++
- поддерживается AWS, Huawei, Google, Microsoft и Mozilla в рамках Rust Foundation
- компилирует сам себя
- поддерживается при разработке ядра Linux

= Почему Rust?

= Причина 1: Работа с памятью

== Подходы к работе с памятью

До Rust мир условно делился на две части:
1. Ручное управление памятью (C/C++/...)
2. Автоматический сборщик мусора (Java/C\#/Golang/...)

== Чуть-чуть больше про GC

#figure(image("../pics/spikes.png"))

Ссылка на оригинальную статью: #link("https://discord.com/blog/why-discord-is-switching-from-go-to-rust")

== Пишем аналог `std::vector` на С

Давайте попробуем написать свой ```cpp std::vector<int>``` на C.


Объявляем структуру

#input-codly("../snippet/vector.c", 5, 9, "c")

#pagebreak()

Создание вектора

#input-codly("../snippet/vector.c", 11, 17, "c")

#pagebreak()

Создание вектора
#codly(highlights: (
  (line: 6, fill: red, start: 0),
))
#input-codly("../snippet/vector.c", 11, 17, "c")

#pagebreak()
Вставка элемента
#input-codly("../snippet/vector.c", 19, 31, "c")



#pagebreak()

#codly(highlights: (
  (line: 1, fill: red, start: 15, end: 22),
  (line: 4, fill: green, start: 0,),
  (line: 14, fill: green, start: 0),
))
```c
void vec_push(Vec *vec, int value) {
  if (vec->length == vec->capacity) {
    int new_capacity = vec->capacity * 2;
    int *new_data = (int *) malloc(new_capacity * sizeof(int));
    assert(new_data != NULL);
    for (int i = 0; i < vec->length; i++) {
      new_data[i] = vec->data[i];
    }
    vec->data = new_data;
    vec->capacity = new_capacity;
  }
  vec->data[vec->length] = value;
  vec->length++;
  delete[] vec->data;
```

#pagebreak()

Освобождаем память
#input-codly("../snippet/vector.c", 34, 37, "c")

#pagebreak()

#codly(highlights: (
  (line: 2, fill: green, start: 0),
  (line: 3, fill: green, start: 0),
))
```c
void vec_free(Vec *vec) {
  free(vec->data);
  free(vec);
}
```

#pagebreak()

Используем полученную структуру
#input-codly("../snippet/vector.c", 39, 48, "c")

#pagebreak()

#codly(highlights: (
  (line: 4, fill: red, start: 0),
  (line: 8, fill: red, start: 0),
  (line: 9, fill: red, start: 0),
))
Используем полученную структуру
#input-codly("../snippet/vector.c", 39, 48, "c")

== Требования к разработчику

1. Явно указывать размер структур (пусть и с помощью средств языка)
2. Нужно помнить про состояние ссылок и их время жизни
3. Необходимо вручную управлять ресурсами (выделение/освобождение)

==  Потенциальные проблемы

1. Ошибки при выделении/освобождении памяти
  - некорректная инициализация
  - утечка при обработке исключительных ситуаций
2. "Висящие ссылки" (dangling pointers)
  - на переменные на стеке
  - при скрытых реаллокациях
3. Повторное освобождение памяти (double free)
4. Утечки памяти

== С++ --- решение?

1. *"Висячие" ссылки*: 

Эта проблема остается на совести разработчиков, иногда вмешивается компилятор, выполняя w

2. *Аллокация*:

В С++ предлагаются операторы `new` и `delete`, которые больше не требуют явного выделения памяти в байтах.

3. *Повторное освобождение и утечки памяти*:

RAII идиома и умные указатели решают большинство проблем. Тут остановимся подробнее.


== RAII 

Resource Acquision Is Initialization (RAII) -- связывание операций выделения/освобождения памяти с созданием/уничтожением объектов, владеющих этой памятью.

#input-codly("../snippet/mystring.cpp", 2, 11, "cpp")

#pagebreak()

Применение RAII само по себе всё ещё не решает все проблемы с памятью. Что, например, будет в этом случае?

```cpp
  int main() {
    MyString x();
    MyString y = x;
  }
```

== "Умные" указатели

Рассмотрим ещё один пример, когда мы вроде бы пользуемся идиомой правильно
#input-codly("../snippet/smart_pointers.cpp", 16, 25, "cpp")

#pagebreak()

#input-codly("../snippet/smart_pointers.cpp", 27, 36, "cpp")
```
Constructor is called
Exception is caught
Constructor is called
Exception is caught
```

#pagebreak()

#input-codly("../snippet/smart_pointers_p2.cpp", 16, 25, "cpp")

#pagebreak()

#input-codly("../snippet/smart_pointers.cpp", 27, 36, "cpp")
```
Constructor is called
Destructor is called
Exception is caught
```


== std::unique_ptr

Этот умный указатель говорит, что сам объект имеет единоличное владение указателем. 

```cpp
int main() {
  auto x = std::make_unique(42); // 
  // auto y = x; Ошибка, конструктор явно удалён
  auto y = std::move(x);
  std::cout << y; // OK
  std::cout << x; // Undefined behaviour
}
```

== std::shared_ptr

Этот умный указатель разделяет владение указателем между всеми созданными указателями

```cpp
void f(std::shared_ptr<int> ptr)...;
int main() {
  auto x = std::make_shared(42); // "counter": 1
  f(x) // "counter": 2 внутри функции, 1 после завершения;

  // Удаление в конце блока
}
```

== Чем можно сломать умные указатели?

1. ```cpp
Test test;

std::unique_ptr<Text> ptr(&test);
```
2. ```cpp
std::unique_ptr<Test> ptr(new Test());
std::unique_ptr<Test> otherPtr(ptr.get());
```

== Реалии C++

Считается "правилом хорошего тона" не использовать сырые указатели при написании кода в С++. Если необходимо динамическое выделение -- предлагается использование умных указателей.

Источники:
- #link("https://youtu.be/ogj3JI57BLM?t=1181","Илья Мещерин, МФТИ. Курс по С++")
- #link("https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines", "C++ Core Guidelines")
- Effective Modern C++, Scott Mayers

== C++ vs Rust в работе с памятью

#slide(composer: (1fr, 1fr))[
  *C++*
  - по умолчанию копирует
  - компилятор не отслеживает работу с памятью
  - легче скомпилировать
  - легче ошибиться
][
  *Rust*
  - по умолчанию "перемещает"
  - компилятор пристально следит за памятью
  - сложнее скомпилировать
  - сложнее ошибиться
]

= Причина 2: Абстракции


== Zero-cost abstractions

Многие языки могут быть выразительны, но нередко за эту выразительность приходится платить.

Rust реализован таким образом, что высокоуровневые абстракции в этом языке имеют "нулевую стоимость". Иными словами, их применение не должно влиять на объем используемой памяти и скорость исполнения программы.

#pagebreak()

Кортеж в Rust из двух `i32` занимает 8 байт:
```rs
let t = (92, );
println!("{:?}", &t as *const (i32, )); // 0x7ffc6b2f6aa4
println!("{:?}", &t.0 as *const i32); // 0x7ffc6b2f6aa4
```

```python 
t = (92, )
print(id(t)) # 139736506707248
print(id(t[0])) # 139736504680928
```

Иными словами, объединение кортежей -- zero-cost.

#pagebreak()

== Zero-cost abstractions

Вычисляем среднее (Java)
```java
private static double average(int[] data) {
  int sum = 0;
  for (int i = 0; i < data.length; ++i) {
    sum += data[i];
  }
  return sum * 1.0d / data.length;
}
```


```sh
$ java MainJ
30ms
```
#pagebreak()
То же решение на Rust 

```rust
fn average(xs: &[i32]) -> f64 {
  let mut sum: i32 = 0;
  for i in 0..xs.len() {
    sum += xs[i];
  }
  sum as f64 / xs.len() as f64
}
```


```sh
$ ./target/release/avg
17ms
```

#pagebreak()
Scala с абстракциями

```scala
def average(xs: Array[int]): Double {
  x.reduce(_ + _) * 1.0 / x.size
}
```

```sh
scala MainS
518 ms
```

#pagebreak()
Rust с абстракциями

```rust
fn average(xs: &[i32]) -> f64 {
  xs.iter().fold(0, |x, y| x + y) as f64 / xs.len() as f64
}
```

```sh
$ ./target/release/avg
18 ms
```

#pagebreak()
Вывод

- Rust (без абстракций) и Java — никакой разницы.
- Rust (с абстракциями) и Scala (с абстракциями) — существенно быстрее
- Rust (без абстракций) vs Rust (с абстракциями) — одинаково с точностью до погрешности эксперимента

= Причина 3: Опыт разработчика

== Toolchain

Rust -- один из самых удобных языков *для умеющего писать на нём* разработчика, поскольку:
- имеет собственную систему сборки `cargo`
- имеет собственный анализатор кода `rust-analyzer`
- имеет собственный инструмент контроля инструментов разработчика `rustup`
- имеет собственный форматировщик `rustfmt`
- исходный код стандартной библиотеки читаем (в отличие от С++)
- генератор документации с помощью `cargo doc`

Принцип: один хороший инструмент, а не много плохих.

== Ошибки

```rs
5 |     let scores = inputs().iter().map(|(a, b)| {
  |                  ^^^^^^^^ creates a temporary which is freed while still in use
6 |         a + b
7 |     });
  |       - temporary value is freed at the end of this statement
8 |     println!("{}", scores.sum::<i32>());
  |                    ------ borrow later used here
  help: consider using a `let` binding to create a longer lived value
  |
5 ~     let binding = inputs();
6 ~     let scores = binding.iter().map(|(a, b)| {
  |
```

= Введение в Rust

#pagebreak()

== Кривая обучения

#figure(image("../pics/learning_curve.svg"))