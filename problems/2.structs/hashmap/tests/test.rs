#[cfg(test)]
mod tests {
    use hashmap::*;

    #[test]
    fn test_put_and_get() {
        let mut map = HashMap::new();
        map.put("key1", 100);
        map.put("key2", 200);

        assert_eq!(map.get("key1"), Some(&100));
        assert_eq!(map.get("key2"), Some(&200));
        assert_eq!(map.get("key3"), None);
    }

    #[test]
    fn test_update_existing_key() {
        let mut map = HashMap::new();
        map.put("key", 123);
        map.put("key", 456);

        assert_eq!(map.get("key"), Some(&456));
    }

    #[test]
    fn test_delete_existing_key() {
        let mut map = HashMap::new();
        map.put("x", 10);
        assert_eq!(map.get("x"), Some(&10));

        let deleted = map.delete("x");
        assert_eq!(deleted, Some(10));
        assert_eq!(map.get("x"), None);
    }

    #[test]
    fn test_delete_non_existing_key() {
        let mut map = HashMap::new();
        map.put("a", 1);
        let deleted = map.delete("zzz");

        assert_eq!(deleted, None);
        assert_eq!(map.get("a"), Some(&1));
    }

    #[test]
    fn test_clear() {
        let mut map = HashMap::new();
        map.put("a", 1);
        map.put("b", 2);
        map.clear();

        assert_eq!(map.get("a"), None);
        assert_eq!(map.get("b"), None);
    }
}
