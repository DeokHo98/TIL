//
//  FavoriteController.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/19.
//

import UIKit

protocol FavoriteDelegate: AnyObject {
    func seleted(name: String, address: String)
}

class FavoriteController: UITableViewController {
    
    
    let viewModel: FavoriteViewModel = FavoriteViewModel()
    
    weak var delegate: FavoriteDelegate?
    
    private let nillview: UILabel = UILabel().nillLabel(text: "즐겨찾기 하신 병원이 없습니다.")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "뒤로가기"
        
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = "즐겨찾기"
        
        viewModel.fetch()
        
        tableView.rowHeight = 90
        tableView.separatorInset.left = 0
        tableView.backgroundColor = .white
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
        
        if viewModel.count == 0 {
            view.addSubview(nillview)
            nillview.centerY(inView: view)
            nillview.centerX(inView: view)
        }
    }
    
    //MARK: - 테이블뷰 데이터소스
    
    //테이블뷰의 셀의 갯수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    //테이블뷰의 셀
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier, for: indexPath) as! FavoriteCell
        cell.selectionStyle = .none
        cell.nameLabel.text = viewModel.coreDataModels[indexPath.row].name
        cell.addressLabel.text = viewModel.coreDataModels[indexPath.row].address
        return cell
    }
    
    
    //MARK: - 테이블뷰 델리게이트
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let name = viewModel.coreDataModels[indexPath.row].name else {return}
        guard let address = viewModel.coreDataModels[indexPath.row].address else {return}
        delegate?.seleted(name: name, address: address)
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
}
