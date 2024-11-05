//
//  SignatureVC.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant Elmekkawy on 07/10/2024.
//

import UIKit

class SignatureView: DashedBorderView {

    private var path = UIBezierPath()
    private var previousPoint: CGPoint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestureRecognizer()
    }
    
    private func setupGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        self.addGestureRecognizer(panGesture)
    }

    @objc private func panGesture(_ sender: UIPanGestureRecognizer) {
        let currentPoint = sender.location(in: self)
        
        switch sender.state {
        case .began:
            path.move(to: currentPoint)
        case .changed:
            path.addLine(to: currentPoint)
            self.setNeedsDisplay()
        case .ended:
            path.addLine(to: currentPoint)
            self.setNeedsDisplay()
        default:
            break
        }
        
        previousPoint = currentPoint
    }

    override func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        path.lineWidth = 2.0
        path.stroke()
    }
    
    func clearSignature() {
        path.removeAllPoints()
        self.setNeedsDisplay()
    }
    
    func getSignatureImage() -> UIImage? {
        UIGraphicsBeginImageContext(self.frame.size)
        defer { UIGraphicsEndImageContext() }
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

class SignatureVC: UIViewController {

    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var signatureView: SignatureView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Assistant’s signature"
        info.twoColorLabel(word: "Assistant's signature", color: UIColor(named: "quaternary") ?? .black)
    }
    
    @IBAction func submit(_ sender: Any) {

    }
    
}
