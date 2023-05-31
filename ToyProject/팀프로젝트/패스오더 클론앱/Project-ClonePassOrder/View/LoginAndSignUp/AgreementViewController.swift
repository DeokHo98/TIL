//
//  AgreementView.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/17.
//

import SnapKit
import UIKit
import SVProgressHUD

class AgreementViewController: UIViewController {
    
    //MARK: - 프로퍼티
    
    private var allBool: Bool = false {
        didSet {
            if allBool {
                allAgreementImage.tintColor = .black
                SignUpViewModel.shared.is14YearsOld.value = true
                SignUpViewModel.shared.isAgreeService.value = true
                SignUpViewModel.shared.isAgreeLocationService.value = true
                SignUpViewModel.shared.isAgreePrivacyInformation.value = true
                SignUpViewModel.shared.isAgreePrivacyThirdPartyInformation.value = true
                SignUpViewModel.shared.isAgreeMarketingReceive.value = true
            } else {
                allAgreementImage.tintColor = .systemGray4
                SignUpViewModel.shared.is14YearsOld.value = false
                SignUpViewModel.shared.isAgreeService.value = false
                SignUpViewModel.shared.isAgreeLocationService.value = false
                SignUpViewModel.shared.isAgreePrivacyInformation.value = false
                SignUpViewModel.shared.isAgreePrivacyThirdPartyInformation.value = false
                SignUpViewModel.shared.isAgreeMarketingReceive.value = false
            }
        }
    }
    private let welcomeView: UIView = UIView().welcomeView()
    private let allAgreementButton: UIButton = UIButton().agreementButton(
        title: "  모든 약관에 동의합니다.",
        color: .black,
        size: 22
    )
    private let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    private let ageAgreementButton: UIButton = UIButton().agreementButton(
        title: "  만 14세 이상여부 (필수)"
    )
    private let serviceAgreementButton: UIButton = UIButton().agreementButton(
        title: "  서비스 이용약관 (필수)"
    )
    private let locationAgreementButton: UIButton = UIButton().agreementButton(
        title: "  위치기반서비스 이용약관 (필수)"
    )
    private let privacyAgreementButton: UIButton = UIButton().agreementButton(
        title: "  개인정보 처리방침 (필수)"
    )
    private let privacyProvideAgreementButton: UIButton = UIButton().agreementButton(
        title: "  개인정보 제3자 제공동의 (필수)"
    )
    private let marketingAgreementButton: UIButton = UIButton().agreementButton(
        title: "  마케팅 정보 수신 동의 (선택)"
    )
    private let allAgreementImage: UIImageView = UIImageView().agreementImage(
        systemName: "checkmark.circle.fill",
        size: 40
    )
    private let nextButton: UIButton = UIButton().nextButton(title: "완료")
    private let ageAgreementImage: UIImageView = UIImageView().agreementImage()
    private let serviceAgreementImage: UIImageView = UIImageView().agreementImage()
    private let locationAgreementImage: UIImageView = UIImageView().agreementImage()
    private let privacyAgreementImage: UIImageView = UIImageView().agreementImage()
    private let privacyProvideAgreementImage: UIImageView = UIImageView().agreementImage()
    private let marketingAgreementImage: UIImageView = UIImageView().agreementImage()
    private lazy var allAgreementStackView: UIStackView = UIStackView(
        arrangedSubviews: [allAgreementImage,allAgreementButton]
    )
    private lazy var ageAgreementStackView: UIStackView = UIStackView(
        arrangedSubviews: [ageAgreementImage,ageAgreementButton]
    )
    private lazy var serviceAgreementStackView: UIStackView = UIStackView(
        arrangedSubviews: [serviceAgreementImage,serviceAgreementButton]
    )
    private lazy var locationAgreementStackView: UIStackView = UIStackView(
        arrangedSubviews: [locationAgreementImage,locationAgreementButton]
    )
    private lazy var privacyAgreementStackView: UIStackView = UIStackView(
        arrangedSubviews: [privacyAgreementImage,privacyAgreementButton]
    )
    private lazy var privacyProvideAgreementStackView: UIStackView = UIStackView(
        arrangedSubviews: [privacyProvideAgreementImage,privacyProvideAgreementButton]
    )
    private lazy var marketingAgreementStackView: UIStackView = UIStackView(
        arrangedSubviews: [marketingAgreementImage,marketingAgreementButton]
    )
    private lazy var agreementStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            ageAgreementStackView,
            serviceAgreementStackView,
            locationAgreementStackView,
            privacyAgreementStackView,
            privacyProvideAgreementStackView,
            marketingAgreementStackView
        ])
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        return sv
    }()
    
    //MARK: - 라이프사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviSetAttribute()
        setAtrribute()
        setLayout()
        setBinding()
    }
    
    //MARK: - 셀렉터메서드
    @objc private func allAgreementButtonTapped() {
        allBool.toggle()
    }
    @objc private func ageAgreementButtonTapped() {
        SignUpViewModel.shared.is14YearsOld.value.toggle()
        confirmAllSelect()
    }
    @objc private func serviceAgreementButtonTapped() {
        SignUpViewModel.shared.isAgreeService.value.toggle()
        confirmAllSelect()
    }
    @objc private func locationAgreementButtonTapped() {
        SignUpViewModel.shared.isAgreeLocationService.value.toggle()
        confirmAllSelect()
    }
    @objc private func privacyAgreementButtonTapped() {
        SignUpViewModel.shared.isAgreePrivacyInformation.value.toggle()
        confirmAllSelect()
    }
    @objc private func privacyProvideAgreementButtonTapped() {
        SignUpViewModel.shared.isAgreePrivacyThirdPartyInformation.value.toggle()
        confirmAllSelect()
    }
    @objc private func marketingAgreementButtonTapped() {
        SignUpViewModel.shared.isAgreeMarketingReceive.value.toggle()
        confirmAllSelect()
    }
    @objc private func nextButtonTapped() {
        confirmDone()
    }
    
    //MARK: - 메서드
    
    private func setLayout() {
        self.welcomViewSetLayout(view: view, welcomeView: welcomeView)
        [nextButton,allAgreementStackView,separateView,agreementStackView].forEach {
            view.addSubview($0)
        }
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-20)
        }
        allAgreementStackView.snp.makeConstraints { make in
            make.top.equalTo(welcomeView.snp.bottom).offset(100)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        separateView.snp.makeConstraints { make in
            make.top.equalTo(allAgreementStackView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(0.8)
        }
        agreementStackView.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(15)
            make.bottom.equalTo(nextButton.snp.top).offset(-40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    private func setAtrribute() {
        view.backgroundColor = .white
        allAgreementButton.addTarget(
            self,
            action: #selector(allAgreementButtonTapped),
            for: .touchUpInside
        )
        ageAgreementButton.addTarget(
            self,
            action: #selector(ageAgreementButtonTapped),
            for: .touchUpInside
        )
        serviceAgreementButton.addTarget(
            self,
            action: #selector(serviceAgreementButtonTapped),
            for: .touchUpInside
        )
        locationAgreementButton.addTarget(
            self,
            action: #selector(locationAgreementButtonTapped),
            for: .touchUpInside
        )
        privacyAgreementButton.addTarget(
            self,
            action: #selector(privacyAgreementButtonTapped),
            for: .touchUpInside
        )
        privacyProvideAgreementButton.addTarget(
            self,
            action: #selector(privacyProvideAgreementButtonTapped),
            for: .touchUpInside
        )
        marketingAgreementButton.addTarget(
            self,
            action: #selector(marketingAgreementButtonTapped),
            for: .touchUpInside
        )
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    private func naviSetAttribute() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
    }
    private func setBinding() {
        SignUpViewModel.shared.is14YearsOld.bind { [weak self] bool in
            self!.toggleAgreementBool(
                state: bool,
                button: self!.ageAgreementButton,
                image: self!.ageAgreementImage
            )
        }
        SignUpViewModel.shared.isAgreeService.bind { [weak self] bool in
            self!.toggleAgreementBool(
                state: bool,
                button: self!.serviceAgreementButton,
                image: self!.serviceAgreementImage
            )
        }
        SignUpViewModel.shared.isAgreeLocationService.bind { [weak self] bool in
            self!.toggleAgreementBool(
                state: bool,
                button: self!.locationAgreementButton,
                image: self!.locationAgreementImage
            )
        }
        SignUpViewModel.shared.isAgreePrivacyInformation.bind { [weak self] bool in
            self!.toggleAgreementBool(
                state: bool,
                button: self!.privacyAgreementButton,
                image: self!.privacyAgreementImage
            )
        }
        SignUpViewModel.shared.isAgreePrivacyThirdPartyInformation.bind { [weak self] bool in
            self!.toggleAgreementBool(
                state: bool,
                button: self!.privacyProvideAgreementButton,
                image: self!.privacyProvideAgreementImage
            )
        }
        SignUpViewModel.shared.isAgreeMarketingReceive.bind { [weak self] bool in
            self!.toggleAgreementBool(
                state: bool,
                button: self!.marketingAgreementButton,
                image: self!.marketingAgreementImage
            )
        }
        SignUpViewModel.shared.imageUploadError.bind { [weak self] error in
            SVProgressHUD.SVoff(view: self!.view, button: [self!.nextButton])
            Toast.message(superView: self!.view, text: error.errorMessage)
        }
        SignUpViewModel.shared.signUpError.bind { [weak self] error in
            SVProgressHUD.SVoff(view: self!.view, button: [self!.nextButton])
            Toast.message(superView: self!.view, text: error.errorMessage)
        }
        SignUpViewModel.shared.imageUploadSuccess.bind { _ in
            SignUpViewModel.shared.signUpUser()
        }
        SignUpViewModel.shared.signUpEnd.bind { [weak self] _ in
            SVProgressHUD.SVoff(view: self!.view, button: [self!.nextButton])
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            guard let delegate = sceneDelegate else {
                return
            }
            delegate.window?.rootViewController = TabBarController()
        }
    }
    private func toggleAgreementBool(state: Bool,button: UIButton, image: UIImageView) {
        if state {
            button.setTitleColor(.black, for: .normal)
            image.tintColor = .black
        } else {
            button.setTitleColor(.systemGray4, for: .normal)
            image.tintColor = .systemGray4
        }
    }
    private func confirmAllSelect() {
        if SignUpViewModel.shared.is14YearsOld.value,
           SignUpViewModel.shared.isAgreeService.value,
           SignUpViewModel.shared.isAgreeLocationService.value,
           SignUpViewModel.shared.isAgreePrivacyInformation.value,
           SignUpViewModel.shared.isAgreePrivacyThirdPartyInformation.value,
           SignUpViewModel.shared.isAgreeMarketingReceive.value {
            allBool = true
        } else {
            allAgreementImage.tintColor = .systemGray4
        }
    }
    private func confirmDone() {
        if SignUpViewModel.shared.requiredAgreedValid() {
            SVProgressHUD.SVshow(view: view, text: "회원가입중 입니다...", button: [nextButton])
            SignUpViewModel.shared.profileImageUpload()
        } else {
            Toast.message(superView: view, text: "필수약관에 모두 동의해주세요!")
        }
     
    }
}

