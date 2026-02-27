use std::mem;

fn main() {
    let arr: [i32; 5] = [10, 20, 30, 40, 50];
    let slice = &arr[0..4];
    println!("Size of array: {} bytes", mem::size_of_val(&arr)); // 20 bytes
    println!("Size of slice: {} bytes", mem::size_of_val(&slice)); // 16 bytes
}
