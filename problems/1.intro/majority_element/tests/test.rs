use majority_element::majority_element;

#[test]
fn test1() {
    let arr = vec![1, 1, 1, 1, 2];
    assert_eq!(majority_element(arr), 1);
}

#[test]
fn test2() {
    let arr = vec![3, 2, 3, 4, 3];
    assert_eq!(majority_element(arr), 3);
}

#[test]
fn test3() {
    let arr = vec![2, 2, 1, 1, 1, 2, 2];
    assert_eq!(majority_element(arr), 2);
}
