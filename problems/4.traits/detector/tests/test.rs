#[cfg(test)]
mod tests {
    use detector::*;

    #[test]
    fn test_function_1() {
        let sites: Vec<_> = vec!["yandex.ru", "github.com", "abobakagav.test", "youtube.com"];

        let pingers: Vec<PingerWrapper> = vec![
            PingerWrapper::new(SystemPinger, "ICMP"),
            PingerWrapper::new(TcpPinger::default(), "TCP"),
            PingerWrapper::new(ReqwestPinger::default(), "HTTP"),
        ];

        let writers: Vec<Box<dyn Writer>> = vec![
            Box::new(ConsoleWriter),
            Box::new(FileWriter::new(Path::new("combined.log")).unwrap()),
        ];
        check_and_report(sites, ReqwestPinger::new(), ConsoleWriter);
    }
}
