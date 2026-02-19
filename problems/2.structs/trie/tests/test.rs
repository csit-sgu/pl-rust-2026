#[cfg(test)]
mod tests {
    use trie::Trie;

    #[test]
    fn test_insert_and_search_existing_word() {
        let mut trie = Trie::new();
        trie.insert("hello");
        trie.insert("world");

        assert!(trie.search("hello"));
        assert!(trie.search("world"));
    }

    #[test]
    fn test_search_non_existing_word() {
        let mut trie = Trie::new();
        trie.insert("rust");
        trie.insert("rocks");

        assert!(!trie.search("rock"));
        assert!(!trie.search("rusty"));
        assert!(!trie.search("r"));
        assert!(!trie.search("ru"));
    }

    #[test]
    fn test_prefix_not_full_word() {
        let mut trie = Trie::new();
        trie.insert("cat");

        assert!(!trie.search("ca"));
        assert!(!trie.search("c"));
    }

    #[test]
    fn test_multiple_words_with_common_prefix() {
        let mut trie = Trie::new();
        trie.insert("car");
        trie.insert("cart");
        trie.insert("carbon");

        assert!(trie.search("car"));
        assert!(trie.search("cart"));
        assert!(trie.search("carbon"));
        assert!(!trie.search("cars"));
    }

    #[test]
    fn test_empty_string() {
        let mut trie = Trie::new();
        trie.insert("");
        assert!(trie.search(""));
    }
}
