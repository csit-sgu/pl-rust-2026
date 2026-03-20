#import "../globals.typ": *

= Полиморфизм

== Общие моменты

В Rust нет перегрузки функций

#codly(highlights: (
  (line: 2, fill: red, start: 0),
))
```rs
fn f(i: i32) {}
fn f(i: f64) {} // Diagnostics: the name `f` is defined multiple times
```

---

== Трейты

Мы уже столкнулись с понятием ограничения на тип:
- `T: Clone` — `T` должен реализовывать трейт `Clone`
- `T: Copy` — `T` должен реализовывать трейт `Copy`
- `T: Debug` — `T` должен реализовывать трейт `Debug`

Понятие трейта можно трактовать по разному:
- как характеристика типа (что он умеет/что из себя представляет?) #pause
- как интерфейс (какие методы доступны для этого типа?) #pause
- как контракт между разработчиком и пользователем (как с этим типом можно работать?)

---

```rs
pub trait Clone: Sized {
    // Required method
    fn clone(&self) -> Self;

    // Provided method
    fn clone_from(&mut self, source: &Self) { ... }
}
```

- `clone_from` — метод с реализацией по умолчанию. #pause
- `Sized` — _маркерный трейт_, который гарантирует, что размер типа будет известен на этапе компиляции.

---

== Ограничение на абстрактный тип

```rs
fn write_hello<W: Write>(out: &mut W) -> std::io::Result<()> {
    out.write_all(b"hello world\n")?;
    out.flush()
}
```



== Супертрейты

```rs
trait Person {
    fn name(&self) -> String;
}
trait Student: Person {
    fn university(&self) -> String;
}
trait Programmer {
    fn fav_language(&self) -> String;
}
trait CompSciStudent: Programmer + Student {
    fn git_username(&self) -> String;
}

```

== Немного школьной алгебры

```rs
fn top_ten<T: Debug + Hash + Eq>(values: &Vec<T>) { ... }
```

#image("../pics/trait_bounds.png")

== Полиморфизм по возвращаемому типу

```rs
trait Default {
  fn default() -> Self;
}
struct Circle {
  center: Point,
  radius: f64,
}
impl Default for Circle {
  fn default() -> Circle {
    Circle {
      center: Point::default(),
      radius: 1.0
    }
  }
}
```

== Реализация trait'а для сторонних типов

Можно реализовывать поведение своих trait-ов для "чужих" типов.

```rs
impl Say for i32 {
  fn say(&self) {
    println!("int-int!")
  }
}

fn main() {
  42.say()
}
```
#pause

Однако это возможно только если трейт объявлен в текущем крейте _(orphan rule)_.

== Fully qualified syntax

```rs
struct Form {
    username: String,
    age: u8,
}
trait UsernameWidget {
    fn get(&self) -> String;
}
trait AgeWidget {
    fn get(&self) -> u8;
}
```



---


```rs
let form = Form {
    username: "rustacean".to_owned(),
    age: 28,
};
println!("{}", form.get());
```

---

```rs
error[E0034]: multiple applicable items in scope
  --> src/main.rs:35:25
   |
35 |     println!("{}", form.get());
   |                         ^^^ multiple `get` found
   |
note: candidate #1 is defined in an impl of the trait `UsernameWidget`
for the type `Form`
  --> src/main.rs:15:5
   |
15 |     fn get(&self) -> String {
   |     ^^^^^^^^^^^^^^^^^^^^^^^
note: candidate #2 is defined in an impl of the trait `AgeWidget`
```

---

```rs
let form = Form {
    username: "dead rustacean".to_owned(),
    age: 28,
};
// println!("{}", form.get());
let username = UsernameWidget::get(&form);  // From trait
assert_eq!("dead rustacean".to_owned(), username);
let age = <Form as AgeWidget>::get(&form);  // FQS
assert_eq!(28, age);
```

== Специализация


```rs
pub enum Option<T> {
    // ...
}
impl<T> Option<T> { /* ... */ }
impl<T: Default> Option<T> { /* ... */ }
impl Option<i32> { /* ... */ }
```


== Особые типы структур

Ещё раз вспомним типы структур в Rust.

Чаще всего типы в Rust известны на этапе компиляции и имеют положительный размер. Но иногда это не так.

