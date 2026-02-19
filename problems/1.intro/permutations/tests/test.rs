use permutations::permutations;
use std::collections::HashSet;
use std::hash::Hash;

fn are_equal<T>(a: &[T], b: &[T]) -> bool
where
    T: Eq + Hash,
{
    let a: HashSet<_> = a.iter().collect();
    let b: HashSet<_> = b.iter().collect();

    a == b
}

#[test]
fn simple() {
    assert!(are_equal(&permutations(&[1]), &[vec![1]]));
    assert!(are_equal(&permutations(&[1, 2]), &[vec![1, 2], vec![2, 1]]));
    assert!(are_equal(
        &permutations(&[1, 2, 3]),
        &[
            vec![1, 2, 3],
            vec![1, 3, 2],
            vec![2, 1, 3],
            vec![2, 3, 1],
            vec![3, 1, 2],
            vec![3, 2, 1]
        ]
    ));

    permutations(&[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);
}
