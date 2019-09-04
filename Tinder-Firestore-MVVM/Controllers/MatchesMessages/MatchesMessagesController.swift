//
//  MatchesMessagesController.swift
//  Tinder-Firestore-MVVM
//
//  Created by iOS dev on 4/9/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import Foundation
import UIKit

class MatchesMessagesController: UICollectionViewController {
    
    let customNavBar: UIView = {
        let navBar = UIView()
        navBar.backgroundColor = .white
        navBar.layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
        navBar.layer.shadowOffset = CGSize(width: 0, height: 10)
        navBar.layer.shadowRadius = 8
        navBar.layer.shadowOpacity = 0.2
        
        let iconImageView = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
        iconImageView.contentMode = .scaleAspectFit
        
        
        
        return navBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        view.addSubview(customNavBar)
        customNavBar.setConstraint(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .zero, size: .init(width: 0, height: 150))
    }
    
}
