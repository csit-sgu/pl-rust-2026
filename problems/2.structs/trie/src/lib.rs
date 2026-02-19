#[forbid(unsafe_code)]
use std::collections::HashMap;

struct TrieNode {
    is_end_of_word: bool,
    children: HashMap<char, TrieNode>,
}

pub struct Trie {
    root: TrieNode,
}

impl Trie {
    // Создание нового пустого бора.
    //
    // Ожидаемое время работы: O(1)
    pub fn new() -> Self {
        todo!()
    }

    // Вставка слова в бор. При добавлении слова, мы проходим по каждому символу и
    // создаём дочерний узел, если его нет. В конце ставим флаг, что это конец слова.
    //
    // Ожидаемое время работы: O(n), где n — длина слова.
    pub fn insert(&mut self, word: &str) {
        todo!()
    }

    // Поиск полного слова в боре. Мы проходим по всем символам слова и
    // проверяем, существуют ли соответствующие узлы. Если находим конец слова,
    // возвращаем `true`, иначе `false`.
    //
    // Ожидаемое время работы: O(n), где n — длина слова.
    pub fn search(&self, word: &str) -> bool {
        todo!()
    }
}
