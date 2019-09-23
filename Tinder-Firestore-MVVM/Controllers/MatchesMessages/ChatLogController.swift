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

class MessagesNavBar: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatLogController: UICollectionViewController {
    
    fileprivate let customNavBar = MessagesNavBar()
    fileprivate let navBarHeight: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.cellId)
        
        
        view.addSubview(customNavBar)
        customNavBar.setConstraint(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
        
        collectionView.contentInset.top = navBarHeight
    }
   
}


extension ChatLogController: UICollectionViewDelegateFlowLayout {
    
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
