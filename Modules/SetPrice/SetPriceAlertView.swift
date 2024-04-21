//
//  SetPriceAlertView.swift
//  Hamla
//
//  Created by Bassant on 12/03/2024.
//

import UIKit

class SetPriceAlertView: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAlert))
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissAlert() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func Send(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
