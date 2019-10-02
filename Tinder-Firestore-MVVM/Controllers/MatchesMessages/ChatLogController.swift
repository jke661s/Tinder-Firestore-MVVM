//
//  ChatLogController.swift
//  Tinder-Firestore-MVVM
//
//  Created by iOS dev on 20/9/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import UIKit

struct Message {
    let text: String
}

class MessageCell: UICollectionViewCell {
    
    static let cellId = "MessageCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ChatLogController: UICollectionViewController {
    
    fileprivate let customNavBar = MessagesNavBar()
    fileprivate let navBarHeight: CGFloat = 120
    fileprivate let match: Match
    
    init(match: Match) {
        self.match = match
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.cellId)
        
        view.addSubview(customNavBar)
        customNavBar.setConstraint(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        collectionView.contentInset.top = navBarHeight
    }
    
    // MARK: - Fileprivate functions
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
   
}

extension ChatLogController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(navBarHeight)
        return 10
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MessageCell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.cellId, for: indexPath) as! MessageCell
        
        return cell
    }
    
}
