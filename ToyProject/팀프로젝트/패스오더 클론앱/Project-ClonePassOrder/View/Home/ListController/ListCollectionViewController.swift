//
//  ListCollectionViewController.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/18.
//


import UIKit
import CoreLocation

protocol ListCollectionViewDelegate: AnyObject {
    func footerTapped(title: String)
    func cellTapped(controller: StoreDetailViewController)
}

class ListCollectionViewController: UICollectionViewController {
    
    //MARK: - 프로퍼티
    var cafeViewModel: CafeListViewModel
    var firstADListViewModel: ADListViewModel
    var secondADListViewModel: ADListViewModel
    weak var delegate: ListCollectionViewDelegate?
    
    //MARK: - 라이프사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAtrribute()
        setBinding()
    }
    init(
        firstADViewModel: ADListViewModel,
        secondADViewModel: ADListViewModel,
        cafeViewModel: CafeListViewModel
    ) {
        self.firstADListViewModel = firstADViewModel
        self.secondADListViewModel = secondADViewModel
        self.cafeViewModel = cafeViewModel
         let layout = UICollectionViewCompositionalLayout { section, env in
             switch section {
             case 0:
                 let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1),
                                      heightDimension: .fractionalHeight(1))
                 )
                 let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1),
                                      heightDimension: .absolute(110)),
                    subitems: [item])
                 let section = NSCollectionLayoutSection(group: group)
                 section.orthogonalScrollingBehavior = .none
                 section.contentInsets.top = 20
                 section.contentInsets.bottom = 80
                 section.contentInsets.leading = 50
                 return section
             case 1:
                 let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1),
                                      heightDimension: .fractionalHeight(1))
                 )
                 let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1),
                                      heightDimension: .absolute(105)),
                    subitems: [item])
                 let section = NSCollectionLayoutSection(group: group)
                 section.orthogonalScrollingBehavior = .none
                 section.contentInsets.top = 20
                 section.contentInsets.bottom = 40
                 section.contentInsets.leading = 50
                 section.contentInsets.trailing = -5
                 return section
             case 2:
                 let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .absolute(240),
                        heightDimension: .estimated(380))
                 )
                 item.contentInsets.trailing = 20
                 let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .absolute(240),
                                      heightDimension: .estimated(380)),
                    subitems: [item]
                 )
                 let section = NSCollectionLayoutSection(group: group)
                 section.orthogonalScrollingBehavior = .continuous
                 section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                            heightDimension: .absolute(80)),
                          elementKind: UICollectionView.elementKindSectionHeader,
                          alignment: .topLeading),
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                            heightDimension: .absolute(60)),
                          elementKind: UICollectionView.elementKindSectionFooter,
                          alignment: .bottomTrailing)
                 ]
                 section.contentInsets.top = 20
                 section.contentInsets.bottom = 50
                 section.contentInsets.leading = 50
                 return section
             case 3:
                 let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .absolute(350),
                        heightDimension: .estimated(300))
                 )
                 item.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 20)
                 let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(widthDimension: .absolute(350),
                                      heightDimension: .estimated(300)),
                    subitem: item, count: 3)
                 let section = NSCollectionLayoutSection(group: group)
                 section.orthogonalScrollingBehavior = .continuous
                 section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                            heightDimension: .absolute(80)),
                          elementKind: UICollectionView.elementKindSectionHeader,
                          alignment: .topLeading),
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                            heightDimension: .absolute(60)),
                          elementKind: UICollectionView.elementKindSectionFooter,
                          alignment: .bottomTrailing)
                 ]
                 section.contentInsets.leading = 50
                 section.contentInsets.top = 20
                 section.contentInsets.bottom = 50
                 return section
             case 4:
                 let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .absolute(240), heightDimension: .estimated(320))
                 )
                 item.contentInsets.trailing = 20
                 let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .absolute(240),
                                      heightDimension: .estimated(320)),
                    subitems: [item]
                 )
                 let section = NSCollectionLayoutSection(group: group)
                 section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                            heightDimension: .absolute(80)),
                          elementKind: UICollectionView.elementKindSectionHeader,
                          alignment: .topLeading),
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                            heightDimension: .absolute(60)),
                          elementKind: UICollectionView.elementKindSectionFooter,
                          alignment: .bottomTrailing)
                 ]
                 section.orthogonalScrollingBehavior = .continuous
                 section.contentInsets.leading = 50
                 section.contentInsets.top = 20
                 section.contentInsets.bottom = 50
                 return section
             case 5:
                 let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1),
                                      heightDimension: .estimated(390))
                 )
                 let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1),
                                      heightDimension: .estimated(390)),
                    subitems: [item])
                 let section = NSCollectionLayoutSection(group: group)
                 section.orthogonalScrollingBehavior = .none
                 section.contentInsets.top = 40
                 return section
             default:
                 return NSCollectionLayoutSection(
                    group: NSCollectionLayoutGroup(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .absolute(0), heightDimension: .absolute(0)
                        )
                    )
                 )
             }
         }
        super.init(collectionViewLayout: layout)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 메서드
    
    private func setAtrribute() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(
            FirstADCell.self,
            forCellWithReuseIdentifier: FirstADCell.identifier
        )
        collectionView.register(
            SecondADCell.self,
            forCellWithReuseIdentifier: SecondADCell.identifier
        )
        collectionView.register(
            FirstListCell.self,
            forCellWithReuseIdentifier: FirstListCell.identifier
        )
        collectionView.register(
            SecondListCell.self,
            forCellWithReuseIdentifier: SecondListCell.identifier
        )
        collectionView.register(
            ThirdListCell.self,
            forCellWithReuseIdentifier: ThirdListCell.identifier
        )
        collectionView.register(
            FourthListCell.self,
            forCellWithReuseIdentifier: FourthListCell.identifier
        )
        collectionView.register(
            ListCellHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ListCellHeader.identifier)
        
        collectionView.register(
            ListCellFooter.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: ListCellFooter.identifier)
    }
    private func setListCellHeader(
        header: ListCellHeader,
        firstText: String,
        secondText: String,
        rangeText: String,
        color: UIColor
    ) -> ListCellHeader {
        header.firstLabel.text = firstText
        header.secondLabel.text = secondText
        let attributedString = NSMutableAttributedString(string: header.secondLabel.text!)
        attributedString.addAttribute(
            .foregroundColor,
            value: color,
            range: (header.secondLabel.text! as NSString).range(of:rangeText))
        header.secondLabel.attributedText = attributedString
        return header
    }
    func setBinding() {
        cafeViewModel.cafeFetchEnd.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    //MARK: - 컬렉션뷰 데이터소스
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return cafeViewModel.orderNearStore(coodinate: CLLocation.coordinate()).count
        case 3: return cafeViewModel.orderManyStoryStore().count
        case 4: return cafeViewModel.orderNewStore(coodinate: CLLocation.coordinate()).count
        case 5: return 1
        default: return 10
        }
    }
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FirstADCell.identifier,
                for: indexPath
            ) as! FirstADCell
            cell.viewModel = firstADListViewModel
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SecondADCell.identifier,
                for: indexPath
            ) as! SecondADCell
            cell.viewModel = secondADListViewModel
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FirstListCell.identifier,
                for: indexPath
            ) as! FirstListCell
            cell.viewModel = cafeViewModel.orderNearStore(coodinate: CLLocation.coordinate())[indexPath.row]
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SecondListCell.identifier,
                for: indexPath
            ) as! SecondListCell
            cell.viewModel = cafeViewModel.orderManyStoryStore()[indexPath.row]
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ThirdListCell.identifier,
                for: indexPath
            ) as! ThirdListCell
            cell.viewModel = cafeViewModel.orderNewStore(coodinate: CLLocation.coordinate())[indexPath.row]
            return cell
        case 5:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FourthListCell.identifier
                , for: indexPath
            ) as! FourthListCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cell",
                for: indexPath
            )
            return cell
        }
    }
    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ListCellHeader.identifier,
                for: indexPath
            ) as! ListCellHeader
            switch indexPath.section {
            case 2:
               return self.setListCellHeader(
                header: header,
                firstText: "\(UserViewModel.shared.userName)님과",
                secondText: "가까이 있는 매장이에요!",
                rangeText: "가까이 있는 매장",
                color: .systemOrange
               )
            case 3:
                return self.setListCellHeader(
                 header: header,
                 firstText: "\(UserViewModel.shared.userName)님 근처에있는",
                 secondText: "스토리가 많은 매장이에요!",
                 rangeText: "스토리가 많은 매장",
                 color: .systemBlue
                )
            case 4:
                return self.setListCellHeader(
                 header: header,
                 firstText: "새로추가된",
                 secondText: "신규매장을 소개합니다!",
                 rangeText: "신규매장",
                 color: .systemGreen
                )
            default:
                return header
            }
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ListCellFooter.identifier,
                for: indexPath
            ) as! ListCellFooter
            footer.delegate = self
            switch indexPath.section {
            case 2:
                footer.currentSection = .FirstCell
                return footer
            case 3:
                footer.currentSection = .SecondCell
                return footer
            case 4:
                footer.currentSection = .ThirdCell
                return footer
            default:
                return UICollectionReusableView()
            }
        default:
            return UICollectionReusableView()
        }
    }

//MARK: - 컬렉션뷰 델리게이트
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch indexPath.section {
        case 2:
            let vc = StoreDetailViewController(
                viewModel: cafeViewModel.orderNearStore(coodinate: CLLocation.coordinate())[indexPath.row]
            )
            delegate?.cellTapped(controller: vc)
        case 3:
            let vc = StoreDetailViewController(
                viewModel: cafeViewModel.orderManyStoryStore()[indexPath.row]
            )
            delegate?.cellTapped(controller: vc)
        case 4:
            let vc = StoreDetailViewController(
                viewModel: cafeViewModel.orderNewStore(coodinate: CLLocation.coordinate())[indexPath.row]
            )
            delegate?.cellTapped(controller: vc)
        default:
            break
        }
    }
}

//MARK: - 리스트셀 델리게이트

extension ListCollectionViewController: ListCellDelegate {
    func footerTapped(title: String) {
        delegate?.footerTapped(title: title)
    }
}


