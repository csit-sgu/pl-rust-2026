#[cfg(test)]
mod tests {
    use parser::*;
    use std::fs::File;
    use std::io::Write;

    #[test]
    fn test_csv_1() {
        let csv_content = r#"Name,Age,City
Petya,25,New York
Inna,30,London
Denis,17,"Paris, Chelyabinskaya obl."#;

        let csv_path = "test_data.csv";

        File::create(csv_path)
            .unwrap()
            .write_all(csv_content.as_bytes())
            .unwrap();

        let parser = CsvParser;
        let result: Result<Vec<Vec<String>>, String> = parser.parse_file(&csv_path);

        assert!(result.is_ok());
        let data = result.unwrap();

        assert_eq!(data.len(), 4);
        assert_eq!(data[1], vec!["Petya", "25", "New York"]);
        assert_eq!(data[2], vec!["Inna", "30", "London"]);
        assert_eq!(data[3], vec!["Denis", "17", "Paris, Chelyabinskaya obl."]);

        let _ = std::fs::remove_file(csv_path);
    }

    #[test]
    fn test_csv_2() {
        let csv_content = r#"Name,Age,City
Petya,25,New York
Inna,30,London
Denis,17,"Paris, Chelyabinskaya obl."#;

        let csv_path = "test_data.csv";
        let csv_path_incorrect = "aboba.csv";

        File::create(csv_path)
            .unwrap()
            .write_all(csv_content.as_bytes())
            .unwrap();

        let parser = CsvParser;
        let result: Result<Vec<Vec<String>>, String> = parser.parse_file(&csv_path_incorrect);

        assert!(result.is_err());

        let _ = std::fs::remove_file(csv_path);
    }
}

