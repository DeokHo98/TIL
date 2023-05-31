//
//  SearchViewController.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/17.
//

import UIKit
import NMapsMap

protocol SearchViewDelegate: AnyObject {
    func locationData(lating: NMGLatLng)
}


class SearchViewController: UIViewController {
    
    
    
    //MARK: - 속성
    
    var delegate: SearchViewDelegate?
    
    //서치 뷰모델
    var searchViewModel: SearchViewModel?
    
    //키보드가 보이는지 안보이는지에 대한 bool값
    private var keyboard = true
    
    //검색할때 호출되는 인디게이터뷰
    private let activity = UIActivityIndicatorView()
    
    
    //탑뷰
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    //바텀뷰
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addShadow()
        return view
    }()
    
    
    //서치 텍스트필드
    private let textfield: UITextField = {
        let tf = UITextField()
        tf.returnKeyType = .search
        tf.borderStyle = .none
        tf.tintColor = .lightGray
        tf.attributedPlaceholder = NSAttributedString(string: "지명 또는 건물명 검색", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        tf.textColor = .black
        tf.keyboardAppearance = .light
        tf.keyboardType = .default
        tf.backgroundColor = .white
        tf.setHeight(50)
        tf.font = .systemFont(ofSize: 18)
        
        return tf
    }()
    
    //백 버튼
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "arrow.backward"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        return button
    }()
    
    //테이블뷰
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        return tv
    }()
    
    private let nillView = UILabel().nillLabel(text: "검색 결과가 없습니다.")
    
    
    
    //MARK: - 라이프사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    //MARK: - 도움메서드
    
    private func configure() {
        view.backgroundColor = .white
        
        view.addSubview(topView)
        topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 60)
        
        view.addSubview(searchButton)
        searchButton.anchor(leading: view.leadingAnchor,paddingLeading: 20,width: 30, height: 40)
        searchButton.centerY(inView: topView)
        
        view.addSubview(textfield)
        textfield.delegate = self
        textfield.centerY(inView: searchButton)
        textfield.anchor(leading: searchButton.trailingAnchor, trailing: view.trailingAnchor, paddingLeading: 20, paddingTrailing: 20)
        
        view.addSubview(bottomView)
        bottomView.anchor(top: topView.bottomAnchor, leading: view.leadingAnchor,trailing: view.trailingAnchor, height: 5)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        
        
        view.addSubview(tableView)
        tableView.anchor(top: bottomView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor ,trailing: view.trailingAnchor)
        
    }
    
    private func searhViewModelClosure() {
        searchViewModel?.loddingStart = { [weak self] in
            self?.activityON()
        }
        
        searchViewModel?.lodingEnd = { [weak self] in
            self?.activityOFF()
        }
        
        
    }
    
    
    //액티비티 뷰 메서드
    private func activityON() {
        view.addSubview(activity)
        activity.tintColor = .gray
        activity.centerX(inView: view)
        activity.centerY(inView: view)
        activity.startAnimating()
    }
    
    private func activityOFF() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.activity.stopAnimating()
            self?.activity.removeFromSuperview()
        }
    }
    
    
    
    
    
    //MARK: - 셀렉터 메서드
    //백 버튼을 눌렀을때
    @objc private func backButtonTap() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - 텍스트필드 델리게이트
extension SearchViewController: UITextFieldDelegate {
    //텍스트필드가 켜지기 직전
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchViewModel = SearchViewModel()
        searhViewModelClosure()
        keyboard = true
        searchButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        textfield.attributedPlaceholder = nil
    }
    
    //텍스트필드에서 서치버튼을 눌렀을때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textfield.text else {return true}
        searchViewModel?.fetch(searhText: text)
        textfield.resignFirstResponder()
        
        return true
    }
    
}

//MARK: - 테이블뷰 데이터소스
extension SearchViewController: UITableViewDataSource {
    //테이블뷰의 셀의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchViewModel?.count() == 0 {
            view.addSubview(nillView)
            nillView.centerY(inView: view)
            nillView.centerX(inView: view)
        } else {
            nillView.removeFromSuperview()
        }
        
        return searchViewModel?.count() ?? 0
    }
    
    //테이블뷰의 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell
        cell.backgroundColor = .white
        cell.namelabel.text = searchViewModel?.name(index: indexPath.row)
        cell.adressLabel.text = searchViewModel?.address(index: indexPath.row)
        return cell
    }
    
    //셀의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
        
    }
    
    
}


//MARK: - 테이블뷰 델리게이트
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let lating = searchViewModel?.lating(index: indexPath.row) else {return}
        delegate?.locationData(lating: lating)
        navigationController?.popViewController(animated: true)
        
        
    }
}

//MARK: - 스크롤 델리게이트
extension SearchViewController: UIScrollViewDelegate {
    //키보드가 보일때 keboard = true로 키보드를 내려야할때는 false 로 해서
    //스크롤할때 keyboard를 내리는 메서드
    //대신 키보드를 한번더 내린후에는 다시 false로 설정해줘서 중복으로 계속호출되는걸 방지
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if keyboard {
            view.endEditing(true)
            keyboard = false
        }
    }
}
