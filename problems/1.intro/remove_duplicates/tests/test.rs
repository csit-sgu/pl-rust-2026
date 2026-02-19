use remove_duplicates::remove_duplicates;

#[test]
fn test1() {
    let mut nums = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    let k = remove_duplicates(&mut nums);
    assert_eq!(nums[..k as usize], vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
}

#[test]
fn test2() {
    let mut nums = vec![1, 1, 2, 2, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    let k = remove_duplicates(&mut nums);
    assert_eq!(
        nums[..k as usize],
        vec![1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    );
}

#[test]
fn test3() {
    let mut nums = vec![1, 2, 2, 3, 3];
    let k = remove_duplicates(&mut nums);
    assert_eq!(nums[..k as usize], vec![1, 2, 2, 3, 3]);
}
