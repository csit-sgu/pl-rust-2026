#import "../globals.typ": *

= Стандартная библиотека Rust

== `Option`

Иногда бывает, что функция может не возвращать значение.

В Rust для таких случаев есть специальный контейнер `Option`
```rs
enum Option<T> {
  Some(T),
  None,
}
```

== `unwrap`/`expect`

#codly(highlights: (
  (line: 6, fill: red),
))
Иногда мы можем знать больше, чем компилятор и точно знать, что значение внутри контейнера есть. Тогда нам может пригодиться `unwrap`
```rs
    let a = Some(41);
    let b = a.unwrap();
    let c = Some((String::from("Blink"), 182));
    let d = c.unwrap();
    println!("d: {:?}", d);
    println!("c: {:?}", c);
    println!("b: {:?}", b);
    println!("a: {:?}", a);
```

Метод `expect` работает аналогично, но позволяет вывести сообщение об ошибке и обычно предпочтительнее `unwrap`.

В общем случае не рекомендуется использовать `unwrap`, его стоит по возможности избегать.


== `Option API`

```rs
fn as_ref(&self) -> Option<&T>; // &self is &Option<T>
```
```rs
let new_opt: Option<Vec<i32>> = Some(Vec::<i32>::new());
let value: Vec<i32> = new_opt.unwrap();
assert_eq!(new_opt.unwrap(), Vec::<i32>::new());
let x = new_opt.unwrap(); // error[E0382]: use of moved value: `new_opt`
```

---

Решение:
```rs
let new_opt: Option<Vec<i32>> = Some(Vec::<i32>::new());
let r: &Vec<i32> = new_opt.as_ref().unwrap();
assert_eq!(r, &Vec::<i32>::new());
let x = new_opt.unwrap(); // We used reference!
```

---

"Отображение" `Option`.

```rs
let maybe_some_string = Some(String::from("Hello, World!"));
// `Option::map` takes self *by value*,
// consuming `maybe_some_string`
let maybe_some_len = maybe_some_string.map(|s| s.len());
assert_eq!(maybe_some_len, Some(13));
```

---

Манипуляции с значением

```rs
fn take(&mut self) -> Option<T>;
fn replace(&mut self, value: T) -> Option<T>;
fn insert(&mut self, value: T) -> &mut T;
fn as_ref(&self) -> Option<&T>;
fn as_mut(&mut self) -> Option<&mut T>;
```

---

== Комбинаторы в `Option`

Здесь есть все, о чем только можно мечтать:
```rs
fn map_or<U, F>(self, default: U, f: F) -> U;
fn map_or_else<U, D, F>(self, default: D, f: F) -> U;
fn unwrap_or(self, default: T) -> T;
fn unwrap_or_default(self) -> T;
fn unwrap_or_else<F>(self, f: F) -> T;
fn and<U>(self, optb: Option<U>) -> Option<U>;
fn and_then<U, F>(self, f: F) -> Option<U>;
fn or(self, optb: Option<T>) -> Option<T>;
fn or_else<F>(self, f: F) -> Option<T>;
fn xor(self, optb: Option<T>) -> Option<T>;
fn zip<U>(self, other: Option<U>) -> Option<(T, U)>;
```

== Null pointer optimization

Для некоторых типов размер `Option` будет в точности равен размеру типа.

Это возможно, если для типа существует "ниша" — недопустимое представление:
```rs
assert_eq!(std::mem::size_of::<Option<&u8>>(), std::mem::size_of::<&u8>());
assert_eq!(std::mem::size_of::<Option<Box<u8>>>(), std::mem::size_of::<Box<u8>>());
```

Поэтому `Option<&T>` стоит предпочитать `&Option<T>` там, где это возможно.


== `Result`

В Rust нет исключений. Любые ошибки обрабатываются как значения. Это похоже на знакомую практику в C
```c
int some_f() {
  bool success = 1;
  if success {
    return 0;
  }
  return 1;
}
```

---

Для обозначения результата выполнения функции есть контейнер `Result`
```rs
enum Result<T, E> {
  Ok(T),
  Err(E),
}
```

---

Очень удобно использовать `Result` в сочетании с enum для описания ошибок
```rs
#[derive(Debug)]
enum ParseError { MissingArgument, TooManyArgs(usize) }
fn parse_args() -> Result<(u32, u32), ParseError> {
    let args: Vec<_> = env::args().collect();
    if args.len() != 3 {
        return Err(if args.len() < 3 {
            ParseError::MissingArgument
        } else {
            ParseError::TooManyArgs(args.len() - 1)
        });
    }
    // ...
}
```

