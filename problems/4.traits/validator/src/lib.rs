#![forbid(unsafe_code)]
pub trait FormField {
    fn validate(&self) -> bool;
}

// Номер телефона
#[derive(PartialEq, Debug, Clone)]
pub struct PhoneNumber(String);

impl PhoneNumber {
    pub fn new(number: String) -> Self {
        todo!()
    }
}

// TODO: реализация трейта FormField для PhoneNumber

// Пароль
#[derive(PartialEq, Debug, Clone)]
pub struct Password(String);

impl Password {
    pub fn new(password: String) -> Self {
        todo!()
    }
}

// TODO: реализация трейта FormField для Password

// Email
#[derive(PartialEq, Debug, Clone)]
pub struct Email(String);

impl Email {
    pub fn new(email: String) -> Self {
        todo!()
    }
}
// TODO: реализация трейта FormField для Email

// TODO: Опишите функцию remove_valid согласно условию
