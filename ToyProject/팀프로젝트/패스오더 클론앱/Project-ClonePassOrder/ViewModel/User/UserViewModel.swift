//
//  UserViewModel.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/01.
//

import Foundation

final class UserViewModel {
    
    static let shared = UserViewModel()
    
    init(service: UserServiceProtocol = UserService()) {
        self.userService = service
    }
    
    var userService: UserServiceProtocol
    var model: UserModel = UserModel.EMPTY
    var userServiceError: Observer<UserServiceError> = Observer(value: .snapShotError)
    var userFetchEnd: Observer<Bool> = Observer(value: false)
    var userName: String {
        return model.userName
    }
    var profileImageUrl: URL? {
        return URL(string: model.profileImageUrl)
    }
}


extension UserViewModel {
    
    func userFetch() {
        userService.fetch() { [weak self] result in
            switch result {
            case .success(let model):
                self?.model = model
                self?.userFetchEnd.value = true
            case .failure(let error):
                self?.userServiceError.value = error
            }
        }
    }
}
