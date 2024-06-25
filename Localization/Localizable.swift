//
//  Localizable.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 24/06/2024.
//

import Foundation
import UIKit

protocol Localizable{
    var localized: String {get}
}

extension String: Localizable{
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
}


protocol xibLocalizable {
    var LocalizableKey: String? { get set }
}

extension UILabel: xibLocalizable{
    @IBInspectable var LocalizableKey: String? {
        get {
            return nil
        }
        set(key) {
            text = key?.localized
        }
    }
}

extension UIButton: xibLocalizable{
    @IBInspectable var LocalizableKey: String? {
        get {
            return nil
        }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
    }
}

extension UITextField: xibLocalizable{
    @IBInspectable var LocalizableKey: String? {
        get {
            return nil
        }
        set(key) {
            placeholder = key?.localized
        }
    }
}
