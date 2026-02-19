#![forbid(unsafe_code)]

pub struct LRUCache<K, V> {
    // TODO
}

impl<K, V> LRUCache<K, V> {
    // Создание нового объекта LRUCache от максимального числа элементов
    //
    // В случае если capacity равен нулю, функция должна вернуть None
    pub fn new(capacity: usize) -> Option<Self> {
        todo!()
    }

    // Получение элемента из кэша соответствующего ключу
    //
    // Ожидаемое время работы: не более O(logn) в худшем случае
    pub fn get(&mut self, key: &K) -> Option<&V> {
        todo!()
    }

    // Вставка значения value в кэш по заданному ключу key
    //
    // Ожидаемое время работы: не более O(logn) в худшем случае
    pub fn put(&mut self, key: K, value: V) -> Option<V> {
        todo!()
    }
}
