//
//  KeepSwipingButton.swift
//  Tinder-Firestore-MVVM
//
//  Created by iOS dev on 4/9/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import UIKit

class KeepSwipingButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 0.9914571643, green: 0.1364049315, blue: 0.4705217481, alpha: 1)
        let rightColor = #colorLiteral(red: 0.9892428517, green: 0.4137525558, blue: 0.3168113828, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        setTitleColor(.white, for: .normal)
        
        let cornerRadius = rect.height / 2
        let maskLayer = CAShapeLayer()
        let maskPath = CGMutablePath()
        maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
        maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 2, dy: 2), cornerRadius: cornerRadius).cgPath)
        
        maskLayer.path = maskPath
        maskLayer.fillRule = .evenOdd
        
        gradientLayer.mask = maskLayer
        
        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        gradientLayer.frame = rect
        
    }

}
