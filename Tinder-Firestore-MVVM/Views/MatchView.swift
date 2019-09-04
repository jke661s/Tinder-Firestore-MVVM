//
//  MatchView.swift
//  Tinder-Firestore-MVVM
//
//  Created by iOS dev on 3/9/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import UIKit
import Firebase

class MatchView: UIView {
    
    // Configurations
    var loadProgress = (user: 0, card: 0) {
        didSet {
            guard loadProgress.user == 1, loadProgress.card == 1 else { return }
            self.setupAnimations()
        }
    }
    
    var currentUser: User! {
        didSet {
            guard let url = URL(string: currentUser.imageUrl1 ?? "") else { return }
            currentUserImageView.sd_setImage(with: url) { (_, _, _, _) in
                self.loadProgress.user = 1
            }
        }
    }
    
    var cardUID: String! {
        didSet {
            Firestore.firestore().collection("users").document(cardUID).getDocument { (snapshot, err) in
                if let err = err {
                    print("Failed to fetch card user:", err)
                    return
                }
                guard let dictonary = snapshot?.data() else { return }
                let user = User(dictionary: dictonary)
                self.descriptionLabel.text = "You and \(user.name ?? "") have linked\neach other"
                guard let url = URL(string: user.imageUrl1 ?? "") else { return }
                self.cardUserImageView.sd_setImage(with: url, completed: { (_, _, _, _) in
                    self.loadProgress.card = 1
                })
            }
        }
    }
    
    // UI Components
    fileprivate let blur = UIBlurEffect(style: .dark)
    fileprivate lazy var visualEffectView = UIVisualEffectView(effect: blur)
    
    fileprivate let itsAMatchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You and X have linked\neach other"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    fileprivate let currentUserImageView: UIImageView = {
//        let image = UIImage()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    fileprivate let cardUserImageView: UIImageView = {
        //        let image = UIImage()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "jane2"))
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    fileprivate let sendMessageButton: SendMessageButton = {
        let button = SendMessageButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        
        return button
    }()
    
    fileprivate let keepSwipingButton: KeepSwipingButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleKeepSwiping), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var views = [
        itsAMatchImageView,
        descriptionLabel,
        currentUserImageView,
        cardUserImageView,
        sendMessageButton,
        keepSwipingButton
    ]

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlurView()
        setupLayout()
//        setupAnimations()
    }
    
    // MARK:- Fileprivate functions
    
    @objc fileprivate func handleKeepSwiping() {
        dismissPage()
    }
    
    fileprivate func setupAnimations() {
        
        views.forEach({$0.alpha = 1})
        
        // starting positions
        let angle = -30 * CGFloat.pi / 180
        currentUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        cardUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        // keyframe animations for segmented animation
        
        UIView.animateKeyframes(withDuration: 1.2, delay: 0, options: .calculationModeCubic, animations: {
            
            // animation 1 - translation back to origin al position
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45, animations: {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: angle)
                self.cardUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
            })
            
            // animation 2 - rotation
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                self.currentUserImageView.transform = .identity
                self.cardUserImageView.transform = .identity
            })
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.75, delay: 0.6 * 1.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.sendMessageButton.transform = .identity
            self.keepSwipingButton.transform = .identity
        }, completion: nil)
        
    }
    
    fileprivate func setupLayout() {
        
        let imageWidth: CGFloat = 140
        
        views.forEach({
            $0.alpha = 0
            addSubview($0)
        })

        itsAMatchImageView.setConstraint(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 300, height: 80))
        itsAMatchImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        descriptionLabel.setConstraint(top: nil, leading: leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 50))
        
        currentUserImageView.setConstraint(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: imageWidth, height: imageWidth))
        currentUserImageView.layer.cornerRadius = imageWidth / 2
        currentUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        cardUserImageView.setConstraint(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: imageWidth, height: imageWidth))
        cardUserImageView.layer.cornerRadius = imageWidth / 2
        cardUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        sendMessageButton.setConstraint(top: currentUserImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 60))
        
        keepSwipingButton.setConstraint(top: sendMessageButton.bottomAnchor, leading: sendMessageButton.leadingAnchor, bottom: nil, trailing: sendMessageButton.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 60))
    }
    
    fileprivate func setupBlurView() {
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        
        addSubview(visualEffectView)
        visualEffectView.fillSuperView()
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 1
        }) { (_) in
            
        }
    }
    
    fileprivate func dismissPage() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    @objc fileprivate func handleTapDismiss(gesture: UITapGestureRecognizer) {
        dismissPage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
