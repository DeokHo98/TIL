//
//  LoginController.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/16.
//

import SnapKit
import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    //MARK: - 프로퍼티
    
    private let emailLoginButton: UIButton = UIButton().emailLoginButton()
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "패스오더로그인이미지")
        return iv
    }()
    private let signupButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("이메일로 회원가입하기", for: .normal)
        bt.setTitleColor(.darkGray, for: .normal)
        bt.titleLabel?.font = .systemFont(ofSize: 16)
        bt.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        return bt
    }()
    private lazy var loginStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews:
                                [emailLoginButton,
                                 signupButton])
        sv.axis = .vertical
        sv.spacing = 15
        return sv
    }()
    
    //MARK: - 라이프사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAtrribute()
        setLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        setNavigationAttribute()
    }
    
    //MARK: - 셀렉터메서드
    
    @objc private func emailLoginButtonTapped() {
        navigationController?.pushViewController(EmailLoginViewController(), animated: true)
    }
    @objc private func emailSignupButtonTapped() {
        navigationController?.pushViewController(ProfileImageViewController(), animated: true)
    }
    
    //MARK: - 메서드
    
    private func setLayout() {
        [logoImageView,loginStackView].forEach {
            view.addSubview($0)
        }
        logoImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        loginStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
    }
    private func setAtrribute() {
        view.backgroundColor = .systemBackground
        emailLoginButton.addTarget(self, action: #selector(emailLoginButtonTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(emailSignupButtonTapped), for: .touchUpInside)
    }
    private func setNavigationAttribute() {
        navigationController?.navigationBar.isHidden = true
    }
}