На текущий момент в Rust есть следующие типы:
- "Обычные" типы (`i32`, `String`, `bool`, `struct` из прочих "обычных" типов")
- Типы переменного размера `str`, `[T]`
- Типы нулевого размера `struct Tag`
- Пустые типы `enum Void {}`

В типы переменного размера кроме `&str` и `&[T]` входит `dyn Trait` (трейт-объект).

"Обычные" типы реализуют маркерный trait `Sized`. Среди них — ссылки на DST.


== Динамическая диспетчеризация

В Rust динамическая диспетчеризация реализуется с помощью trait-объектов.

```rs
impl Hello for str {
  fn hello(&self) {
    println!("Hello, {}!", self);
  }
}
```
```rs
let x = "Rust";
let y: &dyn Hello = &x;

y.hello(); // Hello, Rust!
```

Обратите внимание, что трейты можно реализовывать для стандартных типов

---

#image("../pics/dyn_object.png")

---

Задача: функция должна принимать срез элементов, каждый из которых реализует trait `Hello` и вызывать соответствующий типу метод `hello`.

Попытка №1
```rs
fn func<T: Hello>(arr: &[Hello]) {
    for i in arr {
        i.hello();
    }
}
```

#pause *Проблема:* `Hello` — трейт, а не тип.

---

Попытка №2
```rs
fn func<T: Hello>(arr: &[T]) {
    for i in arr {
        i.hello();
    }
}
```

#pause *Проблема:* `T` произвольный тип, удовлетворяющий ограничениям, но всего один.

---

Попытка №3
```rs
fn func<T: Hello>(arr: &[dyn Hello]) {
    for i in arr {
        i.hello();
    }
}
```

*Проблема:* мы не знаем точного размера `dyn Hello`.

---

Попытка №4
```rs
fn func(arr: &[&dyn Hello]) {
    for i in arr {
        i.hello();
    }
}
```

#pause Это сработает и будет делать то, что ожидается.

== Реальный пример

```rs
trait Notification { fn send(&self, message: &str); }
struct EmailService { email: String }
impl Notification for EmailService {
    fn send(&self, message: &str) {
        println!("Отправка email на {}: {}", self.email, message);
    }
}
struct SmsService { phone: String }
impl Notification for SmsService {
    fn send(&self, message: &str) {
        println!("Отправка SMS на {}: {}", self.phone, message);
    }
}
```

---

```rs
fn main() {
    let mut services: Vec<Box<dyn Notification>> = Vec::new();
    services.push(Box::new(EmailService {
        email: String::from("user@example.com"),
    }));
    services.push(Box::new(SmsService {
        phone: String::from("+7 (800) 555-35-35"),
    }));
    for service in services {
        service.send("Ваш заказ готов!")
    }
}
```

---

```rs
fn main() {
    let mut services = Vec::new();
    services.push(Box::new(EmailService {
        email: String::from("user@example.com"),
    }));
    services.push(Box::new(SmsService {
        phone: String::from("+7 (800) 555-35-35"),
    }));
    for service in services {
        service.send("Ваш заказ готов!")
    }
}
```
А если так?

== Ограничение trait-объектов несколькими трейтами

```rs
let x = "hello world";
// World is some regular user trait
// It won't compile!
// let r: &dyn Hello + World = &x;

trait HelloWorld: Hello + World {}
impl HelloWorld for str {
    // ...
}

// Will compile just fine
let r: &dyn HelloWorld = &x;
```

---

Исключение: авто-трейты (`Send`/`Sync`)


```rs
trait X {
    // ...
}

fn test(x: Box<dyn X + Send>) {
    // ..
}
```

== Ассоциированные типы и константы

Для трейтов кроме функций, ограничивающих или дополняющих тип, могут быть объявлены константы и псевдонимы для типов.

Пример объявления ассоциированного типа _(associated type)_:
```rs
pub trait Iterator {
    type Item;
    fn next(&mut self) -> Option<Self::Item>;
}
```

*Вопрос:* почему не такое определение:
```rs
pub trait Iterator<T> {
    fn next(&mut self) -> Option<T>;
}
```

== Динамическая совместимость (dyn compatibility)

Попробуем объявить такой метод:
```rs
fn test(x: Box<dyn Clone + Send>) {
    // ...
}
```

---

```rs
error[E0038]: the trait `Clone` cannot be made into an object
--> src/main.rs:1:16
|
1 | fn test(x: Box<dyn Clone + Send>) {
|                ^^^^^^^^^^^^^^^^ `Clone` cannot be made
|                                 into an object
|
= note: the trait cannot be made into an object because it
requires `Self: Sized`
= note: for a trait to be "object safe" it needs to allow
building a vtable to allow the call to be resolvable dynamically
```

---

Посмотрим на объявление трейта
```rs
pub trait Clone: Sized {
    // Required method
    fn clone(&self) -> Self;

    // Provided method
    fn clone_from(&mut self, source: &Self) { ... }
}
```
*Вопрос:* Что могло пойти не так?

---

Другие примеры
```rs
trait NonDispatchable {
    // Non-methods cannot be dispatched.
    fn foo() where Self: Sized {}
    // Self type isn't known until runtime.
    fn returns(&self) -> Self where Self: Sized;
    // `other` may be a different concrete type of the receiver.
    fn param(&self, other: Self) where Self: Sized {}
    // Generics are not compatible with vtables.
    fn typed<T>(&self, x: T) where Self: Sized {}
}
```

---

Итак, какие трейты не являются динамически совместимыми, если:
- Требуется ограничение `Sized` на `Self` (`trait Foo: Sized`)
- Методы возвращают или принимают `Self` в качестве обычного параметра
- Методы содержат в качестве аргумента обобщенный тип
- Трейты содержат ассоциированный тип с обобщенным типом
- Трейт содержит ассоциированные константы

== Методы для трейт-объектов

Мы можем реализовать методы для trait-объектов:
```rs
impl dyn Example {
    fn is_dyn(&self) -> bool {
        true
    }
}
struct Test {}
impl Example for Test {}

let x = Test {};
let y: Box<dyn Example> = Box::new(Test {});
// Won't compile
// x.is_dyn()
y.is_dyn();
```

== Сравнение trait-объектов и обобщенных типов (generics)

Обобщенные типы:
- разрешаются на этапе компиляции
- могут приводить к увеличению размера бинарного файла
- обычно быстрее, потому что позволяют применить оптимизации времени компиляции

Trait-объекты:
- разрешаются на этапе исполнения
- дают меньший размер бинарного файла (одна реализация)
- обычно медленнее, в том числе потому, что есть накладные расходы на переход в vtable

== Стандартные трейты
 
- `Default` — предоставляет значение по умолчанию
- `Clone` — позволяет создавать копии объектов
- `Copy` — позволяет создавать копии объектов без вызова `clone`
- `Drop` — позволяет выполнять код при уничтожении объекта
- `Sized` — гарантирует, что размер типа известен на этапе компиляции
- `Debug` — позволяет получить информацию об объекте
- `Display` — позволяет получить информацию об объекте в удобочитаемом виде
- `PartialEq` и `Eq` — позволяют сравнивать объекты на равенство
- `PartialOrd` и `Ord` — позволяют сравнивать объекты на порядок