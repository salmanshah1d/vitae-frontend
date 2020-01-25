//
//  User.swift
//  Vitae
//
//  Created by Salman Shahid on 25/1/2020.
//  Copyright © 2020 AVS. All rights reserved.
//

import Foundation
class User:NSObject {
    var userId: String
    var name: String
    var bio: String
    var photo: String
    var score: Int
    
    init(userDict: NSDictionary, userId: String) {
        self.userId = userId
        self.name = userDict["name"] as? String ?? ""
        self.bio = userDict["bio"] as? String ?? ""
        self.photo = userDict["photo"] as? String ?? ""
        self.score = userDict["score"] as? Int  ?? 0
    }
}
