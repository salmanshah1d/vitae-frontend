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
    var invasive: Bool
    
    init(userDict: [String:Any]) {
        self.name = userDict["name"] as? String ?? ""
        self.latinName = userDict["latin_name"] as? String ?? ""
        self.bio = userDict["summary"] as? String ?? ""
        self.photo = userDict["wiki_image"] as? String ?? ""
        self.invasive = userDict["is_invasive"] as? Bool ?? false
    }
}
