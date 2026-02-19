#![forbid(unsafe_code)]
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::str::FromStr;

// Трейт Parser
pub trait Parser</* TODO: ограничения типа */> {
    // TODO: объявите функцию
}

pub struct CsvParser;

// TODO: опишите реализацию трейта Parser для CsvParser

pub struct TsvParser;

// TODO: опишите реализацию трейта Parser для TsvParser
