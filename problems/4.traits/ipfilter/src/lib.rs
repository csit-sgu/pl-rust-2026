#![forbid(unsafe_code)]
// Структура для хранения IPv4 адреса
// Адрес представляется в виде четырех 1-байтных чисел
// (обычно пишут число1.число2.число3.число4)
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct IPv4 {
    octets: [u8; 4],
}

impl IPv4 {
    pub fn new(a: u8, b: u8, c: u8, d: u8) -> Self {
        IPv4 {
            octets: [a, b, c, d],
        }
    }

    // Возможно, будет удобно иметь функцию преобразования IP-адреса в 4-байтное число
}

// Трейт для фильтрации IP-адресов
pub trait Filter {
    // TODO
}

// Реализация фильтра "черный список"
pub struct BlacklistFilter {
    // TODO: Для фильтра потребуется хранить черный список
}

impl BlacklistFilter {
    pub fn new(blacklist: Vec<IPv4>) -> Self {
        todo!()
    }
}

impl Filter for BlacklistFilter {
    // TODO
}

// Реализация фильтра "белый список"
pub struct WhitelistFilter {
    // TODO: Для фильтра потребуется хранить белый список
}

impl WhitelistFilter {
    pub fn new(whitelist: Vec<IPv4>) -> Self {
        todo!()
    }
}

impl Filter for WhitelistFilter {
    // TODO
}

// Реализация фильтра по подсети
pub struct SubnetFilter {
    // TODO: Нужно хранить подсеть и маску
}

impl SubnetFilter {
    pub fn new(subnet: IPv4, mask: IPv4) -> Self {
        todo!()
    }
}

impl Filter for SubnetFilter {
    // TODO
}

// Функция для фильтрации вектора IP-адресов
// TODO: Опишите функцию ip_collection_filter согласно условию
