#![forbid(unsafe_code)]
use std::collections::HashMap;
use std::hash::Hash;

// Трейт для отношения эквивалентности
pub trait EqRelation {
    // TODO: Ознакомьтесь с ассоциированными типами
    type Item;

    // TODO: объявите функцию equivalence_classes согласно условию
}

// Неориентированный граф
pub struct UndirectedGraph<T /* TODO */> {
    adjacency_list: HashMap<T, Vec<T>>,
}

impl<T /* TODO */> UndirectedGraph<T> {
    pub fn new() -> Self {
        UndirectedGraph {
            adjacency_list: HashMap::new(),
        }
    }

    pub fn add_edge(&mut self, u: T, v: T) {
        self.adjacency_list
            .entry(u.clone())
            .or_default()
            .push(v.clone());
        self.adjacency_list.entry(v).or_default().push(u);
    }
}

// TODO: реализуйте трейт EqRelation для UndirectedGraph
// используйте серию DFS

// Ориентированный граф
pub struct DirectedGraph<T /* TODO */> {
    adjacency_list: HashMap<T, Vec<T>>,
}

impl<T /* TODO */> DirectedGraph<T> {
    pub fn new() -> Self {
        DirectedGraph {
            adjacency_list: HashMap::new(),
        }
    }

    pub fn add_edge(&mut self, u: T, v: T) {
        self.adjacency_list.entry(u).or_default().push(v);
    }
}

// TODO: реализуйте трейт EqRelation для DirectedGraph
// используйте алгоритм Косараю

// TODO: опишите функцию max_equivalence_class согласно условию

