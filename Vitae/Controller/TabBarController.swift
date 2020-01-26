//
//  TabBarController.swift
//  Vitae
//
//  Created by Salman Shahid on 25/1/2020.
//  Copyright © 2020 AVS. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        let leaderboardController = LeaderboardController()
        leaderboardController.tabBarItem = UITabBarItem(title: "Leaderboard", image: UIImage(named: "wreath"), tag: 100)
        
        let dashboardController = CameraController(user: user)
        dashboardController.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(named: "camera"), tag: 200)
        
        let profileController = MapController(user: user)
        profileController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "map"), tag: 300)
        
        viewControllers = [leaderboardController, dashboardController, profileController]
        selectedIndex = 0
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromLeft], completion: nil)
        }
        
        return true
    }
}
