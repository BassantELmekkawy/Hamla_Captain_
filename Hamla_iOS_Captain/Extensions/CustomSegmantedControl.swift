//
//  CustomSegmantedControl.swift
//  Hamla
//
//  Created by Bassant on 19/03/2024.
//

import Foundation
import UIKit

@IBDesignable
class CustomSegmentedControl: UIControl {
    
    var buttons = [UIButton]()
    var selector: UIView!
    var selectedSegmentIndex = 0
    
    @IBInspectable
    var buttonTitles: String = "" {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var textColor: UIColor = .lightGray {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var selectedTextColor: UIColor = .blue {
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        
        let titles = buttonTitles.components(separatedBy: ",")
        
        for buttonTitle in titles{
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            button.addTarget(self, action: #selector(buttonTapped(button: )), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectedTextColor, for: .normal)
        
        let selectorWidth = frame.width / CGFloat(buttons.count)
        let selectorHeight = 2.0
        selector = UIView(frame: CGRect(x: 0, y: frame.height, width: selectorWidth, height: -selectorHeight))
        selector.backgroundColor = selectedTextColor
        addSubview(selector)
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
    }
    
    @objc func buttonTapped(button: UIButton){
        for (index,btn) in buttons.enumerated(){
            btn.setTitleColor(textColor, for: .normal)
            
            if btn == button {
                selectedSegmentIndex = index
                let selectorStartPosition = CGFloat(index) * selector.frame.width
                UIView.animate(withDuration: 0.3) {
                    self.selector.frame.origin.x = selectorStartPosition
                }
                
                btn.setTitleColor(selectedTextColor, for: .normal)
            }
        }
        sendActions(for: .valueChanged)
    }
}
