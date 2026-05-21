#[cfg(test)]
mod tests {
    use parser::*;
    use std::error::Error;
    use std::fs::File;
    use std::io::{BufReader, Write};

    #[test]
    fn success_csv() {
        let csv_content = "Name,Age,City\n\
            Petya,25,New York\n\
            Inna,30,London\n\
            Denis,17,\"Paris, Chelyabinskaya obl.\"";

        let csv_path = "test_data_sc.csv";

        File::create(csv_path)
            .unwrap()
            .write_all(csv_content.as_bytes())
            .unwrap();

        let file = File::open(csv_path).unwrap();
        let mut csv_reader = BufReader::new(file);

        let parser = CsvParser;
        let result: Table = parser.parse(&mut csv_reader).unwrap();

        assert_eq!(result.len(), 4);
        assert_eq!(result[1], vec!["Petya", "25", "New York"]);
        assert_eq!(result[2], vec!["Inna", "30", "London"]);
        assert_eq!(result[3], vec!["Denis", "17", "Paris, Chelyabinskaya obl."]);

        let _ = std::fs::remove_file(csv_path);
    }

    #[test]
    fn success_csv_2() {
        let csv_content = "Name,Age,City\n\
            Petya,25,New York\n\
            Inna,30,London\n\
            Denis,17,\"Paris,\n Chelyabinskaya obl.\"";

        let csv_path = "test_data_sc2.csv";

        File::create(csv_path)
            .unwrap()
            .write_all(csv_content.as_bytes())
            .unwrap();

        let file = File::open(csv_path).unwrap();
        let mut csv_reader = BufReader::new(file);

        let parser = CsvParser;
        let result: Table = parser.parse(&mut csv_reader).unwrap();

        assert_eq!(result.len(), 4);
        assert_eq!(result[1], vec!["Petya", "25", "New York"]);
        assert_eq!(result[2], vec!["Inna", "30", "London"]);
        assert_eq!(
            result[3],
            vec!["Denis", "17", "Paris,\n Chelyabinskaya obl."]
        );

        let _ = std::fs::remove_file(csv_path);
    }

    #[test]
    fn success_tsv() {
        let tsv_content = "Name\tAge\tCity\n\
            Petya\t25\tNew York\n\
            Inna\t30\tLondon\n\
            Denis\t17\t\"Paris\t Chelyabinskaya obl.\"";

        let tsv_path = "test_datas_st.tsv";

        File::create(tsv_path)
            .unwrap()
            .write_all(tsv_content.as_bytes())
            .unwrap();

        let file = File::open(tsv_path).unwrap();
        let mut tsv_reader = BufReader::new(file);

        let parser = TsvParser;
        let result: Table = parser.parse(&mut tsv_reader).unwrap();

        assert_eq!(result.len(), 4);
        assert_eq!(result[1], vec!["Petya", "25", "New York"]);
        assert_eq!(result[2], vec!["Inna", "30", "London"]);
        assert_eq!(
            result[3],
            vec!["Denis", "17", "Paris\t Chelyabinskaya obl."]
        );

        let _ = std::fs::remove_file(tsv_path);
    }

    #[test]
    fn failure_csv() {
        let csv_content = "Name,Age,City\n\
            Petya,25,New York\n\
            Inna,30,London\n\
            Denis,17,\"Paris, Chelyabinskaya obl.";

        let csv_path = "test_data_fc.csv";

        File::create(csv_path)
            .unwrap()
            .write_all(csv_content.as_bytes())
            .unwrap();

        let file = File::open(csv_path).unwrap();
        let mut csv_reader = BufReader::new(file);

        let parser = CsvParser;
        let result = parser.parse(&mut csv_reader);

        let _ = std::fs::remove_file(csv_path);
        assert!(result.is_err());
    }

    #[test]
    fn failure_tsv() {
        let tsv_content = "Name\tAge\tCity\n\
            Petya\t25\tNew York\n\
            Inna\t30\tLondon\n\
            Denis\t17\t\"Paris\t Chelyabinskaya obl.";

        let tsv_path = "test_data_ft.tsv";

        File::create(tsv_path)
            .unwrap()
            .write_all(tsv_content.as_bytes())
            .unwrap();

        let file = File::open(tsv_path).unwrap();
        let mut tsv_reader = BufReader::new(file);

        let parser = TsvParser;
        let result = parser.parse(&mut tsv_reader);

        let _ = std::fs::remove_file(tsv_path);
        assert!(result.is_err());
    }

    #[test]
    fn test_try_parse_files() {
        let tsv_content = "Name\tAge\tCity\n\
            Petya\t25\tNew York\n\
            Inna\t30\tLondon\n\
            Denis\t17\t\"Paris\t Chelyabinskaya obl.\"";
        let tsv_path = "test_data_st_try_parse.tsv";

        File::create(tsv_path)
            .unwrap()
            .write_all(tsv_content.as_bytes())
            .unwrap();

        let csv_content = "Name,Age,City\n\
            Petya,25,New York\n\
            Inna,30,London\n\
            Denis,17,\"Paris, Chelyabinskaya obl.\"";
        let csv_path = "test_data_sc_try_parse.csv";

        File::create(csv_path)
            .unwrap()
            .write_all(csv_content.as_bytes())
            .unwrap();

        let json_content = "{text: \"абоба\"}";
        let json_path = "test_data_fj_try_parse.json";

        File::create(json_path)
            .unwrap()
            .write_all(json_content.as_bytes())
            .unwrap();
        let bad_path = "test_bad_path.csv";

        let paths = vec![csv_path, tsv_path, json_path, csv_path, bad_path, tsv_path];
        let results = try_parse_files(&paths);
        assert!(results[0].is_ok());
        assert!(results[1].is_ok());
        assert!(results[2].is_err());
        assert!(results[3].is_ok());
        assert!(results[4].is_err());
        assert!(results[5].is_ok());

        let _ = std::fs::remove_file(tsv_path);
        let _ = std::fs::remove_file(csv_path);
        let _ = std::fs::remove_file(json_path);
        let _ = std::fs::remove_file(bad_path);
    }
}
