#[cfg(test)]
mod tests {
    use ipfilter::*;

    // Тесты для BlacklistFilter
    #[test]
    fn test_blacklist_1() {
        let blacklist = vec![IPv4::new(192, 168, 1, 1)];
        let filter = BlacklistFilter::new(blacklist);

        assert!(!filter.is_allowed(&IPv4::new(192, 168, 1, 1)));
        assert!(filter.is_allowed(&IPv4::new(192, 168, 1, 10)));
    }

    // Тесты для WhitelistFilter
    #[test]
    fn test_whitelist_1() {
        let whilelist = vec![IPv4::new(192, 168, 1, 1)];
        let filter = WhitelistFilter::new(whilelist);

        assert!(filter.is_allowed(&IPv4::new(192, 168, 1, 1)));
        assert!(!filter.is_allowed(&IPv4::new(192, 168, 1, 10)));
    }

    // Тесты для SubnetFilter
    #[test]
    fn test_subnet_filter() {
        // Подсеть 192.168.1.0/24 (маска 255.255.255.0)
        let subnet = IPv4::new(192, 168, 1, 0);
        let mask = IPv4::new(255, 255, 255, 0);
        let filter = SubnetFilter::new(subnet, mask);

        assert!(filter.is_allowed(&IPv4::new(192, 168, 1, 1)));
        assert!(!filter.is_allowed(&IPv4::new(192, 168, 2, 1)));
    }

    // Тесты для функции ip_vec_filter
    #[test]
    fn test_function_1() {
        let ips = vec![
            IPv4::new(10, 10, 10, 1),
            IPv4::new(204, 205, 6, 22),
            IPv4::new(192, 168, 1, 0),
        ];

        let blacklist = vec![IPv4::new(10, 0, 0, 1), IPv4::new(10, 0, 0, 2)];
        let filter = BlacklistFilter::new(blacklist);

        let filtered = ip_collection_filter(ips.clone(), &filter);

        assert_eq!(filtered, ips);
    }
}

