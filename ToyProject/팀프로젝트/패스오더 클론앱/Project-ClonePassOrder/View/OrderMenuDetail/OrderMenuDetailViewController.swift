//
//  OrderMenuDetailViewController.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/19.
//

import Foundation
import SnapKit

class OrderMenuDetailViewController : UIViewController {
    let detailTV = OrderMenuDetailTableView()
    let btnContainView = OrangeSelectButton()
    var quantityCnt : Int = 1
    var btnTapCnt : Int = 0
    var ableToOrder : Bool = false
    var preVC : OrderMenuViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
        setTableView()
    }
}
extension OrderMenuDetailViewController {
    private func setAttribute(){
        preVC?.delegate = self
        view.backgroundColor = .white
        self.title = "빽다방 미사스마트밸리점"
        btnContainView.layer.opacity = 0.5
        btnContainView.getButton.addTarget(self, action: #selector(getBtnTapped), for: .touchUpInside)
    }
    private func setLayout(){
        [detailTV,btnContainView].forEach {self.view.addSubview($0)}
        detailTV.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.89)
        }
        btnContainView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.11)
        }
    }
    private func setTableView(){
        detailTV.delegate = self
        detailTV.dataSource = self
    }
    private func checkCnttoOpactity() {
        if !ableToOrder{
            btnContainView.layer.opacity = 0.5
        } else {
            btnContainView.layer.opacity = 1
        }
    }
}

extension OrderMenuDetailViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return "얼음선택(필수)"
        } else {
            return " "
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? 32 : CGFloat.leastNonzeroMagnitude
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .black
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .heavy)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 2
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            guard let cell1 = tableView.dequeueReusableCell(withIdentifier: OrderMenuDetailInfoCell.registerID, for: indexPath) as? OrderMenuDetailInfoCell else { return UITableViewCell() }
            cell = cell1
        } else if indexPath.section == 1 {
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: QuantitySelectCell.registerID, for: indexPath) as? QuantitySelectCell else { return UITableViewCell() }
            cell2.delegate = self
            cell = cell2
        } else if indexPath.section == 2 {
            guard let cell3 = tableView.dequeueReusableCell(withIdentifier: IceSelectCell.registerID, for: indexPath) as? IceSelectCell else { return UITableViewCell() }
            cell3.moneyCircleBtn.tag = indexPath.row
            cell3.delegate = self
            cell = cell3
        }
        cell.selectionStyle = .none
        return cell
    }
}
extension OrderMenuDetailViewController : QuantitySelectCellDelegate {
    func quantityBtnTapped(_ sender: UIButton, _ at: UILabel) {
        if sender.tag == 0 && quantityCnt > 1 {
            quantityCnt -= 1
        } else if sender.tag == 1 {
            quantityCnt += 1
        }
        at.text = "\(quantityCnt)"
    }
}
extension OrderMenuDetailViewController: OptionCellDelegate {
    func optionTapped(_ sender: UIButton) {
        btnTapCnt += 1
        if btnTapCnt % 2 == 1 {
            sender.tintColor = .orange
            sender.setTitleColor(.orange, for: .normal)
            sender.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
            ableToOrder = true
        } else {
            sender.tintColor = .lightGray
            sender.setTitleColor(.lightGray, for: .normal)
            sender.setImage(UIImage(systemName: "circle"), for: .normal)
            ableToOrder = false
        }
        //print(sender.tag)
        checkCnttoOpactity()
    }
}
extension OrderMenuDetailViewController {
    @objc func getBtnTapped(){
        checkDidOrder()
    }
}
extension OrderMenuDetailViewController : OrderMenuDelegate{
    func checkDidOrder() {
        preVC?.didOrder = true
        self.navigationController?.popViewController(animated: false)
    }
    
    
}
