//
//  HomeViewController.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/13.
//

import SnapKit
import UIKit

enum HomeState {
    case listView
    case mapView
}

class HomeViewController: UIViewController {
    
    //MARK: - 프로퍼티
    var cafeViewModel: CafeListViewModel
    var firstADListViewModel: ADListViewModel
    var secondADListViewModel: ADListViewModel
    private var homeState: HomeState = .listView
    private let searchButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.tintColor = .black
        bt.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        bt.setTitle("  매장 검색", for: .normal)
        bt.setTitleColor(.lightGray, for: .normal)
        bt.titleLabel?.font = .systemFont(ofSize: 18)
        return bt
    }()
    private let listButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("리스트로 주문", for: .normal)
        bt.titleLabel?.tintColor = .black
        bt.titleLabel?.font = .boldSystemFont(ofSize: 18)
        bt.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
        return bt
    }()
    private let mapButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.tintColor = .lightGray
        bt.setImage(UIImage(systemName: "map"), for: .normal)
        bt.setTitle(" 지도로 주문", for: .normal)
        bt.titleLabel?.tintColor = .lightGray
        bt.titleLabel?.font = .boldSystemFont(ofSize: 18)
        bt.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        return bt
    }()
    private let stateButtonSeparateView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private lazy var buttonStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [listButton,mapButton])
        st.axis = .horizontal
        st.distribution = .fillEqually
        st.spacing = 60
        return st
    }()
    private let mapView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    private lazy var listView: ListCollectionViewController = ListCollectionViewController(
        firstADViewModel: self.firstADListViewModel,
        secondADViewModel: self.secondADListViewModel,
        cafeViewModel: self.cafeViewModel
    )

    //MARK: - 라이프사이클
    
    init(
        firstADViewModel: ADListViewModel,
        secondADViewModel: ADListViewModel,
        cafeViewModel: CafeListViewModel
    ) {
        self.firstADListViewModel = firstADViewModel
        self.secondADListViewModel = secondADViewModel
        self.cafeViewModel = cafeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        naviSetAttribute()
        setAtrribute()
        setLayout()
        stateButtonTapped()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            navigationController?.navigationBar.isHidden = true
            tabBarController?.tabBar.isHidden = false
    }
   
    
    //MARK: - 셀렉터메서드
    
    @objc private func listButtonTapped() {
        homeState = .listView
        stateButtonTapped()
    }
    @objc private func mapButtonTapped() {
        homeState = .mapView
        stateButtonTapped()
    }
    @objc private func searchButtonTapped() {
        let vc = SearchCollectionViewController(viewModel: cafeViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - 메서드
    private func setLayout() {
        [searchButton,buttonStack,stateButtonSeparateView].forEach {
            view.addSubview($0)
        }
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        buttonStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(searchButton.snp.bottom).offset(20)
        }
        stateButtonSeparateView.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.top.equalTo(listButton.snp.bottom)
            make.leading.equalTo(listButton.snp.leading)
            make.trailing.equalTo(listButton.snp.trailing)
        }
    }
    
    private func setAtrribute() {
        view.backgroundColor = .systemBackground
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        listView.delegate = self
    }
    private func naviSetAttribute() {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    private func stateButtonTapped() {
        switch homeState {
        case .listView:
            listButton.titleLabel?.tintColor = .black
            mapButton.tintColor = .lightGray
            mapButton.titleLabel?.tintColor = .lightGray
            stateButtonSeparateView.snp.remakeConstraints { make in
                make.height.equalTo(3)
                make.top.equalTo(listButton.snp.bottom)
                make.leading.equalTo(listButton.snp.leading)
                make.trailing.equalTo(listButton.snp.trailing)
            }
            mapView.removeFromSuperview()
            view.addSubview(listView.view)
            listView.view.snp.makeConstraints { make in
                make.trailing.leading.equalToSuperview()
                make.top.equalTo(stateButtonSeparateView.snp.top).offset(10)
                make.bottom.equalTo(view.snp.bottomMargin)
            }
        case .mapView:
            listButton.titleLabel?.tintColor = .lightGray
            mapButton.tintColor = .black
            mapButton.titleLabel?.tintColor = .black
            stateButtonSeparateView.snp.remakeConstraints { make in
                make.height.equalTo(3)
                make.top.equalTo(mapButton.snp.bottom)
                make.leading.equalTo(mapButton.snp.leading)
                make.trailing.equalTo(mapButton.snp.trailing)
            }
            listView.view.removeFromSuperview()
            view.addSubview(mapView)
            mapView.snp.makeConstraints { make in
                make.trailing.leading.equalToSuperview()
                make.top.equalTo(stateButtonSeparateView.snp.top).offset(10)
                make.bottom.equalTo(view.snp.bottomMargin)
            }
        }
    }
}

//MARK: - 리스트컬렉션뷰 델리게이트

extension HomeViewController: ListCollectionViewDelegate {
    func footerTapped(title: String) {
        let vc = MoreCollectionViewController(viewModel: cafeViewModel)
        vc.naviTitle = title
        navigationController?.pushViewController(vc, animated: true)
    }
    func cellTapped(controller: StoreDetailViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
}


