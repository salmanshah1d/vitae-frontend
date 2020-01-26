//
//  LeaderboardCell.swift
//  Vitae
//
//  Created by Salman Shahid on 25/1/2020.
//  Copyright © 2020 AVS. All rights reserved.
//

import UIKit

class LeaderboardCell:UITableViewCell {
    
    let size = CGFloat(100)
    var user: User? {
        didSet {
            guard let user = user else {
                return
            }
            photo.image = UIImage(named: user.photo)
            name.text = user.name
            score.text = "\(user.score)"
            setupCellViews()
        }
    }
    
    let photo:UIImageView = {
        let uv = UIImageView()
        uv.clipsToBounds = true
        uv.contentMode = .scaleAspectFill
        uv.backgroundColor = UIColor(hexString: "#d1d8e0")
        uv.translatesAutoresizingMaskIntoConstraints = false
        return uv
    }()
    
    let name:UILabel = {
        let ul = UILabel()
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.adjustsFontSizeToFitWidth = true
        ul.font = UIFont.systemFont(ofSize: 20)
        return ul
    }()
    
    let score:UILabel = {
        let ul = UILabel()
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.adjustsFontSizeToFitWidth = true
        ul.font = UIFont.systemFont(ofSize: 28)
        ul.textColor = UIColor(hexString: "#f7b731")
        return ul
    }()
    
    
    func setupCellViews() {
        addSubview(photo)
        addSubview(name)
        addSubview(score)
        
        let margin = CGFloat(20)
        let imageSize = size - margin
        photo.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        photo.leftAnchor.constraint(equalTo: leftAnchor, constant: margin).isActive = true
        photo.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        photo.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        photo.layer.cornerRadius = imageSize/2
        
        name.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        name.leftAnchor.constraint(equalTo: photo.rightAnchor, constant: margin).isActive = true
        
        score.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        score.rightAnchor.constraint(equalTo: rightAnchor, constant: -margin).isActive = true
        
    }
}
