//
//  ViewController.swift
//  Tinder-Firestore_MVVM
//
//  Created by iOS dev on 15/8/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
    
    let topView = TopNavigationStackView()
    let bottomControls = HomeBottomControlStackView()
    let cardDeckView = UIView()
    var cardViewModels = [CardViewModel]()
    var lastUser: User?
    fileprivate var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        topView.settingButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        topView.messageButton.addTarget(self, action: #selector(handleMessage), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        
        fetchCurrentUser()
//        setupFirestoreUserCards()
//        fetchUsersFromFirestore()
    }
    deinit {
        print("HomeController has been deinited")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard Auth.auth().currentUser == nil else { return }
        let registrationController = RegistrationController()
        registrationController.delegate = self
        let navController = UINavigationController(rootViewController: registrationController)
        present(navController, animated: true)
    }
    
    // MARK:- Fileprivate
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailsController = UserDetailsController()
        userDetailsController.cardViewModel = cardViewModel
        
        present(userDetailsController, animated: true, completion: nil)
    }
    
    func didRemoveCardView(cardView: CardView) {
//        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    func didSaveSettings() {
        fetchCurrentUser()
    }
    
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    
    func didSwipeLeft() {
        handleDislike()
    }
    
    func didSwipeRight() {
        handleLike()
    }
    
    
    fileprivate func fetchCurrentUser() {
//        cardDeckView.subviews.forEach { $0.removeFromSuperview() }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            self.fetchSwipes()
        }
    }
    
    var swipes = [String: Int]()
    
    fileprivate func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch swipes:", err)
                return
            }

            let data = snapshot?.data() as? [String: Int] ?? [:]
            self.swipes = data
            self.fetchUsersFromFirestore()
        }
    }
    
    @objc fileprivate func handleMessage() {
        let vc = MatchesMessagesController(collectionViewLayout: UICollectionViewFlowLayout())
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    @objc func handleLike() {
        saveSwipeToFirestore(didLike: 1)
        performSwipeAnimation(translation: 700, angle: 15)
    }
    
    @objc func handleDislike() {
        saveSwipeToFirestore(didLike: 0)
        performSwipeAnimation(translation: -700, angle: -15)
    }
    
    fileprivate func saveSwipeToFirestore(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid, let cardUID = topCardView?.cardViewModel.uid else { return }
        
        let docData = [
            cardUID: didLike
        ]
        
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch swipe document:", err)
                return
            }
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(docData) { (err) in
                    if let err = err {
                        print("Failed to save swipe data:", err)
                        return
                    }
                    if didLike == 1 {
                        self.checkIfMatchExists(cardUID: cardUID)
                    }
                }
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(docData) { (err) in
                    if let err = err {
                        print("Failed to save swipe data:", err)
                        return
                    }
                    if didLike == 1 {
                        self.checkIfMatchExists(cardUID: cardUID)
                    }
                }
            }
        }
    }
    
    fileprivate func checkIfMatchExists(cardUID: String) {
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch document for card user:", err)
                return
            }
            guard let data = snapshot?.data(), let uid = Auth.auth().currentUser?.uid else { return }
            let hasMatched = data[uid] as? Int == 1
            if hasMatched {
                self.presentMatchView(cardUID: cardUID)
            }
            
        }
    }
    
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        matchView.currentUser = user
        matchView.cardUID = cardUID
        view.addSubview(matchView)
        matchView.fillSuperView()
    }
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.fillMode = .forwards
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        //        topCardView = cardView?.nextCardView
        
        self.topCardView = self.topCardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
    
    fileprivate var topCardView: CardView?
    
    fileprivate func fetchUsersFromFirestore() {
        cardDeckView.subviews.forEach { $0.removeFromSuperview() }
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        query.getDocuments { (snapshot, err) in
            hud.dismiss()
            if let err = err {
                print("Failed to fetch users: ", err)
                return
            }
            self.topCardView = nil
            
            // Linked list
            var prevCardView: CardView?
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
//                let hasNotSwipedBefore = self.swipes[user.uid!] == nil
                let hasNotSwipedBefore = true
                
                if isNotCurrentUser && hasNotSwipedBefore {
                    let cardView = self.setupCardsFromUser(user: user)
                    
                    prevCardView?.nextCardView = cardView
                    prevCardView = cardView
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    @objc fileprivate func handleSettings() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
    
    fileprivate func setupLayout() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topView, cardDeckView, bottomControls])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.setConstraint(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardDeckView)
    }
    
    fileprivate func setupFirestoreUserCards() {
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardDeckView.addSubview(cardView)
            cardView.fillSuperView()
        }
    }
    
    fileprivate func setupCardsFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperView()
        
        return cardView
    }
    
}

