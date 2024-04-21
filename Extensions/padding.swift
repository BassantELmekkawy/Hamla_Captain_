//
//  padding.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 15/04/2024.
//

import Foundation
import UIKit

extension UITextField{
    func addPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
