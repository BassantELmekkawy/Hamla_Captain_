//
//  ProgressView.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 18/04/2024.
//

import Foundation
import UIKit

class CircularProgressView: UIView {
    //let shapeLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    
    var progress: Float{
        didSet{
            addAnimation()
        }
    }
    
    var prevProgress: Float?
    
    override init(frame: CGRect) {
        self.progress = 0.0
        prevProgress = progress
        super.init(frame: frame)
        //configure()
        createCircleShape()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.progress = 0.0
        super.init(coder: aDecoder)
        //configure()
        
    }
    
//    private func configure() {
//        backgroundColor = .clear
//        progressLayer.strokeColor = UIColor.blue.cgColor
//        progressLayer.fillColor = UIColor.clear.cgColor
//        progressLayer.lineWidth = 6.0
//        progressLayer.lineCap = .round
//        layer.addSublayer(progressLayer)
//    }
//
//    func setProgress(_ progress: CGFloat) {
//        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
//        let radius = min(bounds.width, bounds.height) / 2 - progressLayer.lineWidth / 2
//        let startAngle = -CGFloat.pi / 2
//        let endAngle = startAngle + 2 * CGFloat.pi * progress
//
//        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
//
//        let animation = CABasicAnimation(keyPath: "path")
//        animation.toValue = circularPath.cgPath
//        animation.duration = 10.0 // Animation duration
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        progressLayer.add(animation, forKey: "progressAnimation")
//        CATransaction.begin()
//        CATransaction.setDisableActions(true)
//        progressLayer.path = circularPath.cgPath
//        CATransaction.commit()
//    }
    
    func createCircleShape() {
        
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.width/2)
        let trackLayer = CAShapeLayer()
        
        trackLayer.path = path.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 6.0
        self.layer.addSublayer(trackLayer)
        
        progressLayer.path = path.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor(named: "primary")?.withAlphaComponent(0.8).cgColor
        progressLayer.lineWidth = 6.0
        progressLayer.strokeEnd = 0
        progressLayer.lineCap = .round
        self.layer.addSublayer(progressLayer)
    }
    
    func resetProgress() {
        progress = 0.0
        progressLayer.removeAllAnimations()
        progressLayer.strokeEnd = 0.0
    }
    
    func addAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        //basicAnimation.fromValue = prevProgress
        basicAnimation.fromValue = progressLayer.strokeEnd
        basicAnimation.toValue = progress
        //basicAnimation.duration = 5.0
        basicAnimation.fillMode = .forwards
        //basicAnimation.isRemovedOnCompletion = (progress == 1.0) ? true : false
        basicAnimation.isRemovedOnCompletion = false
        //basicAnimation.
        
        progressLayer.add(basicAnimation, forKey: "animation")
        //prevProgress = progress
    }
}

//class CircularProgressView: UIView {
//
//    // Define properties
//    var progress: CGFloat = 0 {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
//    var trackColor: UIColor = UIColor.lightGray
//    var progressColor: UIColor = UIColor.blue
//
//
//
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        self.backgroundColor = .clear
//        // Define the center point and radius
//        let center = CGPoint(x: rect.midX, y: rect.midY)
//        let radius = min(rect.width, rect.height) / 2 - 2
//
//        // Draw track
//        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
//        trackColor.setStroke()
//        trackPath.lineWidth = 4
//        trackPath.stroke()
//
//        // Draw progress
//        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi * progress - CGFloat.pi / 2, clockwise: true)
//        progressColor.setStroke()
//        progressPath.lineWidth = 5
//        progressPath.lineCapStyle = .round
//        progressPath.stroke()
//    }
//}
