//
//  Bindable.swift
//  Tinder-Firestore-MVVM
//
//  Created by iOS dev on 21/8/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
