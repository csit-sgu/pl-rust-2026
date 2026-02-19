#![forbid(unsafe_code)]
use reqwest::blocking::Client;
use std::fs::File;
use std::io::Write;
use std::process::Command;

// Трейт Pinger
pub trait Pinger {
    // TODO: Объявите функцию ping_sites согласно условию
}

// Трейт для вывода результатов
pub trait Writer {
    // TODO: Объявите функцию write согласно условию
}

// Реализация через системный ping
pub struct SystemPinger;

impl Pinger for SystemPinger {
    // TODO
}

// Реализация через Reqwest
// Структура содержит одно поле: созданный при инициализации клиент
pub struct ReqwestPinger {
    client: Client,
}

impl ReqwestPinger {
    pub fn new() -> Self {
        // client должен принять некоторое значение
        todo!()
    }
}

impl Pinger for ReqwestPinger {
    // TODO
}

// Реализация Writer для консоли
pub struct ConsoleWriter;

impl Writer for ConsoleWriter {
    // TODO
}

// Реализация Writer для файла
// Структура содержит одно поле: адрес файла для записи
pub struct FileWriter {
    path: String,
}

impl FileWriter {
    pub fn new(path: String) -> Self {
        todo!()
    }
}

impl Writer for FileWriter {
    // TODO
}

// Основная функция для проверки сайтов и вывода
// TODO: Опишите функцию check_and_report самостоятельно

