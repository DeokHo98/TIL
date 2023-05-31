//
//  PayDetailViewController.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/27.
//

import Foundation
import SnapKit

class PayDetailViewController : UIViewController {
    let myScrollView = UIScrollView()
    let payDtailInfoView = PayDetailInfoView()
    let receiptView = PayReceiptView()
    lazy var scrollStackView : UIStackView = {
        let sv = UIStackView()
        [payDtailInfoView,receiptView].forEach { sv.addArrangedSubview($0)}
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
    }
    private func setAttribute(){
        self.title = ""
        self.view.backgroundColor = .white
        myScrollView.alwaysBounceVertical = true
    }
    private func setLayout(){
        self.view.addSubview(myScrollView)
        myScrollView.addSubview(scrollStackView)
        myScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        scrollStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(myScrollView)
        }
    }
}
