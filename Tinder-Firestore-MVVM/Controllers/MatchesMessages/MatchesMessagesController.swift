//
//  MatchesMessagesController.swift
//  Tinder-Firestore-MVVM
//
//  Created by iOS dev on 4/9/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct Match {
    let name, profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as? String ?? ""
        profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}

class MatchCell: UICollectionViewCell {
    static var identifier: String = "Cell"
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.layer.cornerRadius = 80 / 2
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username Here"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()
    
    var match: Match! {
        didSet {
            usernameLabel.text = match.name
            guard let url = URL(string: match.profileImageUrl) else { return }
            profileImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let sv = UIStackView(arrangedSubviews: [profileImageView, usernameLabel])
        sv.alignment = .center
        sv.axis = .vertical
        addSubview(sv)
        sv.fillSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MatchesMessagesController: UICollectionViewController {
    
    let customNavBar = MatchesNavBar()
    
//    let data: [Match] = [
//        .init(name: "1", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/tinderfirestoremvvm.appspot.com/o/images%2F65008AFD-3A45-4E40-B992-186BAA89B674?alt=media&token=f121c80d-8cad-4218-ba6e-161b0ac4d7a1"),
//        .init(name: "test", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/tinderfirestoremvvm.appspot.com/o/images%2F65008AFD-3A45-4E40-B992-186BAA89B674?alt=media&token=f121c80d-8cad-4218-ba6e-161b0ac4d7a1"),
//        .init(name: "1", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/tinderfirestoremvvm.appspot.com/o/images%2F65008AFD-3A45-4E40-B992-186BAA89B674?alt=media&token=f121c80d-8cad-4218-ba6e-161b0ac4d7a1"),
//        .init(name: "2", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/tinderfirestoremvvm.appspot.com/o/images%2F65008AFD-3A45-4E40-B992-186BAA89B674?alt=media&token=f121c80d-8cad-4218-ba6e-161b0ac4d7a1"),
//        .init(name: "3", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/tinderfirestoremvvm.appspot.com/o/images%2F65008AFD-3A45-4E40-B992-186BAA89B674?alt=media&token=f121c80d-8cad-4218-ba6e-161b0ac4d7a1")
//    ]
    var matchList: [Match] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMatches()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(MatchCell.self, forCellWithReuseIdentifier: "id")
        collectionView.contentInset.top = 150
        
        view.addSubview(customNavBar)
        customNavBar.setConstraint(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .zero, size: .init(width: 0, height: 150))
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func fetchMatches() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("matches").getDocuments { [weak self] (snapshot, err) in
            guard let self = self else { return }
            if let err = err {
                print("Failed to fetch matches:", err)
                return
            }
            
            print("Here are my matches documents")
            
            snapshot?.documents.forEach({ (doc) in
                let dictionary = doc.data()
                let match = Match(dictionary: dictionary)
                self.matchList.append(match)
            })
            self.collectionView.reloadData()
        }
    }
}

extension MatchesMessagesController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MatchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! MatchCell
        cell.match = matchList[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 110, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let match = matchList[indexPath.item]
        let chatLogController = ChatLogController(match: match)
        
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
}
