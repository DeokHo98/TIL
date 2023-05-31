//
//  OrderHistoryViewController.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/13.
//

import UIKit
import SnapKit

final class OrderHistoryViewController: UIViewController {

    // MARK: - UI Properties

    private let orderHistoryTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setOrderHistoryTableView()
        setLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        setNavigation()
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - setLayout

    private func setLayout() {
        view.backgroundColor = .white
        view.addSubview(orderHistoryTableView)
        orderHistoryTableView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
            make.bottom.equalTo(view.snp.bottomMargin)
        })
    }

    // MARK: - setOrderHistoryTableView

    private func setOrderHistoryTableView() {
        orderHistoryTableView.dataSource = self
        orderHistoryTableView.delegate = self
        orderHistoryTableView.register(
            OrderHistoryTableViewCell.self,
            forCellReuseIdentifier: "cellID"
        )
        orderHistoryTableView.backgroundColor = .systemGray5
    }

    // MARK: - setNavigation

    private func setNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "주문내역"
    }

    // MARK: - Methods
    
    private func fetchOrderHistory() {
        orderHistoryTableView.reloadData()
    }
    @objc private func writeStoryButtonTapped() {
        let nextViewController = WriteStoryViewController()
        nextViewController.navigationController?.setToolbarHidden(false, animated: true)
        nextViewController.navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension OrderHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let dequecell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        guard let cell = dequecell as? OrderHistoryTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.writeStoryButton.addTarget(self,
                                        action: #selector(writeStoryButtonTapped),
                                        for: .touchUpInside
        )
        return cell
    }
}
