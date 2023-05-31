//
//  UserUnitTest.swift
//  UnitTest
//
//  Created by 정덕호 on 2022/06/01.
//

import XCTest
@testable import Project_ClonePassOrder

class UserUnitTest: XCTestCase {
    
    var sut: UserViewModel!

    override func setUpWithError() throws {
       try super.setUpWithError()
        sut = UserViewModel()
    }

    override func tearDownWithError() throws {
       try super.tearDownWithError()
        sut = nil
    }
    
    func test_model의_데이터가_원하는형태로_viewModel의_변수에_담기는지() {
        //given
        let model = UserModel(userName: "test", email: "test@naver.com", profileImageUrl: "testimageurl")
        let url = URL(string: model.profileImageUrl)
        sut.model = model
        
        //then
        XCTAssertEqual(sut.userName, "test")
        XCTAssertEqual(sut.profileImageUrl, url)
    }
    func test_userFetch_호출시_성공하는경우_전달되는_model이_ViewModel의_model에_전달되는지() {
        //given
        let model = UserModel(userName: "test", email: "test@naver.com", profileImageUrl: "testimageurl")
        var mockService = MockUserService()
        mockService.result = .success(model)
        sut.userService = mockService
        
        //when
        sut.userFetch()
        
        //then
        XCTAssertEqual(sut.model, model)
    }
    func test_userFetch_호출시_유저정보가없어_실패하는경우_currentUserNillError가_userServiceError에_전달되는지() {
        //given
        var mockService = MockUserService()
        mockService.result = .failure(.currentUserNillError)
        sut.userService = mockService
        
        //when
        sut.userFetch()
        
        //then
        XCTAssertEqual(sut.userServiceError.value, .currentUserNillError)
    }
    func test_userFetch_호출시_파이어스토어에서_현재유저정보와_일치하는유저정보를_받아오는것에_실패하는경우_userFetchError가_userServiceError에_전달되는지() {
        //given
        var mockService = MockUserService()
        mockService.result = .failure(.userFetchError)
        sut.userService = mockService
        
        //when
        sut.userFetch()
        
        //then
        XCTAssertEqual(sut.userServiceError.value, .userFetchError)
    }
    func test_userFetch_호출시_snapShot을_가져오는것에_실패하는경우_snapShotError가_userServiceError에_전달되는지() {
        //given
        var mockService = MockUserService()
        mockService.result = .failure(.snapShotError)
        sut.userService = mockService
        
        //when
        sut.userFetch()
        
        //then
        XCTAssertEqual(sut.userServiceError.value, .snapShotError)
    }


}
