//
//  User.swift
//  Vitae
//
//  Created by Salman Shahid on 25/1/2020.
//  Copyright © 2020 AVS. All rights reserved.
//

import Foundation
import FirebaseFirestore

class User:NSObject {
    var userId: String
    var name: String
    var bio: String
    var photo: String
    var score: Int
    
    init(userDict: [String:Any], userId: String) {
        self.userId = userId
        self.name = userDict["name"] as? String ?? ""
        self.bio = userDict["bio"] as? String ?? ""
        self.photo = userDict["photo"] as? String ?? ""
        self.score = userDict["score"] as? Int ?? 0
    }
    
    func incrementScore(amount: Int) {
        self.score += amount
    
        let db = Firestore.firestore()
        db.collection("users").document(userId).setData([
            "score": self.score
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
