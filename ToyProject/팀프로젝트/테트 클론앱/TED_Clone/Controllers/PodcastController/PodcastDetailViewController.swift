//
//  PodcastDetailViewController.swift
//  TED_Clone
//
//  Created by 정덕호 on 2022/03/02.
//

import UIKit

class PodcastDetailViewController: UIViewController {

    
//MARK: - Properties
    
  static var selectedNum = 0
    
    private let tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.backgroundColor = .backgroundColor
        tableview.separatorInset.left = 0
        tableview.separatorColor = UIColor(white: 1, alpha: 0.2)
        return tableview
    }()
    
    private let detailView: UIView = {
       let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }()

    var detailImage: UIImageView = {
        let image = UIImageView()
        image.image = PodcastViewModel.imageList[selectedNum].image
        return image
    }()
    
    
     var detailLabel: UILabel = {
        let label = UILabel()
         label.text = PodcastViewModel.nameList[selectedNum]
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    
    var detailText: UILabel = {
       let textview = UILabel()
        textview.text = PodcastViewModel.detailTextList[selectedNum]
        textview.textColor = .white
        textview.numberOfLines = 0
        textview.backgroundColor = .clear
        textview.font = UIFont.systemFont(ofSize: 17)
        return textview
    }()
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PodcastDetailViewCell.self, forCellReuseIdentifier: PodcastDetailViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.backButtonTitle = "TED 팟 캐스트"
        navigationController?.navigationBar.tintColor = .white
        makeLayout()
        

    }
    
    //MARK: - Helper Function
    private func makeLayout() {
        let newSize = detailText.sizeThatFits(view.frame.size)
        detailText.frame.size = newSize
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        tableView.addSubview(detailView)
        detailView.anchor(width: view.frame.width, height: 220 + detailText.frame.size.height)
        
        detailView.addSubview(detailImage)
        detailImage.anchor(top: detailView.topAnchor,left: detailView.leadingAnchor,paddingTop: 20,paddingLeft: 10,width: 150,height: 150)
        
        detailView.addSubview(detailLabel)
        detailLabel.anchor(left: detailImage.trailingAnchor, bottom: detailImage.bottomAnchor,right: detailView.trailingAnchor, paddingLeft: 10,paddingRight: 20)
        
        
        
        detailView.addSubview(detailText)
        detailText.anchor(top: detailImage.bottomAnchor,left: detailView.leadingAnchor,right: detailView.trailingAnchor,paddingTop: 20,paddingLeft: 10,paddingRight: 10)
        
    }


    
}

//MARK: - 테이블뷰 데이터 소스
extension PodcastDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch PodcastDetailViewController.selectedNum {
        case 0:
            return PodcastViewModel.nameList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PodcastDetailViewCell.identifier, for: indexPath) as? PodcastDetailViewCell else { return UITableViewCell() }
        switch PodcastDetailViewController.selectedNum {
        case 0:
            cell.nameLabel.text = PodcastViewModel.mp3NameList[indexPath.row]
            cell.timeLabel.attributedText  = PodcastViewModel.timeFetch(num: PodcastViewModel.mp3RunTimeList[indexPath.row], string: PodcastViewModel.mp3TimeList[indexPath.row], size: 13)
            return cell
        default:
            return cell
        }
    }
    
    
}



//MARK: - 테이블뷰 델리게이터

extension PodcastDetailViewController: UITableViewDelegate {
    //다이나믹셀 검색
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return detailView
        }
        return UIView()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PodcastPlayViewController.selectedNum = PodcastDetailViewController.selectedNum
        PodcastPlayViewController.mp3SelectedNum = indexPath.row
        navigationController?.pushViewController(PodcastPlayViewController(), animated: true)
    }
}



