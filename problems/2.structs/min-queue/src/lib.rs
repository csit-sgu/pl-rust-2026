#![forbid(unsafe_code)]

pub struct MinQueue<T> {
    // TODO
}

impl<T: Clone + Ord> MinQueue<T> {
    // Создание нового объекта MinQueue
    pub fn new() -> Self {
        todo!()
    }

    // Добавление нового элемента в очередь.
    //
    // Ожидаемое время работы: O(1)
    pub fn push(&mut self, new_element: T) {
        todo!()
    }

    // Извлечение элемента из очереди (удаление элемента из передней части).
    pub fn pop(&mut self) -> Option<T> {
        todo!()
    }

    // Получение элемента из передней части очереди, не удаляя его.
    pub fn front(&mut self) -> Option<&T> {
        todo!()
    }

    // Получение минимального элемента из очереди.
    //
    // Ожидаемое время работы: O(1)
    pub fn min(&self) -> Option<&T> {
        todo!()
    }

    // Возвращение количества элементов в очереди.
    //
    // Ожидаемое время работы: O(1)
    pub fn len(&self) -> usize {
        todo!()
    }

    // Проверка, пуста ли очередь.
    //
    // Ожидаемое время работы: O(1)
    pub fn is_empty(&self) -> bool {
        todo!()
    }
}
