//
//  FavoriteViewController.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/13.
//

import UIKit

class FavoriteViewController: UICollectionViewController {

    //MARK: - 프로퍼티
    private let ADViewModel: ADListViewModel
    private let favoriteListViewModel: FavoriteListViewModel
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "즐겨찾기없음이미지")
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .white
        return iv
    }()
    
    //MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setAtrribute()
        setBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        naviSetAttribute()
    }
    init(ADViewModel: ADListViewModel, favoriteListViewModel: FavoriteListViewModel) {
        self.ADViewModel = ADViewModel
        self.favoriteListViewModel = favoriteListViewModel
        let layout = UICollectionViewCompositionalLayout { section, env in
            switch section {
            case 0:
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
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 20, leading: 10, bottom: 40, trailing: 10
                )
                return section
            default:
                return NSCollectionLayoutSection.sortLayout(
                    supplementaryItem: .init(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .estimated(100)
                        ),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .topLeading
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
    private func setLayout() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.snp.topMargin).offset(200)
            make.bottom.equalToSuperview().offset(-100)
        }
    }
    private func setAtrribute() {
        collectionView.register(
            SortCell.self,
            forCellWithReuseIdentifier: SortCell.identifier
        )
        collectionView.register(
            SecondADCell.self,
            forCellWithReuseIdentifier: SecondADCell.identifier
        )
        collectionView.register(
            FavoriteHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FavoriteHeader.identifier
        )
    }
    private func naviSetAttribute() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "자주가요"
    }
    private func setBinding() {
        favoriteListViewModel.fetchFavoriteSuccess.bind { [weak self] _ in
            self!.collectionView.reloadData()
        }
    }
    
    //MARK: - 컬렉션뷰 데이터소스
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0:
            return 1
        default:
            if favoriteListViewModel.count() == 0 {
                collectionView.isScrollEnabled = false
                imageView.isHidden = false
                return favoriteListViewModel.count()
            } else {
                imageView.isHidden = true
                collectionView.isScrollEnabled = true
                return favoriteListViewModel.count()
            }
        }
    }
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SecondADCell.identifier,
                for: indexPath
            ) as! SecondADCell
            cell.viewModel = ADViewModel
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SortCell.identifier,
                for: indexPath
            ) as! SortCell
            cell.viewModel = favoriteListViewModel.itemAtIndex(indexPath.row)
            return cell
        }
    }
    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String
        , at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: FavoriteHeader.identifier,
            for: indexPath
        ) as! FavoriteHeader
        return header
    }
    
    //MARK: - 컬렉션뷰 델리게이트
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = StoreDetailViewController(viewModel: favoriteListViewModel.itemAtIndex(indexPath.row))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
