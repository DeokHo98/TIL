//
//  IntegrationUITest.swift
//  IntegrationUITest
//
//  Created by 정덕호 on 2022/05/30.
//

import XCTest
@testable import Project_ClonePassOrder

class IntegrationUITest: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
       try super.setUpWithError()
        app = XCUIApplication()
        app.launchArguments.append("LoginAndSignUpUITesting")
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app = nil
    }
    
    func test_로그인에_성공하는경우_tabBarController로이동하여_성공하는경우_listCollectionView가_보이는지() {
        let staticText = app/*@START_MENU_TOKEN@*/.staticTexts[" 이메일로 로그인"]/*[[".buttons[\" 이메일로 로그인\"].staticTexts[\" 이메일로 로그인\"]",".staticTexts[\" 이메일로 로그인\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        staticText.tap()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let textField = element.children(matching: .textField).element
        textField.tap()
        textField.typeText("aoao1216@naver.com")
        let secureTextField = element.children(matching: .secureTextField).element
        secureTextField.tap()
        secureTextField.typeText("123123123")
        app.buttons[" 이메일로 로그인"].tap()
        let verticalScrollBar4PagesCollectionView = app.collectionViews.containing(.other, identifier:"Vertical scroll bar, 4 pages").element
        XCTAssert(verticalScrollBar4PagesCollectionView.waitForExistence(timeout: 5))
    }
    func test_로그인에성공한후_다시로그아웃을했을때_loginViewController로_돌아와_이메일로로그인버튼이보이는지() {
        let staticText = app/*@START_MENU_TOKEN@*/.staticTexts[" 이메일로 로그인"]/*[[".buttons[\" 이메일로 로그인\"].staticTexts[\" 이메일로 로그인\"]",".staticTexts[\" 이메일로 로그인\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        staticText.tap()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let textField = element.children(matching: .textField).element
        textField.tap()
        textField.typeText("aoao1216@naver.com")
        let secureTextField = element.children(matching: .secureTextField).element
        secureTextField.tap()
        secureTextField.typeText("123123123")
        app.buttons[" 이메일로 로그인"].tap()
        sleep(2)
        app.tabBars["Tab Bar"].buttons["마이패써"].tap()
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:"🔎   자주 묻는 질문").element.swipeUp()
        tablesQuery.cells.containing(.staticText, identifier:"🚪   로그아웃").element.tap()
        XCTAssert(staticText.waitForExistence(timeout: 3))
    }
    func test_회원가입을_모두성공하는경우_listCollectionView가_보이는지() {

        app/*@START_MENU_TOKEN@*/.staticTexts["이메일로 회원가입하기"]/*[[".buttons[\"이메일로 회원가입하기\"].staticTexts[\"이메일로 회원가입하기\"]",".staticTexts[\"이메일로 회원가입하기\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons.element(boundBy: 1).tap()
        sleep(2)
        app.images.element(boundBy: 1).tap()
        sleep(2)
        app.buttons["Choose"].tap()
        sleep(2)
        app/*@START_MENU_TOKEN@*/.staticTexts["다음  "]/*[[".buttons[\"다음  \"].staticTexts[\"다음  \"]",".staticTexts[\"다음  \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.textFields["8글자 이하로 작성해주세요"].tap()
        app.textFields["8글자 이하로 작성해주세요"].typeText("가나다라")
        let staticText = app/*@START_MENU_TOKEN@*/.staticTexts["다음  "]/*[[".buttons[\"다음  \"].staticTexts[\"다음  \"]",".staticTexts[\"다음  \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        staticText.tap()
        app.textFields["passorder@naver.com"].tap()
        app.textFields["passorder@naver.com"].typeText("wjdejrgh98@naver.com")
        staticText.tap()
        app.secureTextFields["8글자 이상으로 작성해주세요"].tap()
        app.secureTextFields["8글자 이상으로 작성해주세요"].typeText("123123123")
        staticText.tap()
        app.secureTextFields["비밀번호를 한번더 입력해주세요"].tap()
        app.secureTextFields["비밀번호를 한번더 입력해주세요"].typeText("123123123")
        staticText.tap()
        app.textFields["- 빼고 입력해주세요"].tap()
        app.textFields["- 빼고 입력해주세요"].typeText("01012341234")
        app/*@START_MENU_TOKEN@*/.staticTexts["확인"]/*[[".buttons[\"확인\"].staticTexts[\"확인\"]",".staticTexts[\"확인\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(staticText.waitForExistence(timeout: 10))
        app.textFields["인증번호 6자리 입력"].tap()
        app.textFields["인증번호 6자리 입력"].typeText("123123")
        XCTAssert(staticText.waitForExistence(timeout: 10))
        staticText.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["  모든 약관에 동의합니다."]/*[[".buttons[\"  모든 약관에 동의합니다.\"].staticTexts[\"  모든 약관에 동의합니다.\"]",".staticTexts[\"  모든 약관에 동의합니다.\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["완료"]/*[[".buttons[\"완료\"].staticTexts[\"완료\"]",".staticTexts[\"완료\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.collectionViews.containing(.other, identifier:"Vertical scroll bar, 4 pages").element.waitForExistence(timeout: 10))
    }
}

