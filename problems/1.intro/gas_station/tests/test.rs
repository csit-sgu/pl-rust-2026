use gas_station::can_complete_circuit;

#[test]
fn test1() {
    const GAS: [i32; 4] = [1, 2, 3, 4];
    const COST: [i32; 4] = [4, 3, 2, 1];

    assert_eq!(can_complete_circuit(GAS.to_vec(), COST.to_vec()), 2);
}

#[test]
fn test2() {
    const GAS: [i32; 4] = [1, 2, 3, 4];
    const COST: [i32; 4] = [3, 4, 5, 6];

    assert_eq!(can_complete_circuit(GAS.to_vec(), COST.to_vec()), -1);
}

#[test]
fn test3() {
    const GAS: [i32; 4] = [5, 8, 2, 8];
    const COST: [i32; 4] = [6, 5, 6, 6];

    assert_eq!(can_complete_circuit(GAS.to_vec(), COST.to_vec()), 3);
}
