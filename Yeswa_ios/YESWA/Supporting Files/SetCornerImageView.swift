//
//  SetCornerImageView.swift
//  KabokyDriver
//
//  Created by Gaurav Tiwari on 06/03/17.
//  Copyright © 2017 Toxsl technologies. All rights reserved.
//

import UIKit

@IBDesignable
class SetCornerImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            setCorner()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            setCorner()
        }
    }

    @IBInspectable var borderColor: UIColor? {
        didSet {
            setCorner()
        }
    }
    
    func setCorner() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
    }
    
    override open func prepareForInterfaceBuilder() {
        setCorner()
    }
}
