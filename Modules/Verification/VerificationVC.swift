//
//  VerificationVC.swift
//  Hamla
//
//  Created by Bassant on 28/03/2024.
//

import UIKit

protocol OTPTextFieldDelegate: AnyObject {
    func textFieldDidDelete(textfield: OTPTextField)
}

class OTPTextField: UITextField {
    
    weak var OTPDelegate: OTPTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        OTPDelegate?.textFieldDidDelete(textfield: self)
    }
    
    
}

class VerificationVC: UIViewController{
    
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet var otpCollection: [OTPTextField]!
    @IBOutlet weak var resendButton: UIButton!
    
    var timer: Timer?
    let totalTime: TimeInterval = 10
    var remainingTime: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Verification"
        setupNavigationBar()
        
        instructionLabel.twoColorLabel(word: "+201149336618", color: UIColor(named: "accent") ?? .black)
        for (index, textField) in otpCollection.enumerated() {
            textField.tag = index
            //textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
            textField.OTPDelegate = self
            textField.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        otpCollection[0].becomeFirstResponder()
    }
    
    func startTimer() {
        remainingTime = totalTime
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.remainingTime -= 1
            self?.updateResendButton()
            
            if self?.remainingTime == 0 {
                self?.resendButton.isEnabled = true
                self?.resendButton.setTitleColor(UIColor(named: "accent"), for: .normal)
                self?.resendButton.setTitle("Resend", for: .normal)
                // Invalidate the timer
                self?.timer?.invalidate()
                self?.timer = nil
            }
        }
    }
    
    func updateResendButton(){
        let min = Int(remainingTime) / 60
        let sec = Int(remainingTime) % 60
        let timeFormat = String(format: "%2d:%02d", min, sec)
        let text = "Resend (\(timeFormat)s)"
        UIView.performWithoutAnimation {
            resendButton.setTitle(text, for: .normal)
            resendButton.layoutIfNeeded()
        }
    }
    
    @IBAction func verifyCode(_ sender: Any) {
        startTimer()
    }
    
    @IBAction func resendCode(_ sender: Any) {
        let vc = PersonalInformationVC(nibName: "PersonalInformationVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension VerificationVC: OTPTextFieldDelegate, UITextFieldDelegate {
    
    @objc func textDidChange(textField: UITextField) {
        //let text = textField.text
        let nextIndex = textField.tag + 1
        
        //otpCollection[nextIndex].becomeFirstResponder()
        
        //        if nextIndex < otpCollection.count {
        //            otpCollection[nextIndex].becomeFirstResponder()
        //        }
        
        if let text = textField.text, !text.isEmpty {
            otpCollection[nextIndex].becomeFirstResponder()
        }
        if textField.tag == otpCollection.count - 1 {
            otpCollection[textField.tag].resignFirstResponder()
        }
//        }else if text?.count == 1 {
//            otpCollection[nextIndex].becomeFirstResponder()
//        }
    }
    
    func textFieldDidDelete(textfield: OTPTextField) {
        if textfield.text?.count == 0 && textfield.tag != 0 {
            otpCollection[textfield.tag - 1].becomeFirstResponder()
        }
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let newPosition = textField.endOfDocument
//        DispatchQueue.main.async {
//            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
//        }
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 1 && range.length == 0 {
            textField.text = string
        }
        let nextIndex = textField.tag + 1
        
        //otpCollection[nextIndex].becomeFirstResponder()
        
        //        if nextIndex < otpCollection.count {
        //            otpCollection[nextIndex].becomeFirstResponder()
        //        }
        if string.count == 0 {
            return true
        }
        if textField.tag == otpCollection.count - 1 {
            otpCollection[textField.tag].resignFirstResponder()
        }
        
        else if let text = textField.text, !text.isEmpty {
            otpCollection[nextIndex].becomeFirstResponder()
        }
        
        return false
    }
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
    //        let maxCharacters = 1
    //
    //        return newText.count <= maxCharacters
    //    }
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        // Detect backspace key press
    //        if string.isEmpty && range.length == 1 {
    //            let previousIndex = textField.tag - 1
    //            if previousIndex >= 0 {
    //                otpCollection[textField.tag].text = ""
    //                otpCollection[previousIndex].becomeFirstResponder()
    //                return false // Cancel the default behavior of deleting text
    //            }
    //        }
    //        return true
    //    }
}
