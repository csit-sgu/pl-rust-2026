#[cfg(test)]
mod tests {
    use graphs::*;
    use std::collections::HashSet;

    #[test]
    fn test_undirected_1() {
        let mut graph = UndirectedGraph::new();
        graph.add_edge(1, 2);
        graph.add_edge(2, 3);
        graph.add_edge(4, 5);

        let components = graph.equivalence_classes();
        assert_eq!(components.len(), 2);

        let all_nodes: HashSet<_> = components.iter().flatten().collect();
        // Проверка на содержание всех вершин в объединении компонент
        assert_eq!(all_nodes.len(), 5);
        assert!(all_nodes.contains(&1));
        assert!(all_nodes.contains(&2));
        assert!(all_nodes.contains(&3));
        assert!(all_nodes.contains(&4));
        assert!(all_nodes.contains(&5));

        // Проверяем, что компоненты правильно разделены
        let component_sizes: Vec<_> = components.iter().map(|c| c.len()).collect();
        assert!(component_sizes.contains(&3)); // [1, 2, 3]
        assert!(component_sizes.contains(&2)); // [4, 5]

        // Проверяем максимальный класс
        let largest = max_equivalence_class(&graph);
        assert_eq!(largest.len(), 3); // [1, 2, 3]
    }

    #[test]
    fn test_directed_1() {
        let mut graph = DirectedGraph::new();
        graph.add_edge(1, 2);
        graph.add_edge(2, 3);
        graph.add_edge(3, 1);
        graph.add_edge(4, 5);
        graph.add_edge(5, 6);
        graph.add_edge(7, 8);
        graph.add_edge(8, 7);

        let components = graph.equivalence_classes();

        // Должно быть 5 компонент: [1, 2, 3], [4], [5], [6], [7, 8]
        assert!(components.len() == 5);

        // Проверяем, что все вершины присутствуют
        let all_nodes: HashSet<_> = components.iter().flatten().collect();
        assert_eq!(all_nodes.len(), 8);
        for i in 1..=8 {
            assert!(all_nodes.contains(&i));
        }

        // Проверяем наличие [1, 2, 3] и [7, 8]
        let has_cycle_123 = components
            .iter()
            .any(|c| c.len() == 3 && c.contains(&1) && c.contains(&2) && c.contains(&3));
        assert!(has_cycle_123);

        let has_cycle_78 = components
            .iter()
            .any(|c| c.len() == 2 && c.contains(&7) && c.contains(&8));
        assert!(has_cycle_78);

        // Проверяем максимальный класс
        let largest = max_equivalence_class(&graph);
        assert_eq!(largest.len(), 3); // [1, 2, 3]
    }
}

