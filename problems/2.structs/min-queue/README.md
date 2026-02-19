# Очередь с минимумом

Реализуйте очередь, которая также может возвращать текущий минимум. **Реализация должна иметь сложность хотя бы O(1) в амортизированном смысле для всех вызовов.**

## Подсказки

- Если вы не помните, как работает такая очередь, прочитайте об этом на [cp-algorithms](https://cp-algorithms.com/data_structures/stack_queue_modification.html).
- Вам понадобится использовать [VecDeque](https://doc.rust-lang.org/std/collections/struct.VecDeque.html) для решения этой задачи. Ознакомьтесь с методами [`push_back`](https://doc.rust-lang.org/std/collections/struct.VecDeque.html#method.push_back), [`pop_front`](https://doc.rust-lang.org/std/collections/struct.VecDeque.html#method.pop_front), [`pop_back`](https://doc.rust-lang.org/std/collections/struct.VecDeque.html#method.pop_back), [`front`](https://doc.rust-lang.org/std/collections/struct.VecDeque.html#method.front).
