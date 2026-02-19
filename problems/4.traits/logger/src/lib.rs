#![forbid(unsafe_code)]
use chrono::Local;
use std::fs::{File, OpenOptions};
use std::io::Write;

pub trait Logger {
    // TODO: Объявите функции для каждого вида сообщений
}

pub struct ConsoleLogger;

impl Logger for ConsoleLogger {
    // TODO
}

pub struct FileLogger {
    // TODO: Структура должна хранить объект типа File (открытый файл)
}

impl FileLogger {
    pub fn new(filename: &str) -> Self {
        todo!()
    }
}

impl Logger for FileLogger {
    // TODO
}

// TODO: Опишите функцию process_vector согласно условию

