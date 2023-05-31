//
//  PhoneNumberSignupViewController.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/08.
//

import UIKit

class PhoneNumberSignupViewController: UIViewController {
  
    //MARK: - 프로퍼티
    
    private var phoneNumberConfirmTextField: UITextField = UITextField().signUpTextField(
        text: "인증번호 입력",
        placeholder: "인증번호 6자리 입력"
    )
    private let welcomeView: UIView = UIView().welcomeView()
    private let nextButton: UIButton = UIButton().nextButton()
    private var phoneNumberConfirmButton: UIButton = UIButton().emailLoginButton(
        text: "확인",
        image: nil ,
        height: 40
    )
    private lazy var textField: UITextField = UITextField().signUpTextField(
        text: "전화번호 인증",
        placeholder: "- 빼고 입력해주세요"
    )
    
    //MARK: - 라이프사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviSetAttribute()
        setAtrribute()
        setLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SignUpViewModel.shared.signUpStep = .PhoneNumber
        setBinding()
    }
    
    //MARK: - 셀렉터메서드
    
    @objc private func nextButtonTapped() {
        pushNextView()
    }
    @objc private func phoneNumberConfirmButtonTapped() {
        let text = textField.text ?? ""
        SignUpViewModel.shared.textFieldEmptyVaild( text: text)
    }
    
    //MARK: - 메서드
    
    private func setLayout() {
        self.welcomViewSetLayout(view: view, welcomeView: welcomeView)
            [phoneNumberConfirmButton,textField].forEach {
                view.addSubview($0)
            }
            phoneNumberConfirmButton.snp.makeConstraints { make in
                make.top.equalTo(welcomeView.snp.bottom).offset(100)
                make.trailing.equalToSuperview().offset(-20)
                make.width.equalTo(80)
            }
            textField.snp.makeConstraints { make in
                make.top.equalTo(welcomeView.snp.bottom).offset(100)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalTo(phoneNumberConfirmButton.snp.leading).offset(-20)
            }
            self.nextButtonSetLayout(view: view, button: nextButton, topView: textField)
    }
    private func setAtrribute() {
        view.backgroundColor = .systemBackground
        textField.delegate = self
        textField.becomeFirstResponder()
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        phoneNumberConfirmButton.addTarget(
            self,
            action: #selector(phoneNumberConfirmButtonTapped),
            for: .touchUpInside
        )
    }
    private func naviSetAttribute() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
    }
    private func setBinding() {
        SignUpViewModel.shared.signupCheck.bind { [weak self] signupCheck in
            if signupCheck == .success {
                SignUpViewModel.shared.phoneNumberAuth()
            } else {
                Toast.message(superView: self!.view, text: signupCheck.message)
            }
        }
        SignUpViewModel.shared.sendSuccess.bind { [weak self] _ in
            self!.view.addSubview(self!.phoneNumberConfirmTextField)
            self!.view.addSubview(self!.phoneNumberConfirmTextField)
            self!.phoneNumberConfirmTextField.snp.makeConstraints { make in
                make.top.equalTo(self!.textField.snp.bottom).offset(40)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalTo(self!.view.snp.trailing).offset(-20)
            }
            self!.nextButton.snp.removeConstraints()
            self!.nextButtonSetLayout(
                view: self!.view,
                button: self!.nextButton,
                topView: self!.phoneNumberConfirmTextField
            )
        }
        SignUpViewModel.shared.signUpError.bind { [weak self] error in
            Toast.message(superView: self!.view, text: error.errorMessage)
        }
        SignUpViewModel.shared.phoneNumberAuthSuccess.bind { [weak self] _ in
            self?.navigationController?.pushViewController(AgreementViewController(), animated: true)
        }
    }
    private func pushNextView() {
        let text = phoneNumberConfirmTextField.text ?? ""
        SignUpViewModel.shared.phoneNumberAuthValid(code: text)
    }
}

//MARK: - 텍스트필드 델리게이트

extension PhoneNumberSignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushNextView()
        return true
    }
}

