#![forbid(unsafe_code)]

// Трейт Pinger
pub trait Pinger {
    // TODO: Объявите функцию ping_sites согласно условию
}

// Трейт для вывода результатов
pub trait Writer {
    // TODO: Объявите функцию write согласно условию
}

// Если необходимо, структуры могут иметь в себе приватные поля
pub struct SystemPinger;

pub struct TcpPinger;

pub struct ReqwestPinger;

pub struct ConsoleWriter;

pub struct FileWriter;

pub struct PingerWrapper;

// TODO: Опишите необходимые реализации трейтов для каждой структуры

// Основная функция для проверки сайтов и вывода
// TODO: Опишите функцию check_and_report самостоятельно
