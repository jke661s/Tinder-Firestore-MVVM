//
//  RegistrationViewModel.swift
//  Tinder-Firestore-MVVM
//
//  Created by iOS dev on 20/8/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import Foundation

class RegistrationViewModel {
    
    var fullName: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
    
    var isFormValidObserver: ((Bool) -> ())?
}
