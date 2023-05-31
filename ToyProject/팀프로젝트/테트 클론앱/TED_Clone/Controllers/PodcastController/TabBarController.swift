//
//  TabBarController.swift
//  TED_Clone
//
//  Created by 민선기 on 2022/03/01.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpControllers()
    }
    
    private func setUpControllers() {
        let podcast = PodcastLoadingController()
        
        let nav1 = UINavigationController(rootViewController: podcast)
        
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "headphones"), tag: 1)
        setViewControllers([nav1], animated: false)
    }
}
