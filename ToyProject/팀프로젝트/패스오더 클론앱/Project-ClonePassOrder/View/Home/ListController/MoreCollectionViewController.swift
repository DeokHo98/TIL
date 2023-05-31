//
//  MoreCollectionViewController.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/19.
//

import UIKit
import CoreLocation

class MoreCollectionViewController: UICollectionViewController {
    
    //MARK: - 프로퍼티
    
    var viewModel: CafeListViewModel
    var naviTitle: String?
    
    //MARK: - 라이프사이클

    override func viewDidLoad() {
        super.viewDidLoad()
        naviSetAttribute()
        setAtrribute()
        
    }
    init(viewModel: CafeListViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewCompositionalLayout { section, env in
            return NSCollectionLayoutSection.sortLayout()
        }
        super.init(collectionViewLayout: layout)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 메서드
    
    private func setAtrribute() {
        self.collectionView!.register(SortCell.self, forCellWithReuseIdentifier: SortCell.identifier)
    }
    private func naviSetAttribute() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = naviTitle
        navigationController?.navigationBar.tintColor = .black
        tabBarController?.tabBar.isHidden = true
    }

    //MARK: - 컬렉션뷰 데이터소스
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch naviTitle {
        case "가까이 있는 매장":
            return viewModel.orderNearStore(coodinate: CLLocation.coordinate()).count
        case "스토리가 많은 매장":
            return viewModel.orderManyStoryStore().count
        case "신규매장":
            return viewModel.orderNewStore(coodinate: CLLocation.coordinate()).count
        default:
            return 0
        }
    }
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SortCell.identifier,
            for: indexPath
        ) as! SortCell
        switch naviTitle {
        case "가까이 있는 매장":
            cell.viewModel = viewModel.orderNearStore(coodinate: CLLocation.coordinate())[indexPath.row]
        case "스토리가 많은 매장":
            cell.viewModel = viewModel.orderManyStoryStore()[indexPath.row]
        case "신규매장":
            cell.viewModel = viewModel.orderNewStore(coodinate: CLLocation.coordinate())[indexPath.row]
        default:
            return cell
        }
        return cell
    }
    
    //MARK: - 컬렉션뷰 델리게이트
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch naviTitle {
        case "가까이 있는 매장":
            let viewModel = viewModel.orderNearStore(coodinate: CLLocation.coordinate())[indexPath.row]
            let vc = StoreDetailViewController(viewModel: viewModel)
            navigationController?.pushViewController(vc, animated: true)
        case "스토리가 많은 매장":
            let viewModel = viewModel.orderManyStoryStore()[indexPath.row]
            let vc = StoreDetailViewController(viewModel: viewModel)
            navigationController?.pushViewController(vc, animated: true)
        case "신규매장":
            let viewModel = viewModel.orderNewStore(coodinate: CLLocation.coordinate())[indexPath.row]
            let vc = StoreDetailViewController(viewModel: viewModel)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
}
