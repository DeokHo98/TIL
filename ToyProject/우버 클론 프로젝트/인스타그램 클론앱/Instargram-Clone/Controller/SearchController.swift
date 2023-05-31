//
//  SearchController.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/03/22.
//

import UIKit



class SearchController: UITableViewController {
    
    
    //MARK: - 속성
    private var currentUser: User
    
    private var users = [User]()
    
    private var filterdUsers = [User]()
    //검색을 위한 네비게이션바 아이템중하나인 서치컨트롤러
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    //MARK: - 라이프사이클
    
    init(user: User) {
        self.currentUser = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureTableView()
        fetchAllUsers()
    
    }
    
    //MARK: - 도움 메서드
    
    func configureTableView() {
        view.backgroundColor = .white
        
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
    }
    
    func configureSearchController() {
        
        searchController.searchResultsUpdater = self
        //서치바를 클릭시에 주변 색이 어두워지면서 사용중이라는걸 나타나게하는? 그런것
        searchController.obscuresBackgroundDuringPresentation = false
        //서치바 사용중에 네비게이션바를 가리는 애니메이션이 추가되는 그런것
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "검색하기"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    
    //MARK: - API
    
    func fetchAllUsers() {
        UserService.fetchAllUsers { [self] user in
            let usersData = user.filter {
                $0.userName != currentUser.userName && $0.fullName != currentUser.fullName
            }
            users = usersData
            tableView.reloadData()
        }
    }
    
}

//MARK: - 테이블뷰 데이터소스
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filterdUsers.count : users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier,for: indexPath) as! SearchCell
        let user = inSearchMode ? filterdUsers[indexPath.row] : users[indexPath.row]
        cell.user = SearchViewModel(user: user)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}


//MARK: - 테이블뷰 델리게이트
extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filterdUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user, loadingBool: false)
        controller.navigationButtonBool = false
        navigationController?.pushViewController(controller, animated: true)
        
    }
}

//MARK: - 서치바 리절트 업데이팅
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
    
        filterdUsers = users.filter({
            //contains는 특정문자열이 있는지 없는지를 bool값으로 리턴해주는 함수
            $0.userName.contains(searchText) || $0.fullName.contains(searchText)
        }).filter({
            //현재 로그인한 유저의 이름과 데이터 역시 한번 걸러준다.
            $0.userName != currentUser.userName && $0.fullName != currentUser.fullName
        })
        
        tableView.reloadData()
    }
}
