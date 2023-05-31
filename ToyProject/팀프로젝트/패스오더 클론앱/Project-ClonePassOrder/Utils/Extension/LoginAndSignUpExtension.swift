//
//  LoginAndSignUpExtension.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/16.
//

import SnapKit
import UIKit

extension UIViewController {
    func welcomViewSetLayout(view: UIView, welcomeView: UIView) {
        view.addSubview(welcomeView)
        welcomeView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.top.equalTo(view.snp.topMargin)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing)
        }
    }
    func textFieldSetLayout(view: UIView, textField: UITextField, topView: UIView) {
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(100)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
        }
    }
    func nextButtonSetLayout(view: UIView, button: UIButton ,topView: UIView) {
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(40)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
        }
    }
}

extension UIView {
    func welcomeView(text: String = "이메일로 회원가입하기",height: Int = 40) -> UIView {
        let welcomView = UIView()
        let welcomelabel = UILabel()
        welcomelabel.textColor = .lightGray
        welcomelabel.text = "welcome to"
        welcomelabel.font = .systemFont(ofSize: 20)
        let passorderLabel = UILabel()
        passorderLabel.textColor = .systemRed
        passorderLabel.text = "PASSORDER"
        passorderLabel.font = .boldSystemFont(ofSize: 40)
        let emailLabel = UILabel()
        emailLabel.textColor = .black
        emailLabel.text = text
        emailLabel.font = .systemFont(ofSize: 22)
        welcomView.addSubview(welcomelabel)
        welcomelabel.snp.makeConstraints { make in
            make.top.equalTo(welcomView.snp.top)
            make.leading.equalTo(welcomView.snp.leading)
        }
        welcomView.addSubview(passorderLabel)
        passorderLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomelabel.snp.bottom).offset(10)
            make.leading.equalTo(welcomView.snp.leading)
        }
        welcomView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(passorderLabel.snp.bottom).offset(height)
        }
        return welcomView
    }
}

extension UIButton {
    func emailLoginButton(
        text: String = " 이메일로 로그인",
        image: UIImage? = UIImage(systemName: "mail.fill")!,
        height: Int = 60
    ) -> UIButton {
        let bt = UIButton(type: .system)
        bt.tintColor = .black
        bt.setImage(image, for: .normal)
        bt.setTitle(text, for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = .systemFont(ofSize: 18)
        bt.layer.borderWidth = 1
        bt.layer.borderColor = UIColor.black.cgColor
        bt.layer.cornerRadius = 10
        bt.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        return bt
    }
    func nextButton(title: String = "다음  ") -> UIButton {
        let bt = UIButton(type: .system)
        bt.setTitle(title, for: .normal)
        bt.setTitleColor(.darkGray, for: .normal)
        bt.tintColor = .darkGray
        bt.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        bt.titleLabel?.font = .systemFont(ofSize: 18)
        bt.semanticContentAttribute = .forceRightToLeft
        return bt
    }
    func agreementButton(title: String, color: UIColor = .systemGray4, size: CGFloat = 20) -> UIButton {
        let bt = UIButton(type: .system)
        bt.setTitle(title, for: .normal)
        bt.setTitleColor(color, for: .normal)
        bt.titleLabel?.font = .systemFont(ofSize: size)
        bt.contentHorizontalAlignment = .left
        return bt
    }
}

extension UIImageView {
    func agreementImage(systemName: String = "chevron.down", size: Int = 26) -> UIImageView {
        let iv = UIImageView()
        iv.image = UIImage(systemName: systemName)
        iv.tintColor = .systemGray4
        iv.snp.makeConstraints { make in
            make.height.width.equalTo(size)
        }
        return iv
    }
}

extension UITextField {
    func loginTextField(
        height: Double = 0.8,
        returnKey: UIReturnKeyType,
        serureTextEntry: Bool
    ) -> UITextField {
        let tf = UITextField()
        tf.returnKeyType = returnKey
         tf.snp.makeConstraints { make in
             make.height.equalTo(40)
         }
            let sv = UIView()
            sv.backgroundColor = .black
            sv.snp.makeConstraints { make in
                make.height.equalTo(height)
            }
         tf.addSubview(sv)
         sv.snp.makeConstraints { make in
             make.leading.trailing.bottom.equalTo(tf)
         }
        tf.isSecureTextEntry = serureTextEntry
        tf.autocapitalizationType = .none
         return tf
    }
    func signUpTextField(text: String, placeholder: String) -> UITextField {
        let textField = UITextField().loginTextField(
            height: 2,
            returnKey: .next,
            serureTextEntry: false
        )
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        textField.addSubview(label)
        textField.placeholder = placeholder
        label.snp.makeConstraints { make in
            make.bottom.equalTo(textField.snp.top)
            make.leading.equalTo(textField.snp.leading)
        }
        return textField
    }
}

extension UILabel {
     func emailLoginLabel(text: String) -> UILabel {
        let lb = UILabel()
        lb.text = text
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 14)
        return lb
    }
}

extension UIStackView {
    func agreementStackView(view: [UIView]) -> UIStackView {
        let sv = UIStackView(arrangedSubviews: view)
        sv.axis = .horizontal
        sv.spacing = 5
        return sv
    }
}
