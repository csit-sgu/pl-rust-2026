struct MyArray<T> {
    data: Vec<T>,
}

impl<T> MyArray<T> {
    fn new() -> Self {
        MyArray { data: Vec::new() }
    }

    fn from(vec: Vec<T>) -> Self {
        MyArray { data: vec }
    }

    fn push(&mut self, value: T) {
        self.data.push(value);
    }

    fn get(&self, index: usize) -> Option<&T> {
        self.data.get(index)
    }

    fn len(&self) -> usize {
        self.data.len()
    }

    fn is_empty(&self) -> bool {
        self.data.is_empty()
    }
}
