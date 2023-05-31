//
//  OrderMenuViewController.swift
//  Project-ClonePassOrder
//
//  Created by miori Lee on 2022/05/17.
//

import Foundation
import SnapKit
import Firebase

protocol OrderMenuDelegate {
    func checkDidOrder()
}
class OrderMenuViewController : UIViewController {
    let searchBar = OrderMenuSearchBar()
    let categoryCV = MenuCollectionView()
    let categoryCVVM = MenuCollectionViewModel()
    let categoryCellVM = MenuCollectionCellViewModel()
    let menuTV = DetailMenuTableView()
    let menuTVVM = DetailMenuTableViewModel()
    let btnContainView = OrangeSelectButton()
    var didOrder : Bool = false
    var delegate : OrderMenuDelegate?
    var cvCellSelected : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
        setLeftBarButtonItem()
        categoryCVVM.fetchMenu()
        menuTVVM.fetchMenu(categoris: ["7디저트","6블랙펄","5차","4스무디,쉐이크","3주스,에이드","2빽스치노","1음료","0커피"])
        setCollectionView()
        setTabelView()
        bind(categoryCVVM, menuTVVM)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if didOrder {
            print("주문됨")
            changeTableViewLayout()
            btnContainView.isHidden = false
        } else {
            btnContainView.isHidden = true
            resetTableViewLayout()
        }
    }
}
extension OrderMenuViewController {
    private func setAttribute(){
        view.backgroundColor = .white
        self.title = "빽다방 미사스마트밸리점"
        btnContainView.isHidden = true
        btnContainView.getButton.setTitle("장바구니 보기", for: .normal)
        btnContainView.getButton.addTarget(self, action: #selector(payTapped), for: .touchUpInside)
    }
    private func setLayout(){
        [searchBar,categoryCV,menuTV,btnContainView].forEach {self.view.addSubview($0)}
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        categoryCV.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.05)
        }
        menuTV.snp.makeConstraints {
            $0.top.equalTo(categoryCV.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        btnContainView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.11)
        }
    }
    private func changeTableViewLayout(){
        menuTV.snp.remakeConstraints { make in
            make.top.equalTo(categoryCV.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(btnContainView.snp.top)
        }
    }
    private func resetTableViewLayout(){
        menuTV.snp.remakeConstraints { make in
            make.top.equalTo(categoryCV.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    private func setLeftBarButtonItem(){
        let leftBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(backButtonTapped))
        leftBarButton.tintColor = .black
        navigationItem.leftBarButtonItem = leftBarButton
    }
    private func setCollectionView() {
        categoryCV.delegate = self
        categoryCV.dataSource = self
    }
    private func setTabelView(){
        menuTV.delegate = self
        menuTV.dataSource = self
    }
    private func bind(_ viewModel : MenuCollectionViewModel, _ tableviewvm : DetailMenuTableViewModel) {
        categoryCV.setBind(viewModel)
        menuTV.setBind(tableviewvm)
    }
}
extension OrderMenuViewController {
    @objc func backButtonTapped(){
        self.dismiss(animated: true)
    }
    @objc func payTapped() {
        let nextVC = UINavigationController(rootViewController:  OrderPayViewController())
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC,animated: true)
    }
}
extension OrderMenuViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("cnt:\(categoryCVVM.numberOfCategoryArr)")
        return categoryCVVM.numberOfCategoryArr
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.registerID, for: indexPath) as? MenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        let categoryName = categoryCVVM.getCategoryName(index: indexPath.row)
        cell.setData(categoryName)
        if indexPath.row == categoryCVVM.defaultItemIdx {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cvCellSelected = true
        let tIndexPath = IndexPath(row: 0, section: indexPath.row)
        menuTV.scrollToRow(at: tIndexPath, at: .top, animated: true)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}
extension OrderMenuViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let categoryName = categoryCVVM.getCategoryName(index: indexPath.row).categoryName
        let cellWidth = categoryName.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]).width + 10
        let cellHeight = collectionView.frame.height * 0.6
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        
        return cellSize
    }
}
extension OrderMenuViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //return menuTVVM.numberOfCategoryArrForHeader
        return categoryCVVM.numberOfCategoryArr
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return menuTVVM.getCategoryName(index: section).categoryName
        return categoryCellVM.changeDataFormat(categoryCVVM.getCategoryName(index: section)).categoryName
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .systemGray5
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .black
        header.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ScreenConstant.deviceHeight * 0.05
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return menuTVVM.numberOfMenuArr
        return menuTVVM.getNumberOfMenuArr(index: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailMenuTableViewCell.registerID, for: indexPath) as? DetailMenuTableViewCell else {
            return UITableViewCell()
        }
        let menuItem  = menuTVVM.getMenuName(section: indexPath.section, index: indexPath.row)
        cell.setData(menuItem)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = OrderMenuDetailViewController()
        nextVC.preVC = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}
extension OrderMenuViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.menuTV && !cvCellSelected {
            let topSectionIndex = self.menuTV.indexPathsForVisibleRows?.map({ $0.section }).sorted().first
            let selectedCollectionIndex = self.categoryCV.indexPathsForSelectedItems?.first?.row
            if selectedCollectionIndex != topSectionIndex {
                let indexPath = IndexPath(item: topSectionIndex!, section: 0)
                self.categoryCV.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.menuTV {
            cvCellSelected = false
        }
    }
}
