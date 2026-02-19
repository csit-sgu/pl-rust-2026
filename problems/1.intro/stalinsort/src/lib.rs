#![forbid(unsafe_code)]

pub fn stalinsort(arr: &[i32]) -> Vec<i32> {
    arr.iter().fold(vec![], |mut acc, a| {
        if acc.last().map_or(true, |x| x < a) {
            acc.push(*a);
        }

        acc
    })
}
