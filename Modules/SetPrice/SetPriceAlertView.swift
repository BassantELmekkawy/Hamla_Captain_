//
//  SetPriceAlertView.swift
//  Hamla
//
//  Created by Bassant on 12/03/2024.
//

import UIKit

protocol SetPriceDelegate: AnyObject {
    func sendPrice(price: String)
}

class SetPriceAlertView: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var maxPriceLabel: UILabel!
    @IBOutlet var suggestedPricesButttons: [UIButton]!
    @IBOutlet weak var priceTF: UITextField!
    
    var minPrice = ""
    var avgPrice = ""
    var maxPrice = ""
    var selectedPrice = ""
    
    weak var delegate: SetPriceDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAlert))
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
        
        minPriceLabel.text = "\(minPrice) EGP"
        maxPriceLabel.text = "\(maxPrice) EGP"
        suggestedPricesButttons[0].setTitle(minPrice, for: .normal)
        suggestedPricesButttons[1].setTitle(avgPrice, for: .normal)
        suggestedPricesButttons[2].setTitle(maxPrice, for: .normal)
        
        priceTF.addPadding()
    }
    
    @objc func dismissAlert() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func sendSuggestedPrice(_ sender: UIButton) {
        sender.backgroundColor = UIColor(named: "primary")
        sender.setTitleColor(.white, for: .normal)
        for i in 0...2 {
            if sender.tag != i {
                suggestedPricesButttons[i].backgroundColor = .white
                suggestedPricesButttons[i].setTitleColor(UIColor(named: "primary"), for: .normal)
            }
        }
        if let price = sender.titleLabel?.text {
            delegate?.sendPrice(price: price)
        }
    }
    
    @IBAction func Send(_ sender: Any) {
        if let price = priceTF.text, price.isEmpty == false {
            delegate?.sendPrice(price: price)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func Exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
