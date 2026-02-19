#[cfg(test)]
mod tests {
    use priority_queue::PriorityQueue;

    #[test]
    fn test_push_and_pop_order() {
        let mut pq = PriorityQueue::new();

        pq.push("low", 1);
        pq.push("high", 10);
        pq.push("medium", 5);

        assert_eq!(pq.pop(), Some("high"));
        assert_eq!(pq.pop(), Some("medium"));
        assert_eq!(pq.pop(), Some("low"));
        assert_eq!(pq.pop(), None);
    }

    #[test]
    fn test_peek() {
        let mut pq = PriorityQueue::new();
        pq.push("alpha", 42);
        pq.push("beta", 7);

        assert_eq!(pq.peek(), Some(&"alpha")); // 42 > 7
    }

    #[test]
    fn test_len_and_empty() {
        let mut pq = PriorityQueue::new();
        assert!(pq.is_empty());
        assert_eq!(pq.len(), 0);

        pq.push("task", 3);
        assert!(!pq.is_empty());
        assert_eq!(pq.len(), 1);

        pq.pop();
        assert!(pq.is_empty());
    }

    #[test]
    fn test_clear() {
        let mut pq = PriorityQueue::new();
        pq.push("a", 1);
        pq.push("b", 2);
        pq.push("c", 3);

        pq.clear();
        assert_eq!(pq.len(), 0);
        assert!(pq.is_empty());
        assert_eq!(pq.pop(), None);
    }

    #[test]
    fn test_equal_priority() {
        let mut pq = PriorityQueue::new();
        pq.push("first", 10);
        pq.push("second", 10);
        pq.push("third", 10);

        let mut results = vec![pq.pop(), pq.pop(), pq.pop()];

        results.sort(); // порядок при одинаковом приоритете не гарантирован
        assert_eq!(results, vec![Some("first"), Some("second"), Some("third")]);
    }
}
