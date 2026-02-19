use std::mem;

pub struct List<T> {
    head: Link<T>,
    len: usize,
}

type Link<T> = Option<Box<Node<T>>>;

struct Node<T> {
    elem: T,
    next: Link<T>,
}

impl<T> List<T> {
    pub fn new() -> List<T> {
        List { head: None, len: 0 }
    }

    pub fn is_empty(&self) -> bool {
        return self.len == 0;
    }

    pub fn push(&mut self, elem: T) {
        let node = Box::new(Node {
            elem,
            next: mem::replace(&mut self.head, None),
        });

        self.len += 1;

        self.head = Some(node);
    }

    pub fn len(&self) -> usize {
        self.len
    }

    pub fn front(&self) -> Option<&T> {
        match &self.head {
            None => None,
            Some(node) => Some(&node.elem),
        }
    }

    pub fn front_mut(&mut self) -> Option<&mut T> {
        match &mut self.head {
            None => None,
            Some(node) => Some(&mut node.elem),
        }
    }

    pub fn pop(&mut self) -> Option<T> {
        match mem::replace(&mut self.head, None) {
            None => None,
            Some(node) => {
                self.head = node.next;
                self.len -= 1;

                Some(node.elem)
            }
        }
    }

    pub fn delete(&mut self, index: usize) -> Option<T> {
        // Если индекс выходит за пределы списка, возвращаем None
        if index >= self.len {
            return None;
        }
        // Если удаляем первый элемент, можно использовать pop
        if index == 0 {
            return self.pop();
        }

        // Ищем узел, предшествующий удаляемому (индекс index - 1)
        let mut current = &mut self.head;
        for _ in 0..(index - 1) {
            if let Some(ref mut node) = current {
                current = &mut node.next;
            } else {
                return None;
            }
        }

        // Теперь current указывает на узел перед удаляемым
        if let Some(ref mut node) = current {
            // Извлекаем удаляемый узел, используя take() для Option
            if let Some(mut target) = node.next.take() {
                // "Переподключаем" указатель: текущий узел теперь ссылается на узел после удаляемого
                node.next = target.next.take();
                self.len -= 1;
                return Some(target.elem);
            }
        }
        None
    }
}
impl<T> Drop for List<T> {
    fn drop(&mut self) {
        let mut cur_link = mem::replace(&mut self.head, None);
        // `while let` == "do this thing until this pattern doesn't match"
        while let Some(mut boxed_node) = cur_link {
            cur_link = mem::replace(&mut boxed_node.next, None);
            // boxed_node goes out of scope and gets dropped here;
            // but its Node's `next` field has been set to Link::Empty
            // so no unbounded recursion occurs.
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_new() {
        let list = List::<i32>::new();
        assert_eq!(list.len(), 0);
    }

    #[test]
    fn test_push() {
        let mut list = List::new();
        list.push(1);
        assert_eq!(list.len(), 1);
        list.push(2);
        assert_eq!(list.len(), 2);
        list.push(3);
        assert_eq!(list.len(), 3);
    }

    #[test]
    fn test_front() {
        let mut list = List::new();
        list.push(1);
        assert_eq!(list.front(), Some(&1));
        list.push(2);
        assert_eq!(list.front(), Some(&2));
        list.push(3);
        assert_eq!(list.front(), Some(&3));
    }

    #[test]
    fn test_pop() {
        let mut list = List::new();
        list.push(1);
        assert_eq!(list.pop(), Some(1));
        assert_eq!(list.len(), 0);
        list.push(2);
        assert_eq!(list.pop(), Some(2));
        assert_eq!(list.len(), 0);
        list.push(3);
        assert_eq!(list.pop(), Some(3));
        assert_eq!(list.len(), 0);
    }

    #[test]
    fn test_delete() {
        let mut list = List::new();
        list.push(1);
        list.push(2);
        list.push(3);
        assert_eq!(list.delete(0), Some(3));
        assert_eq!(list.len(), 2);
        assert_eq!(list.delete(1), Some(1));
        assert_eq!(list.len(), 1);
        assert_eq!(list.delete(0), Some(2));
        assert_eq!(list.len(), 0);
    }
}
