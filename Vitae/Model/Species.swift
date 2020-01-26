//
//  Species.swift
//  Vitae
//
//  Created by Salman Shahid on 26/1/2020.
//  Copyright © 2020 AVS. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Species:NSObject {
    var name: String
    var latinName: String
    var bio: String
    var photo: String
    
    init(userDict: [String:Any]) {
        self.name = userDict["species"] as? String ?? ""
        self.latinName = userDict["latinName"] as? String ?? ""
        self.bio = userDict["summary"] as? String ?? ""
        self.photo = userDict["image"] as? String ?? ""
    }
}
