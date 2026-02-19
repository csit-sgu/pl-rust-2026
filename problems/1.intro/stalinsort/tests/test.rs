use stalinsort::stalinsort1;

#[test]
fn simple() {
    assert_eq!(stalinsort1(&[1, 2, 3, 4, 5]), [1, 2, 3, 4, 5]);
    assert_eq!(stalinsort1(&[5, 3, 4, 2, 1]), [5]);
    assert_eq!(stalinsort1(&[14, 1, 154, 45, 456, 9, 10, 45, 1234, 12]), [14, 154, 456, 1234]);
}
