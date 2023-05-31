//
//  UserNameSignupViewController.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/08.
//

import UIKit

class UserNameSignupViewController: UIViewController {
    
    //MARK: - 프로퍼티

    private let welcomeView: UIView = UIView().welcomeView()
    private let nextButton: UIButton = UIButton().nextButton()
    private lazy var textField: UITextField = UITextField().signUpTextField(
        text: "닉네임",
        placeholder: "8글자 이하로 작성해주세요"
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
        SignUpViewModel.shared.signUpStep = .userName
        setBinding()
    }
    
    //MARK: - 셀렉터메서드
    
    @objc private func nextButtonTapped() {
        pushNextView()
    }
    
    //MARK: - 메서드
    
    private func setLayout() {
        self.welcomViewSetLayout(view: view, welcomeView: welcomeView)
            self.textFieldSetLayout(view: view, textField: textField, topView: welcomeView)
            self.nextButtonSetLayout(view: view, button: nextButton, topView: textField)
    }
    private func setAtrribute() {
        view.backgroundColor = .systemBackground
        textField.delegate = self
        textField.becomeFirstResponder()
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    private func naviSetAttribute() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
    }
    private func setBinding() {
        SignUpViewModel.shared.signupCheck.bind { [weak self] signupCheck in
            if signupCheck == .success {
                self?.navigationController?.pushViewController(EmailSignupViewController(), animated: true)
            } else {
                Toast.message(superView: self!.view, text: signupCheck.message)
            }
        }
    }
    private func pushNextView() {
        let text = textField.text ?? ""
        SignUpViewModel.shared.textFieldEmptyVaild( text: text)
    }
}

//MARK: - 텍스트필드 델리게이트

extension UserNameSignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushNextView()
        return true
    }
}

