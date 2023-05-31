//
//  DetailView.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/16.
//

import UIKit
import MapKit
//import TMapSDK

//스크롤을 아래로 내린뒤의 시점을 델리게이트패턴으로 전송
protocol DetailViewDelegate: AnyObject {
    func scrollDown()
    
    func showEditView(name: String)
    
}


class DetailView: UIView {
    
    
    
    
    //MARK: - 디테일 속성
    
    weak var delegate: DetailViewDelegate?
    
    var viewModel: DetailViewModel? {
        didSet {
            self.imageView.image = nil
            imageFetch()
            tableView.reloadData()
        }
    }
    
    let favoriteviewModel: FavoriteViewModel = FavoriteViewModel()
    
    var currentFavorite: Bool = false
    
    //이미지 뷰
     lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.customGrayColor
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    //상단에 보여지는 작은 뷰
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customGrayColor
        view.setHeight(5)
        view.setWidth(40)
        view.layer.cornerRadius = 5  / 2
        return view
    }()
    
    
    
    //복사했을때 뜨는 토스트메시지
    private let toastLabel = UILabel().toastLabel(text: "복사되었습니다")
    
    //테이블뷰
    private var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    
    
    
    //MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init")
    }
    
    
    //MARK: - 셀렉터메서드
    

    
    
    //MARK: - 뷰 도움메서드
    private func configure() {
        
        self.backgroundColor = .white
        self.addShadow()
        self.addSubview(topView)
        topView.centerX(inView: self)
        topView.anchor(top: self.topAnchor, paddingTop: 10)
        
        
        self.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailHeader.self, forHeaderFooterViewReuseIdentifier: DetailHeader.identifier)
        tableView.register(DetailFooter.self, forHeaderFooterViewReuseIdentifier: DetailFooter.identifier)
        tableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell.identifier)
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
        tableView.anchor(top: topView.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor,trailing: self.trailingAnchor, paddingTop: 20)
        
       
       
        
        
        
    }
    
    
    
    //MARK: - 도움메서드
    func showUp() {
        self.addSubview(imageView)
        imageView.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, height: (self.frame.height) / 3)
        
        topView.removeFromSuperview()
        
        tableView.anchor(top: imageView.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor,paddingTop: 20)
        tableView.isScrollEnabled = true
    }
    
    func showDown() {
        imageView.removeFromSuperview()
        
        self.addSubview(topView)
        topView.centerX(inView: self)
        topView.anchor(top: self.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
        
        tableView.anchor(top: topView.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor,paddingTop: 20)
        tableView.contentOffset = CGPoint(x: 0, y: 0 - (tableView.contentInset.top))
        tableView.isScrollEnabled = false
        
    }
    
    private func fetchFavorite(image: UIImageView) {
         guard let viewModel = viewModel else {return}
        favoriteviewModel.fetch()
        for model in favoriteviewModel.coreDataModels {
            if model.name == viewModel.name {
                currentFavorite = true
                image.tintColor = .yellow
                break
            } else {
                currentFavorite = false
                image.tintColor = .white
            }
        }
     }
    
    private func showToast() {
            self.addSubview(toastLabel)
            toastLabel.centerX(inView: self)
            toastLabel.anchor(bottom: self.bottomAnchor, paddingBottom: 50,width: 200)
       
       
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            self?.toastLabel.removeFromSuperview()
        }
    }
    
    private func imageFetch() {
        guard let viewModel = viewModel else {return}
        ImageLoader.fetchImage(url: viewModel.imageURL) { [weak self] image in
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
    }
    
    
    
}
extension DetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.identifier, for: indexPath) as! DetailCell
        guard let viewModel = viewModel else {return cell}
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.detailLabel.text = viewModel.runtime
            cell.cellLabel.text = "운영시간"
            return cell
        case 1:
            cell.detailLabel.text = viewModel.tax
            cell.cellLabel.text = "야간할증"
            return cell
        case 2:
            cell.detailLabel.attributedText = NSMutableAttributedString().detailString(text: viewModel.address + "    복사")
            cell.cellLabel.text = "병원주소"
            return cell
        case 3:
            cell.detailLabel.attributedText = NSMutableAttributedString().detailString(text: viewModel.phoneNumber + "    복사")
            cell.cellLabel.text = "전화번호"
            return cell
        default:
            return cell
        }
    }
    
    
}

//MARK: - 테이블뷰 델리게이트

extension DetailView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            UIPasteboard.general.string = viewModel?.address
            showToast()
            
            
        case 3: UIPasteboard.general.string = viewModel?.callNumber
            showToast()
        default: return
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailHeader.identifier) as! DetailHeader
        guard let viewModel = viewModel else {return header}
        fetchFavorite(image: header.image)
        header.nameLabel.text = viewModel.name
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailFooter.identifier) as! DetailFooter
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 145
    }
}


//MARK: - 스크롤뷰 델리게이트
extension DetailView: UIScrollViewDelegate {
    //테이블뷰의 contentoffset.y 가 0보다 작은경우라면 뷰를 내린다
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (tableView.contentOffset.y) < 0 {
            delegate?.scrollDown()
        }
    }
}

//MARK: - 헤더 델리게이트
extension DetailView: DetailHeaderDelegate {
    
     func tabNavi() {
//         guard let viewModel = viewModel else {return}
//         let TmapBool = TMapApi.isTmapApplicationInstalled()
//         if TmapBool {
//             TMapApi.invokeRoute(viewModel.name, coordinate: CLLocationCoordinate2D(latitude: viewModel.x, longitude: viewModel.y))
//         } else {
//             let appstoreUrl = TMapApi.getTMapDownUrl()
//             guard let url = URL(string: appstoreUrl) else {return}
//             UIApplication.shared.open(url, options: [:], completionHandler: nil)
//         }
    }
    
    func tabFavorite(imageView: UIImageView) {
        guard let viewModel = viewModel else { return}
        if currentFavorite {
            favoriteviewModel.fetch()
            for model in favoriteviewModel.coreDataModels {
                if model.name == viewModel.name && model.address == viewModel.address {
                    currentFavorite = false
                    imageView.tintColor = .white
                    CoreDataService.deleteCoreData(model: model)
                }
            }
        } else {
            CoreDataService.uploadCoreData(name: viewModel.name, address: viewModel.address)
            currentFavorite = true
            imageView.tintColor = .yellow
        }
    }
    
    func showEdit() {
        guard let viewModel = viewModel else { return}
        delegate?.showEditView(name: viewModel.name)
    }
    
    func tapCall() {
        guard let viewModel = viewModel else { return}
        if let url = URL(string: "tel://" + "\(viewModel.phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    
    
    
}

