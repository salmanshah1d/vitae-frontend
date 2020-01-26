//
//  EntityInformation.swift
//  Vitae
//
//  Created by Vladimir Dyagilev on 2020-01-26.
//  Copyright © 2020 AVS. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseUI

class EntityInfoController: UIViewController {
    var user: User? {
        didSet {
            guard let user = user else {
                return
            }
            englishName.text = user.name
            photo.image = UIImage(named: user.photo)
            latinName.text = "\(user.score)"
            infoText.text = user.bio
        }
    }
    
    var species: Species? {
        didSet {
            guard let species = species else {
                return
            }
            englishName.text = species.name
            let url = URL(string: species.photo)
            photo.sd_setImage(with: url, completed: nil)
            latinName.text = species.latinName
            infoText.text = species.bio
        }
    }
    
    // Change status bar color to light
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#d1d8e0", alpha: 0.8)
        setupViews()
    }
    
    let englishName: UILabel = {
        let ul = UILabel()
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.adjustsFontSizeToFitWidth = true
        ul.font = UIFont.systemFont(ofSize: 20)
        return ul
    }()
    
    let latinName: UILabel = {
        let ul = UILabel()
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.adjustsFontSizeToFitWidth = true
        ul.font = UIFont.italicSystemFont(ofSize: 20)
        return ul
    }()
    
    let infoText: UILabel = {
        let ul = UILabel()
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.adjustsFontSizeToFitWidth = true
        ul.font = UIFont.systemFont(ofSize: 16)
        return ul
    }()

    let photo: UIImageView = {
       let uv = UIImageView()
       uv.clipsToBounds = true
       uv.contentMode = .scaleAspectFill
       uv.backgroundColor = UIColor(hexString: "#d1d8e0")
       uv.translatesAutoresizingMaskIntoConstraints = false
       return uv
    }()
    
    func setupViews() {
        view.addSubview(englishName)
        view.addSubview(latinName)
        view.addSubview(photo)
        view.addSubview(infoText)
        
        let margin = CGFloat(20)
        
        englishName.topAnchor.constraint(equalTo: view.topAnchor, constant: margin).isActive = true
        englishName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin).isActive = true
        latinName.topAnchor.constraint(equalTo: englishName.bottomAnchor, constant: margin).isActive = true
        latinName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin).isActive = true
        
        photo.topAnchor.constraint(equalTo: latinName.bottomAnchor, constant: margin).isActive = true
        photo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photo.widthAnchor.constraint(equalToConstant: 400).isActive = true
        
        infoText.topAnchor.constraint(equalTo: photo.bottomAnchor).isActive = true
        infoText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin).isActive = true
        infoText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: margin).isActive = true
        infoText.numberOfLines = 0
        
    }
}