== Пример Result

```rs
fn divide(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        Err(String::from("division by zero"))
    } else {
        Ok(a / b)
    }
}
fn main() {
  if let Ok(value) = divide(20.0, 0.0) {
    println!("Okay, {}", value);
  }
}
```

== Оператор ?

Иногда нам необходимо "прокинуть" значение `Result/Option` по стеку вызовов
```rs
fn f() -> Result<(), String> {
    Err(String::from("aboba"))
}
fn g() -> Result<(), String> {
    let x = f();
    if let Err(_) = x {
        return x;
    } else ...
}
```

---

```rs
fn f() -> Result<(), String> {
    Err(String::from("aboba"))
}

fn g() -> Result<(), String> {
    let x = f()?;
    ...
    Ok(())
}
```

== Коллекции

В Rust есть весь "джентельменский" набор коллекций:
- `Vec`
- `VecDeque`
- `BTreeMap`
- `HashMap`
- `BinaryHeap`
- `LinkedList`

== `String`

Строки в Rust сильно отличаются от `std::string`.


Определение из стандартной библиотеки:
```rs
struct String {
  vec: Vec<u8>
}
```

---

Quiz:
```rs
let s = String::from("привет")
println!("{}", s.len())
```

Что будет выведено на экране? #pause

Ответ: 12 (размер в байтах)

---

В Rust стоит воспринимать строку как массив байтов. Все специфичные операции (например, размер, получение среза) выполняются над байтами.

Чтобы получить "аналог" поведения `std::string` из C++ нужно преобразовать в `Vec<char>`.

```rs
let s = String::from("привет");
let t = s.chars().collect::<Vec<_>>();
println!("{:?}", t); // ['п', 'р', 'и', 'в', 'е', 'т']
```

---

```rs
let vec = vec![1, 2, 3, 4];
let vec_slice = &vec[1..3]; // &[2, 3]
let s = String::from("hello");
let s_slice = &s[1..3]; // "el"
```

```rs
let s = String::from("привет");
let s_slice = &s[1..3]; // бах
```

---


== Умный указатель на кучу

```rs
let ptr = Box::new(42);
let y = *ptr;
```

Вспомним, что `Box` -- указатель на динамически выделенную память. Базовые свойства:
- Владеет данными, автоматически освобождает память по уничтожению
- Нулевые накладные расходы (не считая аллокации)
- Удобен для оборачивания типов переменного размера
- Полезен для рекурсивных типов
- `Box<str>` — неизменяемая экономная строка на куче

---

У `Box` есть замечательная функция:
```rs
fn leak<'a>(b: Box<T, A>) -> &'a mut T
```
Пример:
```rs
let x = Box::new(41);
let static_ref: &'static mut usize = Box::leak(x);
*static_ref += 1;
assert_eq!(*static_ref, 42)
```

Но как же *memory safety*?

---

`Rc` — умный указатель, который считает число активных ссылок

```rs
let rc = Rc::new(); // cnt = 1
let rc2 = rc.clone(); // cnt = 2
// cnt = 0 at the end of scope
```

`Rc` бывает полезен, чтобы разделить владение объектом нескольким сущностям.

```rs
fn get_mut(this : &mut Rc<T>) -> Option<&mut T>;
fn downgrade(this: &Rc<T>) -> Weak<T>;
fn weak_count(this: &Rc<T>) -> usize;
fn strong_count(this: &Rc<T>) -> usize;
```

Но как же *единоличное владение*?

---

```rs
use std::rc::Rc;

fn main() {
  let mut a = Rc::new(String::from("Hi"));
  let mut b = Rc::clone(&a);

  // Two mutable Rc, point to one immutable string.
  // It's still possible to call methods requiring &mut Rc, like get_mut

  println!("{:?}", Rc::get_mut(&mut a).is_none());
  println!("{:?}", Rc::get_mut(&mut b).is_none());
}
```


---

== `Weak`

`Weak` -- "слабый" указатель. Он не увеличивает значение счётчика, но всё ещё имеет владение над аллокацией.

`Weak` можно "улучшить" до `Rc` с помощью
```rs
pub fn upgrade(&self) -> Option<Rc<T>>
```

`Rc` можно "ухудшить" до `Weak` с помощью
```rs
pub fn downgrade(this: &Self) -> Weak<T>
```
