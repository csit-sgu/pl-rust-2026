#[cfg(test)]
mod tests {
    use min_queue::MinQueue;

    #[test]
    fn test_min_queue() {
        let mut q = MinQueue::<i32>::default();
        q.push(1);
        q.push(2);
        q.push(3);
        assert_eq!(q.pop(), Some(1));
        q.push(4);
        q.push(5);
        assert_eq!(q.pop(), Some(2));
        assert_eq!(q.pop(), Some(3));
        assert_eq!(q.pop(), Some(4));
        assert_eq!(q.pop(), Some(5));
        assert_eq!(q.pop(), None);
    }

    #[test]
    fn test_min_queue_empty() {
        let mut q = MinQueue::<i32>::default();
        assert_eq!(q.is_empty(), true);
        q.push(5);
        assert_eq!(q.is_empty(), false);
    }

    #[test]
    fn test_min_queue_min() {
        let mut q = MinQueue::<i32>::default();
        q.push(5);
        q.push(2);
        q.push(8);
        assert_eq!(q.min(), Some(&2));
        q.pop();
        assert_eq!(q.min(), Some(&2));
        q.pop();
        assert_eq!(q.min(), Some(&8));
        q.pop();
        assert_eq!(q.min(), None);
        q.push(1);
        assert_eq!(q.min(), Some(&1));
        q.pop();
        assert_eq!(q.min(), None);
    }

    #[test]
    fn test_min_queue_len() {
        let mut q = MinQueue::<i32>::default();
        assert_eq!(q.len(), 0);
        q.push(1);
        q.push(2);
        q.push(3);
        assert_eq!(q.len(), 3);
        q.pop();
        assert_eq!(q.len(), 2);
        q.pop();
        assert_eq!(q.len(), 1);
        q.pop();
        assert_eq!(q.len(), 0);
    }

    #[test]
    fn test_min_queue_with_duplicates() {
        let mut q = MinQueue::<i32>::default();
        q.push(3);
        q.push(3);
        q.push(3);
        assert_eq!(q.min(), Some(&3));
        q.pop();
        assert_eq!(q.min(), Some(&3));
        q.pop();
        assert_eq!(q.min(), Some(&3));
        q.pop();
        assert_eq!(q.min(), None);
    }

    #[test]
    fn test_min_queue_multiple_operations() {
        let mut q = MinQueue::<i32>::default();
        q.push(7);
        q.push(1);
        q.push(5);
        assert_eq!(q.min(), Some(&1));
        q.pop();
        assert_eq!(q.min(), Some(&1));
        q.push(2);
        q.push(3);
        assert_eq!(q.min(), Some(&1));
        q.pop();
        assert_eq!(q.min(), Some(&2));
    }
}
