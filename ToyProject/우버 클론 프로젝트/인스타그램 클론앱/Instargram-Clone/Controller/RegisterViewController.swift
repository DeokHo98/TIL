//
//  REGISTERViewController.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/03/22.
//

import UIKit

class RegisterViewController: UIViewController {

    
    //MARK: - 속성
    //회원가입 뷰 모델입니다.
    private var viewModel = RegisterViewModel()
    
    //프로필에 추가한 이미지를 저장하는 변수입니다.
    private var profileImage: UIImage?
    
    weak var deleagte: AuthebtucatuibDelegate?
    
    //프로필 이미지 추가 버튼입니다.
    private let plusPhotoButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "plus_photo"), for: .normal)
        bt.tintColor = .white
        bt.addTarget(self, action: #selector(handlerProfileImage), for: .touchUpInside)
        return bt
    }()
    
    //이메일 텍스트필드 입니다.
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.loginAndReisterTextField(title: "  이메일")
        return tf
    }()
    //패스워드 텍스트필드입니다.
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.loginAndReisterTextField(title: "  비밀번호", isSecureTextEntry: true)
        return tf
    }()
    //풀네임 텍스트필드입니다.
    private let fullNameTextField: UITextField = {
        let tf = UITextField()
        tf.loginAndReisterTextField(title: "  이름", isSecureTextEntry: false)
        tf.keyboardType = .default
        return tf
    }()
    //닉네임 텍스트필드입니다.
    private let userNameTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .default
        tf.loginAndReisterTextField(title: "  닉네임", isSecureTextEntry: false)
        return tf
    }()
    
    //스택뷰에 텍스트필드들과 로그인버튼을 넣었습니다.
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,fullNameTextField,userNameTextField,loginButton])
        sv.axis = .vertical
        sv.spacing = 20
        return sv
    }()
    
    //로그인버튼입니다.
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.loginAndReistterButton(title: "회원가입")
        button.backgroundColor = .systemPurple.withAlphaComponent(0.2)
        button.setTitleColor(UIColor(white: 1, alpha: 0.2), for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    //아이디가 있을지?물어보고 로그인화면으로 돌아갑니다.
    private let dontHaveButton: UIButton = {
        let button = UIButton()
        button.attributedTitle(firstPart: "이메일이 있으신가요?", secondPart: "  로그인 하기")
        button.addTarget(self, action: #selector(tapDontHaveButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - 라이프사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confiureView()
        reigsterTextFieldObserve()
    }
    
    
    //MARK: - 도움메서드
    //뷰를올리고 오토레이아웃을 잡는 메서드입니다.
    func confiureView() {
        gradient(view: view)
        
        hideKeyboardWhenTappedAround()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.setDimensions(height: 140, width: 140)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left:  view.leftAnchor, right: view.rightAnchor,paddingTop: 32,paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(dontHaveButton)
        dontHaveButton.centerX(inView: view)
        dontHaveButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    //모든 텍스트필드의 값이 변하는걸 확인하는 메서드입니다.
    func reigsterTextFieldObserve() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    //MARK: - 셀렉터
    //로그인화면으로 돌아갈때 의 셀렉터 메서드입니다.
    @objc func tapDontHaveButton() {
        navigationController?.popViewController(animated: true)
    }
    
    //회원가입 뷰모델에 텍스트필드의 값을 저장합니다.
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullNameTextField {
            viewModel.fullName = sender.text
        } else {
            viewModel.userNmae = sender.text
        }
        
        unpdateForm()
    }
    
    //프로필 이미지를 고르는 이미지 피커입니다.
    @objc func handlerProfileImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    //회원가입 버튼을 눌렀을때의 셀렉터 메서드입니다.
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let username = userNameTextField.text else { return }
        guard let profileImage = self.profileImage else { return }
        
        //필요한 사용자 데이터를 구조화시킵니다.
        let credentals = AuthCredentials(email: email, password: password, fullName: fullname, userName: username, profileImage: profileImage)
        //그 구조화시킨 데이터를 파이어스토어에 업로드합니다.
        AuthService.registerUser(credentials: credentals) { error in
            if error != nil {
                print("회원가입 유저 에러")
                return
            }
            
            self.deleagte?.authenticationComplete()
        }
    }
}

//MARK: - 뷰 모델 프로토콜

//텍스트필드의 값이 있는지 없는지를 구분해서 회원가입버튼의 활성화 색 등을 조정합니다.
extension RegisterViewController: FormViewModel {
    func unpdateForm() {
        loginButton.backgroundColor = viewModel.buttonOptionColor
        loginButton.setTitleColor(viewModel.buttonOptionTextColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsVaild
    }
}

//MARK: - 이미지 픽커 델리게이트

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //이미지 픽커 델리게이트를 이용해 이미지를 선택한뒤에 여러가지 속성을 변경합니다.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {return}
        profileImage = selectedImage
        
        //버튼을 동그랗게 만들기
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        
        //테두리 속성
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 2
        
        //이미지선택한뒤에 이미지픽커 버튼자체를 선택한 이미지로 바꿉니다.
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        //다시 이전으로 돌아갑니다.
        self.dismiss(animated: true, completion: nil)
    }
}
