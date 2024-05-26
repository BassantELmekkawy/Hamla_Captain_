//
//  OrderCompletedSheet.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 25/05/2024.
//

import UIKit
import Cosmos

protocol OrderCompletedSheetDelegate: AnyObject {
    func submitAmount(amount: String)
}

class OrderCompletedSheet: UIViewController {

    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var costView: UIView!
    @IBOutlet weak var cost: UILabel!
    
    var isPaymentConfirmed = false
    var rating = 0
    weak var delegate: OrderCompletedSheetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch isPaymentConfirmed {
        case false:
            ratingView.isHidden = true
        case true:
            ratingView.isHidden = false
            amount.isHidden = true
            costView.isHidden = true
            instructionsLabel.text = "Rate HAMLA customer"
        }
    }

    @IBAction func submit(_ sender: Any) {
        rating = Int(cosmosView.rating)
        delegate?.submitAmount(amount: amount.text ?? "")
    }
}
