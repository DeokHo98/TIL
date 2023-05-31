//
//  SignupViewController.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/07.
//

import UIKit
import Firebase
import FirebaseAuth
import GeoFire
import CoreLocation

class SignupViewController: UIViewController {

    
    //MARK: - 속성
    
    private var location = LocationHnadler.shared.locationManager.location
    
    private let titleLabel: UILabel = {
        UILabel.uberTitleLabel()
    }()
    
    private let emailTextField: UITextField = {
         return UITextField.textField(plachHolderName: "이메일", isSecureText: false)
    }()
    
   private lazy var emailContainerView: UIView = {
        let imageView: UIImageView = {
            UIImageView.imageView(imageName: "email")
        }()
        
        return UIView.inputContainerView(imageView: imageView, texField: emailTextField)
    }()
    
    private let PasswordField: UITextField = {
        return UITextField.textField(plachHolderName: "패스워드", isSecureText: true)
   }()
    
    private lazy var PasswordContainerView: UIView = {
        let imageView: UIImageView = {
            UIImageView.imageView(imageName: "password")
        }()
        return UIView.inputContainerView(imageView: imageView, texField: PasswordField)
    }()
    
   private let nameField: UITextField = {
        return UITextField.textField(plachHolderName: "닉네임", isSecureText: false)
   }()
    
    private lazy var nameContainerView: UIView = {
        let imageView: UIImageView = {
            UIImageView.imageView(imageName: "user")
        }()
        return UIView.inputContainerView(imageView: imageView, texField: nameField)
    }()
    
    private let userImage: UIImageView = {
        return UIImageView.imageView(imageName: "user.fill")
    }()
    
    private let segmentedControl: UISegmentedControl = {
       let sg = UISegmentedControl(items: ["탑승자", "드라이버"])
        sg.backgroundColor = .backgroundColor
        sg.tintColor = UIColor(white: 1, alpha: 0.87)
        sg.selectedSegmentIndex = 0
        return sg
    }()
    
    private let LoginButton: UIButton = {
        let button = UIButton.loginButton(buttonLabel: "회원가입")
        button.addTarget(self, action: #selector(handlerSignUp), for: .touchUpInside)
        return button
    }()
    
    
    private let textButton: UIButton = {
        let button = UIButton.textButton(text1: "이메일이 있으신가요??", text2: "  로그인하기")
        button.addTarget(self, action: #selector(handlerShowLogin), for: .touchUpInside)
        return button
    }()
    
    //MARK: - 라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        makeLayout()
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       }
    
    
    //MARK: - 셀렉터 메서드
    
    @objc func handlerShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handlerSignUp() {
        guard let email = emailTextField.text  else {return}
        guard let password = PasswordField.text else {return}
        guard let name = nameField.text else {return}
        let accountTypeIndex = segmentedControl.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: email, password: password) { [self] result, error in
            if error != nil {
                print("회원가입 오류")
                return
            } else {
                let value = ["email": email, "name": name, "accountType": accountTypeIndex] as [String: Any]
                guard let uid = result?.user.uid else {return}
                if accountTypeIndex == 1 {
                    let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
                    guard let location = location else {return}
                    
                    geofire.setLocation(location, forKey: uid) { error in
                        self.uploadUserDataAndDismiss(uid: uid, value: value)
                    }
                }
                    uploadUserDataAndDismiss(uid: uid, value: value)
            }
        }
    }
    
    
    
    //MARK: - 도움 메서드
    private func makeLayout() {
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        view.addSubview(emailContainerView)
        emailContainerView.anchor(top: titleLabel.bottomAnchor,leading: view.leadingAnchor,trailng: view.trailingAnchor,paddingTop: 40,paddingLeading: 16,paddingTrailing: 16,height: 50)
        
        view.addSubview(PasswordContainerView)
        PasswordContainerView.anchor(top: emailContainerView.bottomAnchor,leading: view.leadingAnchor,trailng: view.trailingAnchor,paddingTop: 16,paddingLeading: 16,paddingTrailing: 16,height: 50)
        
        view.addSubview(nameContainerView)
        nameContainerView.anchor(top: PasswordContainerView.bottomAnchor,leading: view.leadingAnchor, trailng: view.trailingAnchor, paddingTop: 16, paddingLeading: 16, paddingTrailing: 16, height: 50)
        
        view.addSubview(userImage)
        userImage.anchor(top: nameContainerView.bottomAnchor, leading: view.leadingAnchor, paddingTop: 16,paddingLeading: 24, width: 24, height: 24)
        
        view.addSubview(segmentedControl)
        segmentedControl.anchor(top:userImage.bottomAnchor, leading: view.leadingAnchor,trailng: view.trailingAnchor,paddingTop: 16,paddingLeading: 24, paddingTrailing: 24)
        
        view.addSubview(LoginButton)
        LoginButton.anchor(top: segmentedControl.bottomAnchor,leading: view.leadingAnchor,trailng: view.trailingAnchor,paddingTop: 32,paddingLeading: 16,paddingTrailing: 16)
        
        view.addSubview(textButton)
        textButton.centerX(inView: view)
        textButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
        
    }
    
    func uploadUserDataAndDismiss(uid: String , value: [String: Any]) {
        REF_USERS.child(uid).updateChildValues(value) { error, ref in
            print("데이터 세이브 성공")
        }
        navigationController?.popViewController(animated: true)
    }


}
