//
//  SettingController.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/25.
//

import UIKit

protocol SettingControllerDelegate: AnyObject {
    func updateUser(_ controller: SettionController)
}

enum locationType: Int, CaseIterable, CustomStringConvertible {
    case home
    case work
    
    var description: String {
        switch self {
        case .home:
            return "집"
        case .work:
            return "직장"
        }
    }
    
    var subtitle: String {
        switch self {
        case .home:
            return "집 추가하기"
        case .work:
            return "직장 추가하기"
        }
    }
}

class SettionController: UITableViewController {
    
    //MARK: - 속성
    
     var user: User
    private let locationManger = LocationHnadler.shared.locationManager
    weak var delegate: SettingControllerDelegate?
    var userInfoUpdated = false
    
    
    
    //MARK: - 라이프사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confugureNavigationBar()
        confiureTableView()

        
        
    }
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 셀렉터
    
    @objc func handleDismissal() {
        if userInfoUpdated {
            delegate?.updateUser(self)
        }
        
        self.dismiss(animated: true, completion: nil)
        
 
    }
    
    //MARK: - 도움 메서드
    
    func confiureTableView() {
        tableView.rowHeight = 60
        tableView.register(LocationCell.self, forCellReuseIdentifier: "LocationCell")
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
    }
    
    func confugureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "자주가는 위치"
        navigationController?.navigationBar.barTintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "baseline_clear_white_36pt_2x")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
    }
    
    
    func locationText(forType type: locationType) -> String{
        switch type {
        case .home:
            return user.homeLocation ?? type.subtitle
        case .work:
            return user.workLocation ?? type.subtitle
        }
    }
}


//MARK: - 테이블뷰

extension SettionController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        guard let type = locationType(rawValue: indexPath.row) else { return cell}
        cell.type = type
        cell.addressLabel.text = locationText(forType: type)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = locationType(rawValue: indexPath.row) else { return }
        guard let location = locationManger?.location else {return}
        let controller = AddLocationController(type: type, location: location)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
    }
}

//MARK: - addlocaiton뷰 컨트롤러 델리게이트
extension SettionController: AddLocationContrllerDelegate {
    func updateLocation(locationString: String, type: locationType) {
        DriverService.shared.saveLocation(locationString: locationString, type: type) { error, ref in
            self.dismiss(animated: true, completion: nil)
            self.userInfoUpdated = true
            switch type {
            case .home:
                self.user.homeLocation = locationString
            case .work:
                self.user.workLocation = locationString
            }
            
            self.tableView.reloadData()
        }
    }
    
    
}
