//
//  ViewController.swift
//  Tinder-Firestore_MVVM
//
//  Created by iOS dev on 15/8/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let topView = TopNavigationStackView()
    let buttonStackView = HomeBottomControlStackView()
    let cardDeckView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpDummyCards()
    }
    
    fileprivate func setUpDummyCards() {
        let cardView = CardView(frame: .zero)
        cardDeckView.addSubview(cardView)
        cardView.fillSuperView()
    }
    
    // MARK:- Fileprivate
    
    fileprivate func setUpUI() {
        let overallStackView = UIStackView(arrangedSubviews: [topView, cardDeckView, buttonStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.setConstraint(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    
}

