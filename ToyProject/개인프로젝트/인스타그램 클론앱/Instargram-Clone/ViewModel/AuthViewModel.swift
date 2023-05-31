//
//  File.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/03/22.
//

import Foundation
import UIKit

//로그인 버튼의 상태를 바꾸는 프로토콜입니다.
protocol FormViewModel {
    func unpdateForm()
}

//로그인버튼의 상태를 바꾸기위해 조건을 검증하는 프로토콜입니다.
protocol AuthViewModel {
    var formIsVaild: Bool { get }
    var buttonOptionColor: UIColor { get }
    var buttonOptionTextColor: UIColor { get }
}

struct LoginViewModel: AuthViewModel {
    var email: String?
    var password: String?
    
    //이메일,패스워드가 비어있으면...
    //formisVaild가 false 가 되고 버튼의 컬러, 버튼의 텍스트를 모두 투명하게 바꿉니다.
    var formIsVaild: Bool {
        return email?.isEmpty == false && password?.isEmpty == false 
    }
    
    var buttonOptionColor: UIColor {
        return formIsVaild ? UIColor.systemPurple.withAlphaComponent(1) : UIColor.systemPurple.withAlphaComponent(0.2)
    }
    
    var buttonOptionTextColor: UIColor {
        return formIsVaild ? .white : UIColor(white: 1, alpha: 0.2)
    }
}


struct RegisterViewModel: AuthViewModel {
    //위에의 로그인뷰모델과 동일하지만 userName fullName 두개의 텍스트필드가 추가되었습니다.
    
    var email: String?
    var password: String?
    var fullName: String?
    var userNmae: String?
   
    
    var formIsVaild: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullName?.isEmpty == false && userNmae?.isEmpty == false
    }
    
    var buttonOptionColor: UIColor {
        return formIsVaild ? UIColor.systemPurple.withAlphaComponent(1) : UIColor.systemPurple.withAlphaComponent(0.2)
    }
    
    var buttonOptionTextColor: UIColor {
        return formIsVaild ? .white : UIColor(white: 1, alpha: 0.2)
    }

}


