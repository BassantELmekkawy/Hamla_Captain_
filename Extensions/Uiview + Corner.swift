//
//  Uiview + Corner.swift
//  Hamla
//
//  Created by Bassant on 07/03/2024.
//

import UIKit
import Foundation

extension UIView {
    

    
    @IBInspectable
     var cornerRadius: CGFloat {
        get {
           return layer.cornerRadius
        }
        set {
           layer.cornerRadius = newValue
        }
     }
    
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }


  @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    // Shadow color
    @IBInspectable var shadowColor: UIColor {
        get {
            if let cgColor = layer.shadowColor {
                return UIColor(cgColor: cgColor)
            }
            return UIColor.clear
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    // Shadow opacity
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    // Shadow offset
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    // Shadow radius
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
}
