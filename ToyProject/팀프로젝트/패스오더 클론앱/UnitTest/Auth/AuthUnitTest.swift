//
//  UnitTest.swift
//  UnitTest
//
//  Created by 정덕호 on 2022/05/30.
//

import XCTest
@testable import Project_ClonePassOrder

class AuthUnitTest: XCTestCase {
    
    var sut: AuthViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AuthViewModel()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_UserLogin함수_호출시_email이_비어있는경우_textfieldEmpty에_emailEpty가_전달되는지() {
        //given
        let email = ""
        let password = "123456789"
        
        //when
        sut.userLogin(email: email, password: password)
        
        //then
        XCTAssertEqual(sut.textfildEmpty.value, .emailEmpty)
    }
    func test_UserLogin함수_호출시_password가_비어있는경우_textfieldEmpty에_passwordEpty가_전달되는지() {
        //given
        let email = "aoao1216@naver.com"
        let password = ""
        
        //when
        sut.userLogin(email: email, password: password)
        
        //then
        XCTAssertEqual(sut.textfildEmpty.value, .passwordEmpty)
    }
    func test_UserLogin함수_호출시_email과_password모두_비어있지않은경우_model에_email과_password가_전달되는지() {
        //given
        let email = "aoao1216@naver.com"
        let password = "123123123"
        
        //when
        sut.userLogin(email: email, password: password)
        
        //then
        XCTAssertEqual(sut.model.email, email)
        XCTAssertEqual(sut.model.password, password)
        
    }
    func test_UserLogin함수_호출시_email과_password_모두_비어있지않은경우_loginStart에_로딩중입니다_문자열이_전달되는지() {
        //given
        let email = "aoao1216@naver.com"
        let password = "123123123"
        
        //when
        sut.userLogin(email: email, password: password)
        
        //then
        XCTAssertEqual(sut.loginStart.value, "로딩중입니다...")
    }
    func test_login함수_호출시_로그인에_실패하는경우_loginFaildError인경우_authError에_전달되는지() {
        //given
        var mockService = MockAuthService()
        mockService.result = .failure(.loginFaildError)
        sut.service = mockService
        
        //when
        sut.login()
        
        //then
        XCTAssertEqual(sut.authError.value, .loginFaildError)
    }
    func test_login함수_호출시_로그인정보를_받아오는것에_실패하는경우_authResultNilError인경우_authError에_전달되는지() {
        //given
        var mockService = MockAuthService()
        mockService.result = .failure(.authResultNilError)
        sut.service = mockService
        
        //when
        sut.login()
        
        //then
        XCTAssertEqual(sut.authError.value, .authResultNilError)
    }
    func test_login함수_호출시_성공하는경우_loginSuccess_에_true가_전달되는지() {
        //given
        var mockService = MockAuthService()
        mockService.result = .success(())
        sut.service = mockService
        
        //when
        sut.login()
        
        //then
        XCTAssertTrue(sut.loginSuccess.value)
    }
    func test_logout함수_호출시_로그아웃에_실패하는경우_authError에_logoutFaildError가_전달되는지() {
        //given
        var mockService = MockAuthService()
        mockService.result = .failure(.logoutFaildError)
        sut.service = mockService
        
        //when
        sut.logout()
        
        //then
        XCTAssertEqual(sut.authError.value, .logoutFaildError)
    }
    func test_logout함수_호출시_성공하는경우_logoutSuccess_에_true가_전달되는지() {
        //given
        var mockService = MockAuthService()
        mockService.result = .success(())
        sut.service = mockService
        
        //when
        sut.logout()
        
        //then
        XCTAssertTrue(sut.logoutSuccess.value)
    }
}
