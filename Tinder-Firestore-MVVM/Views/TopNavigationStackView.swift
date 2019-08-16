//
//  HomeTopControlStackView.swift
//  Tinder-Firestore_MVVM
//
//  Created by iOS dev on 15/8/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    let settingButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        settingButton.setImage(#imageLiteral(resourceName: "top_left_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)
        fireImageView.contentMode = .scaleAspectFit
        [settingButton, UIView(), fireImageView, UIView(), messageButton].forEach { (view) in
            addArrangedSubview(view)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
