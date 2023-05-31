//
//  ProfileImageViewController.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/31.
//

import Foundation

import UIKit
import SVProgressHUD

class ProfileImageViewController: UIViewController {

    //MARK: - 프로퍼티
    
    private let welcomeView: UIView = UIView().welcomeView()
    private let label: UILabel = {
        let lb = UILabel()
        lb.text = "프로필 이미지를 추가해주세요!"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 20)
        return lb
    }()
    private let addPhotoButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setBackgroundImage(#imageLiteral(resourceName: "addPicture"), for: .normal)
        bt.tintColor = .black
        return bt
    }()
    private let nextButton: UIButton = UIButton().nextButton()
    
    //MARK: - 라이프사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setAtrribute()
        naviSetAttribute()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBinding()
    }
    
    //MARK: - 셀렉터메서드
    @objc private func nextButtonTapped() {
        SignUpViewModel.shared.isProfileImageEmpty()
    }
    @objc private func addPhotoButtonTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: - 메서드
    
    private func setLayout() {
        [welcomeView,label,addPhotoButton,nextButton].forEach {
            view.addSubview($0)
        }
        welcomViewSetLayout(view: view, welcomeView: welcomeView)
        label.snp.makeConstraints { make in
            make.top.equalTo(welcomeView.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
        }
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        nextButtonSetLayout(view: view, button: nextButton, topView: addPhotoButton)
    }
    private func setAtrribute() {
        view.backgroundColor = .systemBackground
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
    }
    private func naviSetAttribute() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
    }
    private func setBinding() {
        SignUpViewModel.shared.signupCheck.bind { [weak self] signupCheck in
            if signupCheck == .success {
                self?.navigationController?.pushViewController(UserNameSignupViewController(), animated: true)
            } else {
                Toast.message(superView: self!.view, text: signupCheck.message)
            }
        }
    }
}

//MARK: - 이미지 픽커 델리게이트
extension ProfileImageViewController:
    UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            return
        }
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.7) else {
            return
        }
        SignUpViewModel.shared.model.imageData = imageData
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width / 2
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.layer.borderColor = UIColor.white.cgColor
        addPhotoButton.layer.borderWidth = 2
        addPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
}
