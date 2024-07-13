//
//  UiLabel + twoColorLabel.swift
//  Hamla
//
//  Created by Bassant on 02/04/2024.
//

import Foundation
import UIKit

extension UILabel{
    func twoColorLabel(word: String, color: UIColor) {
        guard let labelText = text else { return }
        
        // Create an attributed string from the label's text
        let attributedString = NSMutableAttributedString(string: labelText)
        
        // Find the range of the specific word to highlight
        let range = (labelText as NSString).range(of: word)
        
        // Apply attributes to the specific word
        let attributesForWord: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
        attributedString.addAttributes(attributesForWord, range: range)
        
        // Set the attributed text to the label
        attributedText = attributedString
    }}
