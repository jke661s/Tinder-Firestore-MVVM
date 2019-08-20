//
//  RegistrationController.swift
//  Tinder-Firestore-MVVM
//
//  Created by iOS dev on 20/8/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
    
    let registrationViewModel = RegistrationViewModel()
    
    // UI Components
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter full name"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter Email"
        tf.keyboardType = .emailAddress
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passswordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()

    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        
        setupLayout()
        
        setupNotificationObservers()
        
        setupTapGesture()
        
        setupRegistrationViewModelObserver()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
        } else {
            overallStackView.axis = .vertical
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK:- Private
    
    @objc fileprivate func handleRegister() {
        
        }
    
    fileprivate func setupRegistrationViewModelObserver() {
        registrationViewModel.isFormValidObserver = { [weak self] (isFormValid) in
            guard let self = self else {return}
            if isFormValid {
                self.registerButton.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0, blue: 0.3254901961, alpha: 1)
            } else {
                self.registerButton.backgroundColor = .lightGray
            }
        }
    }
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == fullNameTextField {
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame)
        
        let bottomSpace = view.frame.height - overallStackView.frame.maxY
        let difference = keyboardFrame.height - bottomSpace
        view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [fullNameTextField,
                                                emailTextField,
                                                passswordTextField,
                                                registerButton])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [selectPhotoButton, verticalStackView])

    fileprivate func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.989639461, green: 0.3726401925, blue: 0.3745627999, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8941933513, green: 0.1068479493, blue: 0.4629365802, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor ]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupLayout() {
        overallStackView.axis = .vertical
        overallStackView.spacing = 8
        selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        view.addSubview(overallStackView)
        overallStackView.setConstraint(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
