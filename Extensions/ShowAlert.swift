//
//  ShowAlert.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 15/04/2024.
//

import Foundation
import UIKit

extension UIViewController: UIAlertViewDelegate{
    func showAlert(message: String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
