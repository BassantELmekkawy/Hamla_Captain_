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

class AlertManager {
    private var popup: UIView?
    
    func showAlert(on viewController: UIViewController, message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 180, height: 180))
        popup = UIView(frame: CGRect(x: ((self.popup?.bounds.width ?? 0) - messageLabel.bounds.width) / 2, y: 500, width: messageLabel.bounds.width, height: 20))
        popup?.backgroundColor = UIColor.darkGray
        
        // Create and configure a UILabel for the message
        
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0 // Allow multiple lines for long messages
        messageLabel.textColor = .white
        popup?.addSubview(messageLabel)

        // Show on screen
        if let popup = popup {
            viewController.view.addSubview(popup)
        }

        // Set the timer to dismiss the alert after 3 seconds
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
    }

    @objc func dismissAlert() {
        if let popup = popup {
            popup.removeFromSuperview()
        }
        popup = nil
    }
}
