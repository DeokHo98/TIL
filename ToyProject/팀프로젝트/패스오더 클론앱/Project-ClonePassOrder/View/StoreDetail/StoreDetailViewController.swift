//
//  StoreDetailTableViewController.swift
//  Project-ClonePassOrder
//
//  Created by Eunsoo KIM on 2022/05/26.
//

import UIKit
import SnapKit

class StoreDetailViewController: UIViewController {
    enum SelectedView {
        case infoView
        case storyView
    }

    // MARK: - Properties
    
    var favoriteViewModel: FavoriteListViewModel = FavoriteListViewModel()
    var cafeDetailViewModel: CafeListViewModelItem
    var storyViewModel: StoryListViewModel = StoryListViewModel()
    var currentSelectedView: SelectedView = .infoView

    // MARK: - UI Properties

    private let storeDetailTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.sectionFooterHeight = 0
        return tableView
    }()
    private let floatingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let floatingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("메뉴 보기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        return button
    }()
    private lazy var favoriteButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: #selector(buttonTapped)
        )
        bt.tintColor = .black
        return bt
    }()

    // MARK: - viewLifeCycle
    
    init(viewModel: CafeListViewModelItem) {
        self.cafeDetailViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        storyViewModel.fetchStory(name: cafeDetailViewModel.name)
        setTableView()
        setLayout()
        favoriteViewModel.existsFavorite(model: cafeDetailViewModel.model)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavi()
    }

    // MARK: - setLayout

    private func setLayout() {
        view.addSubview(storeDetailTableView)
        view.addSubview(floatingView)
        view.bringSubviewToFront(floatingView)
        floatingView.addSubview(floatingButton)
        
        floatingView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
            make.height.equalTo(100)
        }
        floatingButton.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(20)
        }
        storeDetailTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(floatingView.snp.top)
        }
    }
    
    //MARK: - setNavi
    
    func setNavi() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = favoriteButton
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - setTableView

    private func setTableView() {
        storeDetailTableView.delegate = self
        storeDetailTableView.dataSource = self
        storeDetailTableView.register(StoreDetailTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        storeDetailTableView.register(StoreDetailInfoTableViewCell.self, forCellReuseIdentifier: "infocell")
        storeDetailTableView.register(StoryTableViewCell.self, forCellReuseIdentifier: "storycell")
    }

    // MARK: - Methods

    func reloadstoreDetailTableView() {
        storeDetailTableView.reloadData()
    }
    @objc func informationButtonTapped() {
        switch currentSelectedView {
            case .infoView:
                return
            case .storyView:
                currentSelectedView = .infoView
                reloadstoreDetailTableView()
        }
    }
    @objc func storyButtonTapped() {
        switch currentSelectedView {
            case .infoView:
                currentSelectedView = .storyView
                reloadstoreDetailTableView()
        case .storyView:
            return
        }
    }
    @objc func buttonTapped() {
        let bool = favoriteViewModel.favoriteBool.value
        if bool {
            favoriteViewModel.deleteFavorite(model: cafeDetailViewModel.model)
        } else {
            favoriteViewModel.addFavorite(model: cafeDetailViewModel.model)
        }
     }
    
    //MARK: - 바인딩
    func binding() {
        storyViewModel.storyServiceError.bind { [weak self] error in
            Toast.message(superView: self!.view, text: error.message)
            self!.storyViewModel.fetchStory(name: self!.cafeDetailViewModel.name)
        }
        favoriteViewModel.favoriteBool.bind { [self] bool in
            if bool {
                favoriteButton.image = UIImage(systemName: "heart.fill")
                favoriteButton.tintColor = .red
            } else {
                favoriteButton.image = UIImage(systemName: "heart")
                favoriteButton.tintColor = .black
            }
        }
    }
   
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension StoreDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentSelectedView {
        case .infoView:
            return 1
        case .storyView:
            return storyViewModel.count()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentSelectedView {
        case .infoView:
            let dequedCell = tableView.dequeueReusableCell(withIdentifier: "infocell")
            guard let cell = dequedCell as? StoreDetailInfoTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.viewModel = cafeDetailViewModel
            return cell
        case .storyView:
            let dequedCell = tableView.dequeueReusableCell(withIdentifier: "storycell")
            guard let cell = dequedCell as? StoryTableViewCell else {
                return UITableViewCell()
            }
            cell.viewModel = storyViewModel.itemAtIndex(indexPath.row)
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dequedHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        guard let headerView = dequedHeaderView as? StoreDetailTableViewHeaderView else {
            return UIView()
        }
        headerView.viewModel = cafeDetailViewModel
        headerView.informationButton.addTarget(self, action: #selector(informationButtonTapped), for: .touchUpInside)
        headerView.storyButton.addTarget(self, action: #selector(storyButtonTapped), for: .touchUpInside)
        return headerView
    }
}
