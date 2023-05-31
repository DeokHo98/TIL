//
//  PayFinishViewController.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import Foundation
import SnapKit
import UIKit

class PayFinishViewController: UIViewController {
    let myScrollView = UIScrollView()
    let payStateView = PayStateView()
    let locationView: LeftImgRightLabelView = {
        let v = LeftImgRightLabelView()
        v.img.image = UIImage(systemName: "location.circle")
        v.img.tintColor = .gray
        v.label.text = "서울 송파구 백제고분로48길"
        v.label.textColor = .gray
        v.label.font = .systemFont(ofSize: 13, weight: .medium)
        return v
    }()
    let payfinishInfoView = PayFinishInfoView()
    let recoView = NextOrderRecoView()
    let checkBtn = OrangeSelectButton()
    lazy var scrollStackView: UIStackView = {
        let sv = UIStackView()
        [locationView,payStateView,payfinishInfoView,recoView,checkBtn].forEach { sv.addArrangedSubview($0) }
        sv.axis = .vertical
        sv.spacing = 15
        sv.alignment = .fill
        sv.distribution = .fill
        sv.backgroundColor = .white
        return sv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
        setLeftBarButtonItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "결제 완료"
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.title = ""
    }
    private func setAttribute(){
        self.view.backgroundColor = .white
        checkBtn.getButton.setTitle("확인했어요", for: .normal)
        payfinishInfoView.moreBtn.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
    }
    private func setLayout(){
        self.view.addSubview(myScrollView)
        myScrollView.addSubview(scrollStackView)
        myScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        scrollStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(myScrollView)
        }
        checkBtn.snp.makeConstraints { make in
            make.height.equalTo(myScrollView).multipliedBy(0.11)
        }
    }
    private func setLeftBarButtonItem(){
        let leftBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(backButtonTapped))
        leftBarButton.tintColor = .black
        navigationItem.leftBarButtonItem = leftBarButton
    }
    @objc func backButtonTapped(){
        self.dismiss(animated: true)
    }
    @objc func checkButtonTapped() {
        let nextVC = PayDetailViewController()
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
}
