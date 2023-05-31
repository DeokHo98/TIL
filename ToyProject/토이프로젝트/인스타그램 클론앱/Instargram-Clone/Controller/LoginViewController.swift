//
//  LoginViewController.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/03/22.
//

import UIKit
import Firebase


protocol AuthebtucatuibDelegate: AnyObject {
    func authenticationComplete()
}



class LoginViewController: UIViewController {
    
    //MARK: - 속성
    //로그인 뷰 모델입니다.
    private var viewModel = LoginViewModel()
    
    //델리게이트패턴을 사용하기위해 변수로 만듭니다.
   weak var delegate: AuthebtucatuibDelegate?
    
    
    //인스타그램 타이틀입니다.
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Instagram_logo_white")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    //로그인화면 이메일 텍스트필드입니다.
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.loginAndReisterTextField(title: "  이메일")
      
        return tf
    }()
    
    //로그인화면 패스워드텍스트필드입니다.
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.loginAndReisterTextField(title: "  비밀번호", isSecureTextEntry: true)
     
        return tf
    }()
    
    //이메일,패스워드 텍스트필드와 로그인버튼, 비밀번호찾기 버튼을 스택뷰로 묶은것입니다.
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [emailTextField,passwordTextField, loginButton])
        sv.axis = .vertical
        sv.spacing = 20
        return sv
    }()
    
    //로그인버튼입니다.
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.loginAndReistterButton(title: "로그인")
        button.addTarget(self, action: #selector(loginButtonTap), for: .touchUpInside)
        button.backgroundColor = .systemPurple.withAlphaComponent(0.2)
        button.setTitleColor(UIColor(white: 1, alpha: 0.2), for: .normal)
        button.isEnabled = false
        return button
    }()
    
    //회원가입화면으로 가는 버튼입니다.
    private let dontHaveButton: UIButton = {
        let button = UIButton()
        button.attributedTitle(firstPart: "이메일이 없으신가요?", secondPart: "  회원가입 하기")
        button.addTarget(self, action: #selector(tapDontHaveButton), for: .touchUpInside)
        return button
    }()
    
  
    
    //MARK: - 라이프사이클

    override func viewDidLoad() {
        super.viewDidLoad()
         configureUI()
        configureNotificationObsrvers()
    }
    
    //MARK: - 도움메서드
    
    //뷰를 올리고 레이아웃을 잡는 메서드입니다.
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        gradient(view: view)
        
        hideKeyboardWhenTappedAround()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        view.addSubview(stackView)
        stackView.anchor(top: iconImage.bottomAnchor, left:  view.leftAnchor, right: view.rightAnchor,paddingTop: 32,paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(dontHaveButton)
        dontHaveButton.centerX(inView: view)
        dontHaveButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    //패스워드와 이메일에 값이 변할때를 순간을 포착하는 옵저버 메서드입니다.
    func configureNotificationObsrvers() {
        emailTextField.addTarget(self, action: #selector(textDidchange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidchange), for: .editingChanged)
    }

    //MARK: - 셀렉터
    
    //회원가입버튼을 클릭했을때 호출되는 셀렉터 메서드입니다.
    @objc func tapDontHaveButton() {
        let controller = RegisterViewController()
        controller.deleagte = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //텍스트필드의 값이 변할때 값을 뷰모델에 넣어주는 셀렉터 메서드입니다.
    @objc func textDidchange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        unpdateForm()
    }
    
    //로그인 메서드입니다.
    @objc func loginButtonTap() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        AuthService.logUserIn(email: email, password: password) { result, error in
            if error != nil {
                print("로그인 에러")
                return
            }
            self.delegate?.authenticationComplete()
        }
    }
}


extension LoginViewController: FormViewModel {
    //텍스트필드에 값이 있는지 없는지에따라 버튼의 색이나 활성화를 바꿉니다.
    func unpdateForm() {
        loginButton.backgroundColor = viewModel.buttonOptionColor
        loginButton.setTitleColor(viewModel.buttonOptionTextColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsVaild
    }
}
