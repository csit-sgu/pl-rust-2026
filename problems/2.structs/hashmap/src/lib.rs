#![forbid(unsafe_code)]

const DEFAULT_MAX_SIZE: u64 = 128;

#[derive(Clone, PartialEq)]
struct Node<K: PartialEq, V> {
    pub key: K,
    pub value: V,
}

impl<K: PartialEq, V> Node<K, V> {
    pub fn new(key: K, value: V) -> Node<K, V> {
        Self { key, value }
    }
}

pub struct HashMap<K, V> {
    // TODO
}

impl<K, V> HashMap<K, V> {
    // Функция должна возвращать новый экземпляр HashMap
    pub fn new() -> Self {
        todo!()
    }

    // Функция должна получать ссылку на значение по заданному ключу за O(H),
    // где H - число элементов с тем же значением хэш-функции, что и у получаемого
    // ключа
    pub fn get(&self, key: K) -> Option<&V> {
        todo!()
    }

    // Функция должна помещать новую пару ключ-значение в хэш-таблицу.
    // Если элемент в хэш-таблице уже присутствует, значение по ключу должно
    // обновляться.
    //
    // Ожидаемое время работы: O(H), где H - число элементов с тем же значением
    // хэш-функции, что и у вставляемого ключа
    pub fn put(&mut self, key: K, val: V) {
        todo!()
    }

    // Функция должна удалять элемент из хэш-таблицы и возвращать значение
    // по этому ключу
    // Ожидаемое время работы: O(H), где H - число элементов с тем же значением
    // хэш-функции
    pub fn delete(&mut self, key: K) -> Option<V> {
        todo!()
    }

    // Функция должна очищать хэш-таблицу
    // Ожидаемое время работы: O(1)
    pub fn clear(&mut self) {
        todo!()
    }
}
