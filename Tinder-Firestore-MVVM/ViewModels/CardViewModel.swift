//
//  CardViewModel.swift
//  Tinder-Firestore-MVVM
//
//  Created by iOS dev on 19/8/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import Foundation
import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
    let imageName: String
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
}

