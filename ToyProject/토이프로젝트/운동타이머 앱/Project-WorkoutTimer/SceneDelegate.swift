//
//  SceneDelegate.swift
//  Project-WorkoutTimer
//
//  Created by 정덕호 on 2022/01/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

//MARK: - custom tapbar
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        
        
        if let tbc = self.window?.rootViewController as? UITabBarController {
            let appearance = UITabBarAppearance()
            // set tabbar opacity
            appearance.configureWithOpaqueBackground()

            // remove tabbar border line
            appearance.shadowColor = UIColor.darkText

            // set tabbar background color
            appearance.backgroundColor = .clear
            tbc.tabBar.standardAppearance = appearance

            if #available(iOS 15.0, *) {
                    // set tabbar opacity
                tbc.tabBar.scrollEdgeAppearance = tbc.tabBar.standardAppearance
            }
            
            if let tbitems = tbc.tabBar.items {
                tbitems[0].title = "Timer".localized()
                tbitems[1].title = "Workout Log".localized()
                tbitems[0].image = UIImage(systemName: "timer")
                if #available(iOS 15.0, *) {
                tbitems[1].image = UIImage(systemName: "note.text")
                } else {
                    tbitems[1].image = UIImage(systemName: "pencil")
                }
                tbitems[2].title = "1RM Calculator".localized()
                tbitems[2].image = UIImage(systemName: "1.square")
            }
        }
        
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

