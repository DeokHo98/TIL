//
//  PodcastViewController.swift
//  TED_Clone
//
//  Created by 민선기 on 2022/03/01.
//

import UIKit
import Firebase

class PodcastViewController: UICollectionViewController {
    
    
    
    //MARK: - Properties

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //네비게이션 바 관련 코드입니다. 이것은 viewdidload에 넣으면 나중엔 작동하지않습니다.
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isHidden = true
    }
    




//MARK: - Helper Functions

private func configureUI() {
    //백그라운드 컬러를 테드앱과 똑같은 색으로 맞췄습니다.
    collectionView.backgroundColor = .backgroundColor
    
    //컬렉션뷰 관련 코드입니다.
    collectionView.register(PodCastCollectionViewCell.self, forCellWithReuseIdentifier: PodCastCollectionViewCell.identifier)
    collectionView.register(CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionReusableView.identifier)
    
}
    

    
    
    


 //MARK: - 컬렉션뷰 데이터소스, 델리게이트

    //컬렉션뷰 셀의 갯수입니다.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return PodcastViewModel.nameList.count
    }
    
    //컬렉션뷰 셀 생성입니다.
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PodCastCollectionViewCell.identifier, for: indexPath) as? PodCastCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = PodcastViewModel.imageList[indexPath.row].image
        cell.labelView.text = PodcastViewModel.nameList[indexPath.row]
        return cell
    }
    
    
   //컬렉션뷰 헤더 생성입니다.
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionReusableView.identifier, for: indexPath) as? CollectionReusableView else { return UICollectionReusableView() }
        return headerView
    }
    
    //셀을 선택 한 뒤에 상세뷰로 이동하는 코드 입니다.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PodcastDetailViewController.selectedNum = indexPath.row
        navigationController?.pushViewController(PodcastDetailViewController(), animated: true)

    }
    

}




//MARK: - 컬렉션뷰 셀 레이아웃
//컴포지셔널 레이아웃으로도 해보기
extension PodcastViewController: UICollectionViewDelegateFlowLayout {
    //컬렉션뷰셀의 너비와 높이 조정 메서드입니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 2 - 35
        return CGSize(width: width, height: width)
    }
    
    //헤더의 너비와 높이 조정 메서드입니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    
    //컬렉션뷰 셀의 섹션의 상하 좌우 여백 조정 메서드입니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 50, right: 20)
    }
    
    //컬렉션뷰 셀 위 아래 여백 조정 메서드입니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }

    
}






