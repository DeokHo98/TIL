//
//  ViewController.swift
//  TED_Clone
//
//  Created by 정덕호 on 2022/03/13.
//

import UIKit

class PodcastLoadingController: UIViewController {

    var num: Int = 0 {
        didSet {
            if num == PodcastViewModel.imageList.count {
                pushViewcontroller()
            }
        }
    }
    
    //MARK: - 속성
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "loadingimage")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PodcastViewModel.fetch { num in
            self.num += num
            print("클로져실행")
        }
        PodcastViewModel.mp3Fetch()
        view.addSubview(imageView)
        imageView.anchor(width: view.frame.width, height: view.frame.height)
    }
    

    func pushViewcontroller() {
        navigationController?.pushViewController(PodcastViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
    }

}
