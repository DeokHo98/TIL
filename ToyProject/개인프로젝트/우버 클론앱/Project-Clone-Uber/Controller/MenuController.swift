//
//  MenuController.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/25.
//

import UIKit
import Firebase

protocol MenuControllerDelegates: AnyObject {
    func didSelect(option: MenuOptions)
}

 enum MenuOptions: Int, CaseIterable, CustomStringConvertible {
    var description: String {
        switch self {
        case .yourTrips:
            return "나의 운행"
        case .settings:
            return "자주가는 위치"
        case .logOut:
            return "로그아웃"
        }
    }
    
    case yourTrips
    case settings
    case logOut
}

class MenuController: UIViewController {

    //MARK: - 속성
    
    
    weak var delegate: MenuControllerDelegates?
    
    private let tableView = UITableView()
    
    private let menuHeader = MenuHeader()
    
    private var user: User!
    
    
    //MARK: - 라이프사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        fetchUserData()
    }
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 셀렉터
    
    //MARK: - 도움메서드
    
    
    
    func fetchUserData() {
        menuHeader.fullNameLabel.text = user.fullName
        menuHeader.emailLabel.text = user.email
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(menuHeader)
        menuHeader.anchor(top:view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailng: view.trailingAnchor,paddingBottom: view.frame.height - 140)
        
        
        
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.anchor(top:menuHeader.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailng: view.trailingAnchor)
        tableView.rowHeight = 60
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    
    }
    


  

    
}

//MARK: - 테이블뷰 델리게이트 데이터소스


extension MenuController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let option = MenuOptions(rawValue: indexPath.row) else {return UITableViewCell()}
        cell.textLabel?.text = option.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = MenuOptions(rawValue: indexPath.row) else {return}
        delegate?.didSelect(option: option)
    }


}
