use max_profit::max_profit;

#[test]
fn test1() {
    let prices = vec![7, 1, 5, 3, 6, 4];
    assert_eq!(max_profit(prices), 7);
}

#[test]
fn test2() {
    let prices = vec![1, 2, 3, 4, 5];
    assert_eq!(max_profit(prices), 4);
}

#[test]
fn test3() {
    let prices = vec![7, 6, 4, 3, 1];
    assert_eq!(max_profit(prices), 0);
}
