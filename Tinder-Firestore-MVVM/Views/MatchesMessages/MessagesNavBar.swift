//
//  MessagesNavBar.swift
//  Tinder-Firestore-MVVM
//
//  Created by iOS dev on 25/9/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import UIKit

class MessagesNavBar: UIView {
    
    var wholeStackView = UIStackView()
    
    let userProfileImageView: UIImageView = {
        let image = #imageLiteral(resourceName: "kelly1")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "USERNAME"
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = #imageLiteral(resourceName: "back")
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 0.9278834462, green: 0.3990912437, blue: 0.3985493779, alpha: 1)
        return button
    }()
    
    let flagButton: UIButton = {
        let button = UIButton(type: .system)
        let image = #imageLiteral(resourceName: "flag")
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 0.9278834462, green: 0.3990912437, blue: 0.3985493779, alpha: 1)
        return button
    }()
    
    fileprivate let match: Match
    
    init(match: Match) {
        self.match = match
        
        nameLabel.text = match.name
        
        super.init(frame: .zero)
        backgroundColor = .white
        layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.2
        
        userProfileImageView.setConstraint(top: nil, leading: nil, bottom: nil, trailing: nil, size: .init(width: 44, height: 44))
        userProfileImageView.layer.cornerRadius = 44 / 2
        
        let userInfoStackView = UIStackView(arrangedSubviews: [userProfileImageView, nameLabel])
        userInfoStackView.alignment = .center
        userInfoStackView.distribution = .fill
        userInfoStackView.axis = .vertical
        userInfoStackView.spacing = 8
        
        let userInfoStackViewHorizontal = UIStackView(arrangedSubviews: [userInfoStackView])
        userInfoStackViewHorizontal.axis = .horizontal
        userInfoStackViewHorizontal.distribution = .fill
        userInfoStackViewHorizontal.alignment = .center
        
        wholeStackView = UIStackView(arrangedSubviews: [backButton, userInfoStackViewHorizontal, flagButton])
        wholeStackView.distribution = .fill
        wholeStackView.axis = .horizontal
        
        addSubview(wholeStackView)
        wholeStackView.setConstraint(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
