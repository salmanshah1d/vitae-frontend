//
//  LeaderboardController.swift
//  Vitae
//
//  Created by Salman Shahid on 25/1/2020.
//  Copyright © 2020 AVS. All rights reserved.
//

import UIKit
import FirebaseFirestore

class LeaderboardController: UITableViewController {
    // Change status bar color to light
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let cellId = "cellId"
    var userArray: [User] = []
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Leaderboard 🏆"
        loadUsers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.register(LeaderboardCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = .clear
        
        setupGestures()
    }
    
    func loadUsers() {
        self.userArray = []
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.userArray.append(User(userDict: document.data(), userId: document.documentID))
                }
                self.tableView.reloadData()
            }
        }
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
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        guard let leaderboardCell = cell as? LeaderboardCell else {
            return cell
        }
        
        leaderboardCell.user = userArray[indexPath.item]
        if (indexPath.item % 2 == 1) {
            leaderboardCell.backgroundColor = UIColor(hexString: "#a5b1c2").withAlphaComponent(0.1)
//            leaderboardCell.backgroundColor = UIColor(hexString: "#fafafa")
        } else {
            leaderboardCell.backgroundColor = UIColor.white
        }
        
        return leaderboardCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EntityInfoController()
        vc.user = userArray[indexPath.item]
        navigationController?.present(vc, animated: true, completion: nil)
    }
}
