#[cfg(test)]
mod tests {
    use validator::*;

    #[test]
    fn test_phone_number_1() {
        let valid_phone = PhoneNumber::new("+123456789".to_string());
        assert!(valid_phone.validate());
    }

    #[test]
    fn test_password_1() {
        let valid_password = Password::new("Password123!".to_string());
        assert!(valid_password.validate());
    }

    #[test]
    fn test_email_1() {
        let invalid_email = Email::new("user-example@abobaka.com".to_string());
        assert!(invalid_email.validate());
    }

    #[test]
    fn test_function_1() {
        let phone1 = PhoneNumber::new("+123456789".to_string());
        let bad_phone1 = PhoneNumber::new("123456789".to_string());
        let bad_phone2 = PhoneNumber::new("Password123!".to_string());
        let bad_phone3 = PhoneNumber::new("+11111111111111111111".to_string());

        let items: Vec<PhoneNumber> = vec![phone1, bad_phone1, bad_phone2, bad_phone3];
        let ans = &items.clone()[1..4];
        let res = remove_valid(items);

        assert_eq!(res, ans);
    }
}

