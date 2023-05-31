//
//  AuthViewModel.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/30.
//

import Foundation

enum EmptyTextField {
    var emptyMessage: String {
        switch self {
        case .emailEmpty:
            return "아이디를 입력해주세요!"
        case .passwordEmpty:
            return "비밀번호를 입력해주세요"
        }
    }
    case emailEmpty
    case passwordEmpty
}

final class AuthViewModel {
    
    init(service: AuthServiceProtocol = AuthService()) {
        self.service = service
    }
    
    var service: AuthServiceProtocol
    var model = AuthModel.EMPTY
    
    var textfildEmpty: Observer<EmptyTextField> = Observer(value: .emailEmpty)
    var authError: Observer<AuthError> = Observer(value: .loginFaildError)
    var loginStart: Observer<String> = Observer(value: "")
    var loginSuccess: Observer<Bool> = Observer(value: false)
    var logoutSuccess: Observer<Bool> = Observer(value: false)
}

extension AuthViewModel {
    
    func userLogin(email: String, password: String) {
        if email == "" {
            textfildEmpty.value = .emailEmpty
        } else if password == "" {
            textfildEmpty.value = .passwordEmpty
        } else {
            self.model.email = email
            self.model.password = password
            loginStart.value = "로딩중입니다..."
            login()
        }
    }
    func login() {
        service.login(model: model) { [weak self] result in
            switch result {
            case .success():
                self?.loginSuccess.value = true
            case .failure(let error):
                self?.authError.value = error
            }
        }
    }
    func logout() {
       try? service.logout { [weak self] result in
           switch result {
           case .success():
               self?.logoutSuccess.value = true
           case .failure(let error):
               self?.authError.value = error
           }
        }
    }
    
}
