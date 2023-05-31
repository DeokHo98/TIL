//
//  SignUpUnitTest.swift
//  UnitTest
//
//  Created by 정덕호 on 2022/05/31.
//

import XCTest
@testable import Project_ClonePassOrder

class SignUpUnitTest: XCTestCase {
    
    var sut: SignUpViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SignUpViewModel()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_profileImageUpload_호출시_이미지업로드를_실패하는경우_uploadImageFaildError_발생시_imageUploadError에_전달되는지() {
        //given
        var mockService = MockImageUploaderService()
        mockService.result = .failure(.uploadImageFaildError)
        sut.imageUploaderService = mockService
        sut.model.imageData = Data()
        
        //when
        sut.profileImageUpload()
        
        //then
        XCTAssertEqual(sut.imageUploadError.value, .uploadImageFaildError)
    }
    func test_profileImageUpload_호출시_URL변환에_실패하는경우_URLError_발생시_imageUploadError에_전달되는지() {
        //given
        var mockService = MockImageUploaderService()
        mockService.result = .failure(.URLError)
        sut.imageUploaderService = mockService
        sut.model.imageData = Data()
        
        //when
        sut.profileImageUpload()
        
        //then
        XCTAssertEqual(sut.imageUploadError.value, .URLError)
    }
    func test_profileImageUpload_호출시_이미지다운로드에_실패하는경우_downLoadImageFaildError_발생시_imageUploadError에_전달되는지() {
        //given
        var mockService = MockImageUploaderService()
        mockService.result = .failure(.downLoadImageFaildError)
        sut.imageUploaderService = mockService
        sut.model.imageData = Data()
        
        //when
        sut.profileImageUpload()
        
        //then
        XCTAssertEqual(sut.imageUploadError.value, .downLoadImageFaildError)
    }
    func test_profileImageUpload_호출시_성공하는경우_model의_profildImageURL에_url값이_들어가는지() {
        //given
        var mockService = MockImageUploaderService()
        mockService.result = .success("imageurl")
        sut.imageUploaderService = mockService
        sut.model.imageData = Data()
        
        //when
        sut.profileImageUpload()
        
        //then
        XCTAssertEqual(sut.model.profileImageURL,"imageurl")
    }
    func test_profileImageUpload_호출시_성공하는경우_imageUploadSuccess에_true가_전달되는지() {
        //given
        var mockService = MockImageUploaderService()
        mockService.result = .success("imageurl")
        sut.imageUploaderService = mockService
        sut.model.imageData = Data()
        
        //when
        sut.profileImageUpload()
        
        //then
        XCTAssertTrue(sut.imageUploadSuccess.value)
    }
    func test_isProfildImageEmpty_호출시_model의_imageData가_nil인경우_signupCheck에_imageEmpty를_전달하는지() {
        //given
        let data: Data? = nil
        sut.model.imageData = data
        
        //when
        sut.isProfileImageEmpty()
        
        //then
        XCTAssertEqual(sut.signupCheck.value, .imageEmpty)
    }
    func test_isProfildImageEmpty_호출시_model의_imageData가_nil이아닌경우_signupCheck에_success를_전달하는지() {
        //given
        let data: Data = Data()
        sut.model.imageData = data
        
        //when
        sut.isProfileImageEmpty()
        
        //then
        XCTAssertEqual(sut.signupCheck.value, .success)
    }
    func test_userNameToLongValid_호출시_text가_9글자보다_작은경우_model의_userName에_전달되고_signupCheck에_success를_전달하는지() {
        //given
        let text = "한별"
        
        //when
        sut.userNameToLongValid(text: text)
        
        //then
        XCTAssertEqual(sut.model.userName, text)
        XCTAssertEqual(sut.signupCheck.value, .success)
    }
    func test_userNameToLongValid_호출시_text가_9글자보다_클경우_signupCheck에_userNameToLong이_전달되는지() {
        //given
        let text = "한별한별한별한별한별한별"
        
        //when
        sut.userNameToLongValid(text: text)
        
        //then
        XCTAssertEqual(sut.signupCheck.value, .userNameToLong)
    }
    func test_emailValidCheck_호출시_email이_형식에맞는경우_model의_email에_전달되고_signupCheck에_success가_전달되는지() {
        //given
        let email = "test@naver.com"
        
        //when
        sut.emailValidCheck(email: email)
        
        XCTAssertEqual(sut.model.email, email)
        XCTAssertEqual(sut.signupCheck.value, .success)
    }
    func test_emailValidCheck_호출시_email이_형식에맞지않는경우_signupCheck에_emailValid가_전달되는지() {
        //given
        let email = "testtestetst"
        
        //when
        sut.emailValidCheck(email: email)
        
        XCTAssertEqual(sut.signupCheck.value, .emailValid)
    }
    func test_passwordToShortValid_호출시_password가_8자리이상인경우_model의_password에_전달되고_signupCheck에_success가_전달되는지() {
        //given
        let password = "123123123"
        
        //when
        sut.passwordToShortValid(password: password)
        
        //then
        XCTAssertEqual(sut.model.password, password)
        XCTAssertEqual(sut.signupCheck.value, .success)
    }
    func test_passwordToShortValid_호출시_password가_8자리이하인경우_signupCheck에_passwrodToShort가_전달되는지() {
        //given
        let password = "123"
        
        //when
        sut.passwordToShortValid(password: password)
        
        //then
        XCTAssertEqual(sut.signupCheck.value, .passwordToShort)
    }
    func test_confirmPasswordValid_호출시_confirmPassword가_model의_password와_같은경우_model의_confirmPassword에_전달되고_signupCheck에_success가_전달되는지() {
        //given
        let confirmPassword = "123123123"
        sut.model.password = "123123123"
        
        //when
        sut.confirmPasswordValid(confirmPassword: confirmPassword)
        
        //then
        XCTAssertEqual(sut.model.confirmPssword, confirmPassword)
        XCTAssertEqual(sut.signupCheck.value, .success)
    }
    func test_confirmPasswordValid_호출시_confrimPassword가_model의_passwrod와_다른경우_signupCheck에_passwordNotMatch가_전달되는지() {
        //given
        let confirmPassword = "456456456"
        sut.model.password = "123123123"
        
        //when
        sut.confirmPasswordValid(confirmPassword: confirmPassword)
        
        //then
        XCTAssertEqual(sut.signupCheck.value, .passwordNotMatch)
    }
    func test_phoneNumberConverting_호출시_phoneNumber의_count가_10과같거나_크다면_인증전화번호형태로_바뀌어_model에_전달되고_signupCheck에_success가_전달되는지() {
        //given
        let phoneNumber = "01012341234"
        
        //when
        sut.phoneNumberConverting(phoneNumber: phoneNumber
        )
        
        //then
        XCTAssertEqual(sut.model.phoneNumber, "+82 10-1234-1234")
        XCTAssertEqual(sut.signupCheck.value, .success)
    }
    func test_phoneNumberAuth_호출시_성공하는경우_인증코드가_model의_verificationCode에_전달되고_sendSuccess에_true가_전달되는지() {
        //given
        var mockService = MockSignUpService()
        mockService.phoneAuthResult = .success("123123")
        sut.signUpService = mockService
        sut.model.phoneNumber = "+82 10-1234-1234"
        
        //when
        sut.phoneNumberAuth()
        
        //then
        XCTAssertEqual(sut.model.verificationCode, "123123")
        XCTAssertTrue(sut.sendSuccess.value)
    }
    func test_phoneNumberAuth_호출시_전화번호가유효하지않아_실패하는경우_전달된에러가_phoneNumberAuthError인경우_signupError에_전달되는지() {
        //given
        var mockService = MockSignUpService()
        mockService.phoneAuthResult = .failure(.phoneNumberAuthError)
        sut.signUpService = mockService
        
        //when
        sut.phoneNumberAuth()
        
        //then
        XCTAssertEqual(sut.signUpError.value, .phoneNumberAuthError)
    }
    func test_phoneNumberAuth_호출시_인증번호전송에_실패하는경우_전달된에러가_verificationResultNillError인경우_signupError에_전달되는지() {
        //given
        var mockService = MockSignUpService()
        mockService.phoneAuthResult = .failure(.verificationResultNillError)
        sut.signUpService = mockService
        
        //when
        sut.phoneNumberAuth()
        
        //then
        XCTAssertEqual(sut.signUpError.value, .verificationResultNillError)
    }
    func test_phoneNumberAuthValid_호출시_성공하는경우_phoneNumberAuthSuccess에_true가_전달되는지() {
        //given
        var mockService = MockSignUpService()
        mockService.credentialAuthResult = .success(true)
        sut.signUpService = mockService
        
        //when
        sut.phoneNumberAuthValid(code: "123123")
        
        //then
        XCTAssertTrue(sut.phoneNumberAuthSuccess.value)
    }
    func test_phoneNumberAuthValid_호출시_인증번호와_일치하지않아_실패하는경우_전달된에러가_verificationCodeAuthError_인경우_signUpError에_전달되는지() {
        //given
        var mockService = MockSignUpService()
        mockService.credentialAuthResult = .failure(.verificationCodeAuthError)
        sut.signUpService = mockService
        
        //when
        sut.phoneNumberAuthValid(code: "123123")
        
        //then
        XCTAssertEqual(sut.signUpError.value, .verificationCodeAuthError)
    }
    func test_phoneNumberAuthValid_호출시_결과값이없어_실패하는경우_전달된에러가_verificationResultNillError_인경우_signUpError에_전달되는지() {
        //given
        var mockService = MockSignUpService()
        mockService.credentialAuthResult = .failure(.verificationResultNillError)
        sut.signUpService = mockService
        
        //when
        sut.phoneNumberAuthValid(code: "123123")
        
        //then
        XCTAssertEqual(sut.signUpError.value, .verificationResultNillError)
    }
    func test_requiredAgreedValid_호출시_필수약관이_모두동의되어있는경우_true를_리턴하는지() {
        //given
        sut.is14YearsOld.value = true
        sut.isAgreeService.value = true
        sut.isAgreeLocationService.value = true
        sut.isAgreePrivacyInformation.value = true
        sut.isAgreePrivacyThirdPartyInformation.value = true
        
        //when
        let valid = sut.requiredAgreedValid()
        
        //then
        XCTAssertTrue(valid)
    }
    func test_signUpUser_호출시_성공하는경우_signupEnd에_true가_전달되는지() {
        //given
        var mockService = MockSignUpService()
        mockService.result = .success(())
        sut.signUpService = mockService
        
        //when
        sut.signUpUser()
        
        //then
        XCTAssertEqual(sut.signUpEnd.value, true)
    }
    func test_signUpUser_호출시_회원가입에_실패시_signUpFaildError를_전달하는경우_signUpError에_전달되는지() {
        //given
        var mockService = MockSignUpService()
        mockService.result = .failure(.signUpFaildError)
        sut.signUpService = mockService
        
        //when
        sut.signUpUser()
        
        //then
        XCTAssertEqual(sut.signUpError.value, .signUpFaildError)
    }
    func test_signUpUser_호출시_회원가입결과가없어_실패하는경우_resultNillError를_전달하는경우_signUpError에_전달되는지() {
        //given
        var mockService = MockSignUpService()
        mockService.result = .failure(.resultNillError)
        sut.signUpService = mockService
        
        //when
        sut.signUpUser()
        
        //then
        XCTAssertEqual(sut.signUpError.value, .resultNillError)
    }
    func test_signUpUser_호출시_회원가입후User데이터를받아오는것에_실패하는경우_upLoadFireStoreError를_전달하는경우_signUpError에_전달되는지() {
        //given
        var mockService = MockSignUpService()
        mockService.result = .failure(.upLoadFireStoreError)
        sut.signUpService = mockService
        
        //when
        sut.signUpUser()
        
        //then
        XCTAssertEqual(sut.signUpError.value, .upLoadFireStoreError)
    }
    
}
