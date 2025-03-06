//
//  ResetPasswordViewControllerTests.swift
//  Password
//
//  Created by yusheng Lu on 2025/3/6.
//

import XCTest
@testable import Password

final class ResetPasswordViewTests_UpdateResetButtonState: XCTestCase {

    var resetPasswordViewController: ResetPasswordViewController!
    var mockViewModel: MockResetPasswordViewModel!

    override func setUp() {
        super.setUp()
        resetPasswordViewController = ResetPasswordViewController()
        mockViewModel = MockResetPasswordViewModel()
        resetPasswordViewController.testableViewModel = mockViewModel
    }

    override func tearDown() {
        resetPasswordViewController = nil
        mockViewModel = nil
        super.tearDown()
    }

    func testUpdateResetButtonState_WhenButtonCanUse_ShouldEnableButton() {
        // 設置 mockViewModel 使按鈕可以啟用
        mockViewModel.isNewPasswordValid = true
        mockViewModel.arePasswordsMatching = true

        // 執行更新狀態的方法
        resetPasswordViewController.testableUpdateResetButtonState()

        // 驗證按鈕狀態
        XCTAssertTrue(resetPasswordViewController.testableResetButton.isEnabled)
        XCTAssertEqual(resetPasswordViewController.testableResetButton.backgroundColor, .systemBlue)
    }

    func testUpdateResetButtonState_WhenButtonCannotUse_ShouldDisableButton() {
        // 設置 mockViewModel 使按鈕無法啟用
        mockViewModel.isNewPasswordValid = false
        mockViewModel.arePasswordsMatching = false

        // 執行更新狀態的方法
        resetPasswordViewController.testableUpdateResetButtonState()

        // 驗證按鈕狀態
        XCTAssertFalse(resetPasswordViewController.testableResetButton.isEnabled)
        XCTAssertEqual(resetPasswordViewController.testableResetButton.backgroundColor, .systemGray)
    }
}

// Mock ViewModel
final class MockResetPasswordViewModel: ResetPasswordViewModel {
    var isNewPasswordValid: Bool = true
    var arePasswordsMatching: Bool = true

    override func isButtonCanUse() -> Bool {
        // 直接返回模擬的結果
        return isNewPasswordValid && arePasswordsMatching
    }
}

final class ResetPasswordViewTests_NewPasswordView: XCTestCase {
    var vc: ResetPasswordViewController!

    override func setUp() {
        super.setUp()
        vc = ResetPasswordViewController()
    }

    override func tearDown() {
        vc = nil
        super.tearDown()
    }

    func testEmptyPassword() {
        vc.testableNewPassword.passwordTextField.text = ""
        vc.testableTextFieldEndEditing(vc.testableNewPassword.passwordTextField)

        XCTAssertEqual(vc.testableNewPassword.errorMessageLabel.text, "Your password must meet the requirements below.")
        XCTAssertNotNil(vc.testableNewPassword.errorMessageLabel.text)
        XCTAssertFalse(vc.testableNewPassword.errorMessageLabel.text!.isEmpty)
    }
}

final class ResetPasswordViewTests_Alert: XCTestCase {
    var vc: ResetPasswordViewController!
    let validPassword = "123456Aa!"
    let tooShortPassword = "123Aa!"

    override func setUp() {
        super.setUp()
        vc = ResetPasswordViewController()
    }

    override func tearDown() {
        vc = nil
        super.tearDown()
    }

    func testShowSuccess() {
        vc.testableNewPassword.passwordTextField.text = validPassword
        vc.testableRepeatPassword.passwordTextField.text = validPassword
        vc.testableResetButtonTapped()

        XCTAssertNotNil(vc.testableAlert)
        XCTAssertEqual(vc.testableAlert?.title, "Success")
    }
}
