#[forbid(unsafe_code)]

#[derive(Debug, Eq, PartialEq)]
struct Item<T> {
    value: T,
    priority: u32,
}

pub struct PriorityQueue<T> {
    // TODO
}

impl<T> PriorityQueue<T> {
    pub fn new() -> Self {
        todo!()
    }

    // Функция добавляет элемент в очередь с заданным приоритетом priority
    pub fn push(&mut self, value: T, priority: u32) {
        todo!()
    }

    // Функция извлекает элемент с наибольшим приоритетом
    pub fn pop(&mut self) -> Option<T> {
        todo!()
    }

    // Функция возвращает ссылку на элемент с наибольшим приоритетом
    pub fn peek(&self) -> Option<&T> {
        todo!()
    }

    // Функция проверяет, пуста ли очередь
    pub fn is_empty(&self) -> bool {
        todo!()
    }

    // Функция возвращает размер очереди
    pub fn len(&self) -> usize {
        todo!()
    }

    // Функция выполняет очистку очереди
    pub fn clear(&mut self) {
        todo!()
    }
}
