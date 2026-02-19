use bogosort::bogosort;
use rand::Rng;

#[test]
fn simple() {
    assert_eq!(bogosort(&[1, 2, 3, 4, 5]), [1, 2, 3, 4, 5]);
    assert_eq!(bogosort(&[5, 3, 4, 2, 1]), [1, 2, 3, 4, 5]);
}

#[test]
fn random_test() {
    // generate test with random data of length 7
    let mut rng = rand::thread_rng();
    let data: Vec<i32> = (0..10).map(|_| rng.gen_range(0..100)).collect();

    let mut sorted = data.clone();
    sorted.sort();
    assert_eq!(bogosort(&data), sorted);
}
