#[cfg(test)]
mod tests {
    use detector::*;

    #[test]
    fn test_function_1() {
        let sites = vec![
            "yandex.ru".to_string(),
            "github.com".to_string(),
            "abobakagav.test".to_string(),
            "youtube.com".to_string(),
        ];
        check_and_report(sites, ReqwestPinger::new(), ConsoleWriter);
    }
}

