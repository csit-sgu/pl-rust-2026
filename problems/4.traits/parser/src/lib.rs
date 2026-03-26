#![forbid(unsafe_code)]
use std::{
    char,
    collections::HashMap,
    error::Error,
    fmt::{self, Debug},
    fs::File,
    io::{self, BufRead, BufReader},
    path::Path,
    rc::Rc,
    str::FromStr,
};

pub type Cell = String;
pub type Row = Vec<Cell>;
pub type Table = Vec<Row>;

// Трейт Parser
pub trait Parser {
    // TODO: объявите функцию с нужными ограничениями типа
}

pub struct CsvParser;

// TODO: опишите реализацию трейта Parser для CsvParser

pub struct TsvParser;

// TODO: опишите реализацию трейта Parser для TsvParser

trait ParserFactory {
    // TODO: объявите функцию/функции с нужными ограничениями типа для создания
    // нужного парсера по пути до файла (кол-во функций зависит от вашей реализации)
}

#[derive(Default)]
struct FileParserFactory {
    // TODO: определите кэш для созданных парсеров (созданные парсеры должны переиспользоваться, а
    // не создаваться еще раз)
    // Для реализации используйте ParserType
}

// TODO: опишите реализацию ParserFactory для FileParserFactory

// TODO: используя FileParserFactory реализуйте данную функцию
// Парсит все файы из списка путей нужным парсером, если это возможно
// и возвращаем результат попытки парсинга для каждого файла
// NOTE: оно ругается т.к. вместо реализации макрос todo!
pub fn try_parse_files<P: AsRef<Path>>(paths: &[P]) -> impl Iterator<Item = Result<Table, Errors>> {
    todo!()
}

// NOTE: должен использоваться для кэша парсеров
#[derive(PartialEq, Eq, Hash)]
enum ParserType {
    Csv,
    Tsv,
}

impl FromStr for ParserType {
    type Err = ParserError;
    fn from_str(path_extention: &str) -> std::result::Result<Self, Self::Err> {
        match path_extention.to_ascii_lowercase().as_str() {
            "csv" => Ok(ParserType::Csv),
            "tsv" => Ok(ParserType::Tsv),
            _ => Err(ParserError {
                kind: ParseErrorKind::NotImplemented,
            }),
        }
    }
}

// FIX: здесь тоже стоит вместо реализации todo!() накинуть, но не знаю на что именно
pub enum Errors {
    Io(io::Error),
    Parser(ParserError),
}

impl From<std::io::Error> for Errors {
    fn from(value: std::io::Error) -> Self {
        Self::Io(value)
    }
}

impl From<ParserError> for Errors {
    fn from(value: ParserError) -> Self {
        Self::Parser(value)
    }
}

impl Debug for Errors {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Errors::Io(e) => e.fmt(f),
            Errors::Parser(e) => e.fmt(f),
        }
    }
}

#[derive(Debug, PartialEq, Eq)]
pub struct ParserError {
    kind: ParseErrorKind,
}

#[derive(Debug, PartialEq, Eq)]
enum ParseErrorKind {
    IncorrectFormatData,
    NotImplemented,
}

impl Error for ParserError {}

impl fmt::Display for ParserError {
    fn fmt(&self, formmater: &mut fmt::Formatter<'_>) -> fmt::Result {
        match &self.kind {
            ParseErrorKind::IncorrectFormatData => {
                writeln!(formmater, "Некорректный формат данных для данного парсера.",)
            }
            ParseErrorKind::NotImplemented => {
                writeln!(formmater, "Парсер для данного типа файла не реализован.",)
            }
        }
    }
}
