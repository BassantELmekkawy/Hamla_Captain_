
import Foundation
import UIKit

class DashedBorderView: UIView {
    
    private let dashedBorderLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDashedBorder()
    }
    
    private func setupDashedBorder() {
        let color = UIColor(named: "DashedBorder")?.cgColor
        
        dashedBorderLayer.fillColor = UIColor.clear.cgColor
        dashedBorderLayer.strokeColor = color
        dashedBorderLayer.lineWidth = 1
        dashedBorderLayer.lineJoin = CAShapeLayerLineJoin.round
        dashedBorderLayer.lineDashPattern = [6, 3]
        
        layer.addSublayer(dashedBorderLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashedBorderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
        dashedBorderLayer.frame = bounds
    }
}
