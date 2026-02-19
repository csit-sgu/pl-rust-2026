#[cfg(test)]
mod tests {
    use min_stack::MinStack;

    #[test]
    fn test_stack() {
        let mut stack = MinStack::<i32>::default();
        stack.push(5);
        stack.push(4);
        stack.push(9);
        assert_eq!(stack.len(), 3);
        assert_eq!(stack.is_empty(), false);
        assert_eq!(stack.pop(), Some(9));
        assert_eq!(stack.pop(), Some(4));
        assert_eq!(stack.len(), 1);
        assert_eq!(stack.pop(), Some(5));
        assert_eq!(stack.pop(), None);
        assert_eq!(stack.len(), 0);
        assert_eq!(stack.is_empty(), true);
    }

    #[test]
    fn test_min_stack() {
        let mut stack = MinStack::<i32>::default();
        stack.push(5);
        stack.push(4);
        stack.push(9);
        stack.push(3);
        stack.push(2);
        stack.push(10);
        assert_eq!(stack.min(), Some(&2));
        stack.pop();
        assert_eq!(stack.min(), Some(&2));
        stack.pop();
        assert_eq!(stack.min(), Some(&3));
        stack.pop();
        assert_eq!(stack.min(), Some(&4));
        stack.pop();
        assert_eq!(stack.min(), Some(&4));
        stack.pop();
        assert_eq!(stack.min(), Some(&5));
        stack.pop();
        assert_eq!(stack.min(), None);
    }

    #[test]
    fn test_min_stack_empty() {
        let mut stack = MinStack::<i32>::default();
        let poped = stack.pop();
        assert_eq!(poped, None);
    }

    #[test]
    fn test_min_stack_top() {
        let mut stack = MinStack::<i32>::default();
        assert_eq!(stack.top(), None);
        stack.push(10);
        assert_eq!(stack.top(), Some(&10));
        stack.push(7);
        assert_eq!(stack.top(), Some(&7));
        stack.pop();
        assert_eq!(stack.top(), Some(&10));
    }

    #[test]
    fn test_min_stack_with_duplicates() {
        let mut stack = MinStack::<i32>::default();
        stack.push(3);
        stack.push(3);
        stack.push(3);
        assert_eq!(stack.min(), Some(&3));
        stack.pop();
        assert_eq!(stack.min(), Some(&3));
        stack.pop();
        assert_eq!(stack.min(), Some(&3));
        stack.pop();
        assert_eq!(stack.min(), None);
    }
}
