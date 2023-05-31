//
//  OrderPayViewController.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/25.
//

import Foundation
import SnapKit
import UIKit

class OrderPayViewController : UIViewController {
    let myScrollView = UIScrollView()
    let locationView = LocationView()
    let payInfoView = PayInfoView()
    let getTimeView = GetTimeView()
    let requirementView = RequirementView()
    let totalOrderView = TotalOrderView()
    let cardCV = CardView()
    var isFirst : Bool = false
    let cellSize = CGSize(width: ScreenConstant.deviceWidth * 0.45, height: ScreenConstant.deviceWidth * 0.45 * 0.66)
    var previousIndex = 0
    lazy var scrollStackView: UIStackView = {
        let sv = UIStackView()
        [locationView, payInfoView, getTimeView, requirementView, totalOrderView, cardCV].forEach { sv.addArrangedSubview($0) }
        sv.axis = .vertical
        sv.spacing = 15
        sv.alignment = .fill
        sv.distribution = .fill
        sv.backgroundColor = .systemGray3
        return sv
    }()
    let payBtn = OrangeSelectButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboardWhenTappedAround()
        setAttribute()
        setLayout()
        setLeftBarButtonItem()
        setCollectionView()
        isFirst = true
        payBtn.getButton.addTarget(self, action: #selector(payBtnTapped), for: .touchUpInside)
    }
}
extension OrderPayViewController {
    private func setAttribute(){
        view.backgroundColor = .white
        self.title = "빽다방 미사스마트밸리점"
        payBtn.getButton.setTitle("결제", for: .normal)
        requirementView.requirementTF.delegate = self
    }
    private func setLayout(){
        [myScrollView,payBtn].forEach { self.view.addSubview($0)}
        [scrollStackView].forEach { myScrollView.addSubview($0) }
        myScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(payBtn.snp.top)
        }
        payBtn.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.11)
        }
        scrollStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(myScrollView)
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
    private func setCollectionView(){
        cardCV.cardCV.delegate = self
        cardCV.cardCV.dataSource = self
        let cellWidth = floor(cellSize.width)
        let cvInset = (view.bounds.width - cellWidth) / 2.0
        cardCV.cardCV.contentInset = UIEdgeInsets(top: 0, left: cvInset, bottom: 0, right: cvInset)
    }
}
extension OrderPayViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
extension OrderPayViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.registerID, for: indexPath) as? CardCollectionViewCell else {
            return UICollectionViewCell()
        }
        if indexPath.row == 0 && isFirst {
            isFirst = false
        } else {
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        return cell
    }
}
extension OrderPayViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return cellSize
    }
}
extension OrderPayViewController : UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == cardCV.cardCV {
            let cellWidth = cellSize.width + 20
            var offset = targetContentOffset.pointee
            let index = (offset.x + scrollView.contentInset.left) / cellWidth
            let roundedIndex : CGFloat = round(index)
            offset = CGPoint(x: roundedIndex * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
            targetContentOffset.pointee = offset
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == cardCV.cardCV {
            let cellWidthSpacing = cellSize.width + 20
            let offsetX = cardCV.cardCV.contentOffset.x
            let index = (offsetX + cardCV.cardCV.contentInset.left) / cellWidthSpacing
            let roundedIdx = round(index)
            let indexPath = IndexPath(item: Int(roundedIdx), section: 0)
            if let cell = cardCV.cardCV.cellForItem(at: indexPath) {
                animateZoomforCell(zoomCell: cell, idxrow: indexPath.row)
            }
            if Int(roundedIdx) != previousIndex {
                let preIdx = IndexPath(item: previousIndex, section: 0)
                if let preCell = cardCV.cardCV.cellForItem(at: preIdx) {
                    animateZoomforCellremove(removeCell: preCell)
                }
                previousIndex = indexPath.item
            }
        }
    }
    private func animateZoomforCell(zoomCell: UICollectionViewCell, idxrow : Int) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {zoomCell.transform = .identity}, completion: nil)
        
    }
    private func animateZoomforCellremove(removeCell: UICollectionViewCell) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {removeCell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)}, completion: nil)
    }
}
extension OrderPayViewController {
    @objc private func payBtnTapped(){
        let nextVC = UINavigationController(rootViewController: PayFinishViewController())
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
}
