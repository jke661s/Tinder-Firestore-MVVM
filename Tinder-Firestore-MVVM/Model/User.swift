//
//  User.swift
//  Tinder-Firestore-MVVM
//
//  Created by iOS dev on 19/8/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import UIKit 

struct User: ProducesCardViewModel {
    var name: String?
    var age: Int?
    var profession: String?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var uid: String?
    
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullname"] as? String
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.uid = dictionary["uid"] as? String
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "N\\A"
        
        attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let professionString = profession != nil ? profession! : "Not Available"
        
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        var imageUrls = [String]()
        
        if let url = imageUrl1 { imageUrls.append(url)}
        if let url = imageUrl2 { imageUrls.append(url)}
        if let url = imageUrl3 { imageUrls.append(url)}
        
        return CardViewModel(uid: uid ?? "", imageNames: imageUrls, attributedString: attributedText, textAlignment: .left)
    }
}
