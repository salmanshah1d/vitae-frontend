//
//  TabBarController.swift
//  Vitae
//
//  Created by Salman Shahid on 25/1/2020.
//  Copyright © 2020 AVS. All rights reserved.
//

import UIKit
import SwipeableTabBarController

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let leaderboardController = LeaderboardController()
        leaderboardController.tabBarItem = UITabBarItem.init(tabBarSystemItem: UITabBarItem.SystemItem.featured, tag: 100)
        leaderboardController.tabBarItem.title = "Leaderboard"
        
        let dashboardController = CameraController()
        dashboardController.tabBarItem = UITabBarItem.init(tabBarSystemItem: UITabBarItem.SystemItem.search, tag: 200)
        dashboardController.tabBarItem.title = "Camera"
        
        let profileController = UIViewController()
        profileController.tabBarItem = UITabBarItem.init(tabBarSystemItem: UITabBarItem.SystemItem.contacts, tag: 300)
        profileController.tabBarItem.title = "Profile"
        
        viewControllers = [leaderboardController, dashboardController, profileController]
        selectedIndex = 1
    }
    
}
