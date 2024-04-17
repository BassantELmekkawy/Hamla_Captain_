//
//  otpTextfield.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 16/04/2024.
//

import Foundation
import UIKit

protocol OTPTextFieldDelegate: AnyObject {
    func textFieldDidDelete(textfield: OTPTextField)
}

class OTPTextField: UITextField {
    
    weak var OTPDelegate: OTPTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        OTPDelegate?.textFieldDidDelete(textfield: self)
    }
}
