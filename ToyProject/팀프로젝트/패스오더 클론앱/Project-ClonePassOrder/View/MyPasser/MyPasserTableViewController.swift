//
//  MyPasserViewController.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/13.
//

import UIKit

class MyPasserTableViewController: UITableViewController {
    
    let authViewModel: AuthViewModel = AuthViewModel()

    //MARK: - 라이프사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAtrribute()
        setNaviAtrribute()
        setBinding()
    }
    
    //MARK: - 메서드
    private func setAtrribute() {
        tableView.register(
            MyPasserCell.self,
            forCellReuseIdentifier: MyPasserCell.identifier
        )
        let headerView = MyPasserHeader(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 120))
        tableView.tableHeaderView = headerView
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
    }
    private func setNaviAtrribute() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "마이패써"
    }
    private func setBinding() {
        authViewModel.authError.bind { [weak self] error in
            Toast.message(superView: self!.view, text: error.errorMessage)
        }
        authViewModel.logoutSuccess.bind { _ in
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            guard let delegate = sceneDelegate else {
                return
            }
            let navi = UINavigationController(rootViewController: LoginViewController())
            delegate.window?.rootViewController = navi
        }
    }
    
    //MARK: - 테이블뷰 데이터소스

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 5
        case 2:
            return 4
        default:
            return 0
        }
    }
    override func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 10
    }
    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        switch section {
        case 0:
            return "마이 페이지"
        case 1:
            return "모아 보기"
        case 2:
            return "설정"
        default:
            return ""
        }
    }
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MyPasserCell.identifier,
            for: indexPath
        ) as! MyPasserCell
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.label.text = "📄   내 스토리"
                return cell
            case 1:
                cell.label.text = "🪙   내 포인트/스탬프"
                return cell
            case 2:
                cell.label.text = "🏷   내 쿠폰"
                return cell
            case 3:
                cell.label.text = "💳   내 카드"
                return cell
            default:
                return cell
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.label.text = "💰   패스머니"
                return cell
            case 1:
                cell.label.text = "📞   전화주문 이벤트"
                return cell
            case 2:
                cell.label.text = "✉️   친구 초대하기"
                return cell
            case 3:
                cell.label.text = "❗️   공지사항/이벤트"
                return cell
            case 4:
                cell.label.text = "🔎   자주 묻는 질문"
                return cell
            default:
                return cell
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.label.text = "😀   프로필 수정"
                return cell
            case 1:
                cell.label.text = "⏱   알림 설정"
                return cell
            case 2:
                cell.label.text = "📱   버전 정보"
                return cell
            case 3:
                cell.label.text = "🚪   로그아웃"
                return cell
            default:
                return cell
            }
        default:
            return cell
        }
        
    }
}

//MARK: - 테이블뷰 델리게이트

extension MyPasserTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 3 {
                authViewModel.logout()
            }
        }
    }
}
