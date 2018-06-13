//
//  CardView.swift
//  C Learning Teacher
//
//  Created by kit on 6/4/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import Foundation

@IBDesignable class CardView : UIView {
    @IBInspectable var cornerRadius : CGFloat = 5
    @IBInspectable var shadowColor : UIColor = .black
    @IBInspectable var shadowOffSetWidth : Int = 0
    @IBInspectable var shadowOffSetHeight : Int = 0
    @IBInspectable var shadowOpacity : Float = 0.2
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = shadowOpacity
        
    }
}
