//
//  ViewController.swift
//  Tinder-Firestore_MVVM
//
//  Created by iOS dev on 15/8/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    let topView = TopNavigationStackView()
    let buttonStackView = HomeBottomControlStackView()
    let cardDeckView = UIView()

    let cardViewModels: [CardViewModel] = {
        let producers: [ProducesCardViewModel] = [
            User(name: "Kelly", age: 23, profession: "Music DJ", imageNames: ["kelly1","kelly2","kelly3"]),
            User(name: "Jane", age: 18, profession: "Teacher", imageNames: ["jane1","jane2","jane3"]),
            Advertiser(title: "Slide Out Menu", brandName: "Lets Build That App", posterPhotoName: "slide_out_menu_poster"),
            User(name: "Jane", age: 18, profession: "Teacher", imageNames: ["jane1","jane2","jane3"]),
        ]
        let viewModels = producers.map({ return $0.toCardViewModel() })
        return viewModels
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        topView.settingButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        setUpDummyCards()
    }
    
    // MARK:- Fileprivate
    
    @objc fileprivate func handleSettings() {
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
    }
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topView, cardDeckView, buttonStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.setConstraint(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardDeckView)
    }
    
    fileprivate func setUpDummyCards() {
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardDeckView.addSubview(cardView)
            cardView.fillSuperView()
        }
    }
    
}

