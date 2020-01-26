//
//  LeaderboardController.swift
//  Vitae
//
//  Created by Salman Shahid on 25/1/2020.
//  Copyright © 2020 AVS. All rights reserved.
//

import UIKit

class LeaderboardController: UITableViewController {
    // Change status bar color to light
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let cellId = "cellId"
    let userArray: [User] = {
        let userDict = NSDictionary(dictionary: ["name":"Salman", "bio":"hey", "photo":"salman", "score":0])
        let userOne = User(userDict: userDict, userId: "00000")
        let userTwo = User(userDict: userDict, userId: "00000")
        let userThree = User(userDict: userDict, userId: "00000")
        let userFour = User(userDict: userDict, userId: "00000")
        return [userOne, userTwo, userThree, userFour]
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Leaderboard 🏆"
        // UIColor(hexString: "#20bf6b")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.register(LeaderboardCell.self, forCellReuseIdentifier: cellId)
        setupGestures()
    }
    
    func setupGestures() {
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action:
        #selector(swipeMade(_:)))
           leftRecognizer.direction = .left
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action:
        #selector(swipeMade(_:)))
           rightRecognizer.direction = .right
           self.view.addGestureRecognizer(leftRecognizer)
           self.view.addGestureRecognizer(rightRecognizer)
    }
    
    @objc func swipeMade(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            self.tabBarController?.selectedIndex = 1
        }
        
        if sender.direction == .right {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        guard let leaderboardCell = cell as? LeaderboardCell else {
            return cell
        }
        
        leaderboardCell.user = userArray[indexPath.row]
        
        return leaderboardCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
}
