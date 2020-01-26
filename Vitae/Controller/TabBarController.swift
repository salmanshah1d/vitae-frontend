//
//  TabBarController.swift
//  Vitae
//
//  Created by Salman Shahid on 25/1/2020.
//  Copyright © 2020 AVS. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
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
        
        let leaderboardController = LeaderboardController()
        leaderboardController.tabBarItem = UITabBarItem(title: "Leaderboard", image: UIImage(named: "wreath"), tag: 100)
        
        let dashboardController = CameraController()
        dashboardController.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(named: "camera"), tag: 200)
        
        let profileController = UIViewController()
        profileController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), tag: 300)
        
        viewControllers = [leaderboardController, dashboardController, profileController]
        selectedIndex = 1
        
        
    }
    
}
