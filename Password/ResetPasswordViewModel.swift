//
//  ResetPasswordViewModel.swift
//  Password
//
//  Created by yusheng Lu on 2025/2/21.
//

class ResetPasswordViewModel {
    private static var isNewPasswordValid: Bool = false
    private static var arePasswordsMatching:Bool = false

    static func validateLengthAndNoSpaces(_ password: String) -> Bool {
        return password.count >= 8 && password.count <= 32 && !password.contains(" ")
    }

    static func containsUppercaseLetter(_ password: String) -> Bool {
        return password.range(of: "[A-Z]", options: .regularExpression) != nil
    }

    static func containsLowercaseLetter(_ password: String) -> Bool {
        return password.range(of: "[a-z]", options: .regularExpression) != nil
    }

    static func containsDigit(_ password: String) -> Bool {
        return password.range(of: "\\d", options: .regularExpression) != nil
    }

    static func containsSpecialCharacter(_ password: String) -> Bool {
        return password.range(of: "[!@#$%^]", options: .regularExpression) != nil
    }

    static func validatePassword(_ password: String) -> [Bool] {
        return [
            validateLengthAndNoSpaces(password),
            containsUppercaseLetter(password),
            containsLowercaseLetter(password),
            containsDigit(password),
            containsSpecialCharacter(password)
        ]
    }

    static func validatePasswords(newPassword: String, repeatPassword: String) {
        // 驗證新密碼規則
        let isPasswordValid = validatePassword(newPassword).allSatisfy { $0 }
        let areMatching = newPassword == repeatPassword

        // 同步更新狀態
        self.isNewPasswordValid = isPasswordValid
        self.arePasswordsMatching = areMatching
    }

    static func isButtonCanUse() -> Bool {
        return isNewPasswordValid && arePasswordsMatching
    }
}
