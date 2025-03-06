//
//  ResetPasswordViewModelTests.swift
//  Password
//
//  Created by yusheng Lu on 2025/3/5.
//

import XCTest

@testable import Password

final class ResetPasswordViewModelTests: XCTestCase {
    var viewModel: ResetPasswordViewModel!

    override func setUp() {
        super.setUp()
        // 創建 ResetPasswordViewModel 的實例
        viewModel = ResetPasswordViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testValidateLengthAndNoSpaces() {
        // 測試正確的密碼（符合長度且無空格）
        XCTAssertTrue(viewModel.validateLengthAndNoSpaces("Abcd1234"))
        XCTAssertTrue(viewModel.validateLengthAndNoSpaces("LongPassword1234567890123"))

        // 測試太短的密碼（少於 8 個字）
        XCTAssertFalse(viewModel.validateLengthAndNoSpaces("1234567"))

        // 測試太長的密碼（多於 32 個字）
        XCTAssertFalse(viewModel.validateLengthAndNoSpaces("A123456789012345678901234567890123"))

        // 測試密碼內有空格
        XCTAssertFalse(viewModel.validateLengthAndNoSpaces("A bc12345"))
        XCTAssertFalse(viewModel.validateLengthAndNoSpaces("Password With Space"))
    }

    func testShort() throws {
        XCTAssertFalse(viewModel.validateLengthAndNoSpaces("1234567"))
    }

    func testLong() throws {
        XCTAssertFalse(viewModel.validateLengthAndNoSpaces("123456789012345678901234567890123"))
    }

    func testValidShort() throws {
        XCTAssertTrue(viewModel.validateLengthAndNoSpaces("12345678"))
    }

    func testValidLong() throws {
        XCTAssertTrue(viewModel.validateLengthAndNoSpaces("12345678901234567890123456789012"))
    }

    func testContainsUppercaseLetter() {
        XCTAssertTrue(viewModel.containsUppercaseLetter("Hello"), "Should return true for string containing uppercase letter")
        XCTAssertTrue(viewModel.containsUppercaseLetter("HELLO"), "Should return true for string with all uppercase letters")
        XCTAssertFalse(viewModel.containsUppercaseLetter("hello"), "Should return false for string with no uppercase letters")
        XCTAssertFalse(viewModel.containsUppercaseLetter("123456"), "Should return false for numeric string")
        XCTAssertFalse(viewModel.containsUppercaseLetter("!@#$%^&*"), "Should return false for special characters only")
        XCTAssertTrue(viewModel.containsUppercaseLetter("hEllo123"), "Should return true for mixed alphanumeric with uppercase")
    }
}

final class ValidatePasswordTests: XCTestCase {
    var viewModel: ResetPasswordViewModel!

    override func setUp() {
        super.setUp()
        // 創建 ResetPasswordViewModel 的實例
        viewModel = ResetPasswordViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testValidatePassword_AllValid() {
        let password = "Valid123!"
        let result = viewModel.validatePassword(password)
        XCTAssertEqual(result, [true, true, true, true, true])
    }

    func testValidatePassword_MissingUppercase() {
        let password = "valid123!"
        let result = viewModel.validatePassword(password)
        XCTAssertEqual(result, [true, false, true, true, true])
    }

    func testValidatePassword_MissingLowercase() {
        let password = "VALID123!"
        let result = viewModel.validatePassword(password)
        XCTAssertEqual(result, [true, true, false, true, true])
    }

    func testValidatePassword_MissingDigit() {
        let password = "ValidOnly!"
        let result = viewModel.validatePassword(password)
        XCTAssertEqual(result, [true, true, true, false, true])
    }

    func testValidatePassword_MissingSpecialCharacter() {
        let password = "Valid1234"
        let result = viewModel.validatePassword(password)
        XCTAssertEqual(result, [true, true, true, true, false])
    }

    func testValidatePassword_TooShort() {
        let password = "Va1!"
        let result = viewModel.validatePassword(password)
        XCTAssertEqual(result, [false, true, true, true, true])
    }

    func testValidatePassword_TooLong() {
        let password = String(repeating: "A", count: 33) + "1a!"
        let result = viewModel.validatePassword(password)
        XCTAssertEqual(result, [false, true, true, true, true])
    }

    func testValidatePassword_ContainsSpace() {
        let password = "Valid 123!"
        let result = viewModel.validatePassword(password)
        XCTAssertEqual(result, [false, true, true, true, true])
    }
}
