//
//  SignUpViewModel.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/31.
//

import Foundation
import UIKit

enum SignupCheck {
    var message: String {
        switch self {
        case .success:
            return ""
        case .imageEmpty:
            return "이미지를 등록해주세요"
        case .userNameEmpty:
            return "닉네임을 입력해주세요"
        case .userNameToLong:
            return "닉네임을 8글자 이하로 작성해주세요"
        case .emailEmpty:
            return "아이디를 입력해주세요"
        case .emailValid:
            return "이메일을 확인해주세요"
        case .passwordEmpty:
            return "비밀번호를 입력해주세요"
        case .passwordToShort:
            return "비밀번호를 8글자 이상으로 작성해주세요"
        case .confimePasswordEmpty:
            return "확인 비밀번호르 입력해주세요"
        case .passwordNotMatch:
            return "비밀번호가 일치하지않습니다"
        case .phoneNumberEmpty:
            return "전화번호를 입력해주세요"
        }
    }
    case success
    case imageEmpty
    case userNameEmpty
    case userNameToLong
    case emailEmpty
    case emailValid
    case passwordEmpty
    case passwordToShort
    case confimePasswordEmpty
    case passwordNotMatch
    case phoneNumberEmpty
}

enum SignUpStep {
    case userName
    case email
    case password
    case confimePassword
    case PhoneNumber
}

final class SignUpViewModel {
 
    static let shared: SignUpViewModel = SignUpViewModel()
    
    init(
        imageUploaderService: ImageUploaderServiceProtocol = ImageUploaderService(),
        signUpService: SignUpServiceProtocol = SignUpService()
    ) {
        self.imageUploaderService = imageUploaderService
        self.signUpService = signUpService
    }
    
    var model = SignUpModel.EMPTY
    
    var imageUploaderService: ImageUploaderServiceProtocol
    var signUpService: SignUpServiceProtocol
    
    var is14YearsOld: Observer<Bool> = Observer(value: false)
    var isAgreeService: Observer<Bool> = Observer(value: false)
    var isAgreeLocationService: Observer<Bool> = Observer(value: false)
    var isAgreePrivacyInformation: Observer<Bool> = Observer(value: false)
    var isAgreePrivacyThirdPartyInformation: Observer<Bool> = Observer(value: false)
    var isAgreeMarketingReceive: Observer<Bool> = Observer(value: false)
    
    var phoneNumberAuthSuccess: Observer<Bool> = Observer(value: false)
    
    var signUpStep: SignUpStep = .userName
    var signupCheck: Observer<SignupCheck> = Observer(value: .imageEmpty)
    var sendSuccess: Observer<Bool> = Observer(value: false)
    var signUpError: Observer<SigunUpError> = Observer(value: .upLoadFireStoreError)
    var signUpEnd: Observer<Bool> = Observer(value: false)
    
    var imageUploadSuccess: Observer<Bool> = Observer(value: false)
    var imageUploadError: Observer<ImageUploaderError> = Observer(value: .uploadImageFaildError)
    

}

extension SignUpViewModel {
    
    func profileImageUpload() {
        imageUploaderService.uploadImage(
            fileName: "프로필이미지",
            imageData: model.imageData!) { [weak self] result in
                switch result {
                case .success(let url):
                    self?.model.profileImageURL = url
                    self?.imageUploadSuccess.value = true
                case .failure(let error):
                    self?.imageUploadError.value = error
                }
            }
    }
    func isProfileImageEmpty() {
       if self.model.imageData == nil {
           signupCheck.value = .imageEmpty
       } else {
           signupCheck.value = .success
       }
    }
    func textFieldEmptyVaild(text: String) {
            if text == "" {
                switch signUpStep {
                case .userName:
                    signupCheck.value = .userNameEmpty
                case .email:
                    signupCheck.value = .emailEmpty
                case .password:
                    signupCheck.value = .passwordEmpty
                case .confimePassword:
                    signupCheck.value = .confimePasswordEmpty
                case .PhoneNumber:
                    signupCheck.value = .phoneNumberEmpty
                }
            } else {
                switch signUpStep {
                case .userName:
                    userNameToLongValid(text: text)
                case .email:
                    emailValidCheck(email: text)
                case .password:
                    passwordToShortValid(password: text)
                case .confimePassword:
                    confirmPasswordValid(confirmPassword: text)
                case .PhoneNumber:
                    phoneNumberConverting(phoneNumber: text)
                }
            }
    }
    func userNameToLongValid(text: String) {
        if text.count < 9 {
            signupCheck.value = .success
            model.userName = text
        } else {
            signupCheck.value = .userNameToLong
        }
    }
    func emailValidCheck(email: String) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            model.email = email
            signupCheck.value = .success
        } else {
            signupCheck.value = .emailValid
        }
    }
    func passwordToShortValid(password: String) {
        if password.count > 7 {
            model.password = password
            signupCheck.value = .success
        } else {
            signupCheck.value = .passwordToShort
        }
    }
    func confirmPasswordValid(confirmPassword: String) {
        if confirmPassword == model.password {
            model.confirmPssword = confirmPassword
            signupCheck.value = .success
        } else {
            signupCheck.value = .passwordNotMatch
        }
    }
    func phoneNumberConverting(phoneNumber: String) {
        if phoneNumber.count >= 10 {
      var convertPhoneNumber = phoneNumber
        convertPhoneNumber.removeFirst()
        convertPhoneNumber.insert(
            "-", at: convertPhoneNumber.index(convertPhoneNumber.startIndex, offsetBy: 2)
        )
        convertPhoneNumber.insert(
            "-", at: convertPhoneNumber.index(convertPhoneNumber.startIndex, offsetBy: 7)
        )
            model.phoneNumber = "+82 \(convertPhoneNumber)"
            signupCheck.value = .success
        }
    }
    func phoneNumberAuth() {
        signUpService.phoneAuth(phoneNumber: model.phoneNumber) { [weak self] result in
            switch result {
            case .success(let id):
                self?.model.verificationCode = id
                self?.sendSuccess.value = true
            case .failure(let error):
                self?.signUpError.value = error
            }
        }
    }
    func phoneNumberAuthValid(code: String) {
        signUpService.credentialAuth(
            verificationID: self.model.verificationCode,
            verificationcode: code) { [weak self] result in
                switch result {
                case .success(let bool):
                    self?.phoneNumberAuthSuccess.value = bool
                case .failure(let error):
                    self?.signUpError.value = error
                }
            }
    }
    func requiredAgreedValid() -> Bool {
        if is14YearsOld.value &&
            isAgreeService.value &&
            isAgreeLocationService.value &&
            isAgreePrivacyInformation.value &&
            isAgreePrivacyThirdPartyInformation.value {
            return true
        } else {
            return false
        }
    }
    func signUpUser() {
        self.model.is14YearsOld = self.is14YearsOld.value
        self.model.isAgreeService = self.isAgreeService.value
        self.model.isAgreeLocationService = self.isAgreeLocationService.value
        self.model.isAgreePrivacyInformation = self.isAgreePrivacyInformation.value
        self.model.isAgreePrivacyThirdPartyInformation = self.isAgreePrivacyThirdPartyInformation.value
        self.model.isAgreeMarketingReceive = self.isAgreeMarketingReceive.value
        signUpService.signUp(model: model) { [weak self] result in
            switch result {
            case .success():
                self?.signUpEnd.value = true
            case .failure(let error):
                self?.signUpError.value = error
            }
        }
    }
}
