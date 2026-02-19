#[cfg(test)]
mod tests {
    use logger::*;

    #[test]
    fn test_console_1() {
        let logger = ConsoleLogger;
        logger.info("Test message");
        logger.debug("Debugging debug");
        logger.warn("High temp");
        logger.error("Null pointer dereference");
        logger.fatal("Я упаль");
    }

    #[test]
    fn test_file_1() {
        let logger = FileLogger::new("testfile.txt");
        logger.info("Test message");
        logger.debug("Debugging debug");
        logger.warn("High temp");
        logger.error("Null pointer dereference");
        logger.fatal("Я упаль");
        // здесь Вы можете самостоятельно реализовать проверку файла
    }

    #[test]
    fn test_function_1() {
        let logger = ConsoleLogger;
        let numbers = vec![5, 5, 7, -1, 0, 222, 222, 222, 777, 329, -1406, -1406];

        process_vector(&numbers, &logger)
    }
}

