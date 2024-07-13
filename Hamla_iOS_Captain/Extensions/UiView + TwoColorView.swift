//
//  UiView.swift
//  Hamla
//
//  Created by Bassant on 17/03/2024.
//

import Foundation
import UIKit

extension UIView {
    func twoColorDiagonalView(color1: UIColor, color2: UIColor, cornerRadius: CGFloat = 0) {
        // Save the current graphics context
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)

        // Create path for the first triangle (top-left)
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 0, y: bounds.height))
        path1.addLine(to: CGPoint(x: 0, y: 0))
        path1.addLine(to: CGPoint(x: bounds.width, y: 0))
        path1.close()

        // Set color for the first triangle and fill it
        color1.setFill()
        path1.fill()

        // Create path for the second triangle (bottom-right)
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: bounds.width, y: 0))
        path2.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path2.addLine(to: CGPoint(x: 0, y: bounds.height))
        path2.close()

        // Set color for the second triangle and fill it
        color2.setFill()
        path2.fill()

        // Draw the triangles on the view's layer
        layer.contents = UIGraphicsGetImageFromCurrentImageContext()?.cgImage

        // End the graphics context
        UIGraphicsEndImageContext()
        
        // Apply corner radius
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}
