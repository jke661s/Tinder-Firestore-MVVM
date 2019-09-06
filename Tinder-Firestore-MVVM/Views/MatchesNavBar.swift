//
//  MatchesNavBar.swift
//  Tinder-Firestore-MVVM
//
//  Created by iOS dev on 6/9/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import UIKit

class MatchesNavBar: UIView {
    
    let backButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.2
        
        let iconImageView = UIImageView(image: #imageLiteral(resourceName: "top_messages_icon").withRenderingMode(.alwaysTemplate))
        iconImageView.tintColor = #colorLiteral(red: 0.9998247027, green: 0.442925334, blue: 0.4766646624, alpha: 1)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let messageLabel = UILabel()
        messageLabel.text = "Messages"
        messageLabel.textColor = #colorLiteral(red: 1, green: 0.4233486056, blue: 0.4452816844, alpha: 1)
        messageLabel.font = UIFont.boldSystemFont(ofSize: 20)
        messageLabel.textAlignment = .center
        
        let feedLabel = UILabel()
        feedLabel.text = "Feed"
        feedLabel.textColor = .gray
        feedLabel.font = UIFont.boldSystemFont(ofSize: 20)
        feedLabel.textAlignment = .center
        
        let labelStackView = UIStackView(arrangedSubviews: [messageLabel, feedLabel])
        labelStackView.distribution = .fillEqually
        
        let wholeStackView = UIStackView(arrangedSubviews: [iconImageView, labelStackView])
        wholeStackView.axis = .vertical
        wholeStackView.isLayoutMarginsRelativeArrangement = true
        wholeStackView.layoutMargins.top = 10
        
        self.addSubview(wholeStackView)
        wholeStackView.fillSuperView()
        
        
        backButton.setImage(#imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = .lightGray
        addSubview(backButton)
        backButton.setConstraint(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 14, bottom: 0, right: 0), size: .init(width: 34, height: 34))
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
