//
//  VerificationVC.swift
//  Hamla
//
//  Created by Bassant on 28/03/2024.
//

import UIKit

class VerificationVC: UIViewController{
    
    @IBOutlet weak var otpVerificationMessage: UILabel!
    @IBOutlet var otpCollection: [OTPTextField]!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: VerificationViewModel?
    var signInViewModel: SignInViewModel?
    
    var phoneNumber = ""
    var timer: Timer?
    let totalTime: TimeInterval = 90
    var remainingTime: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = VerificationViewModel(api: VerificationApi())
        signInViewModel = SignInViewModel(api: SignInApi())
        startTimer()
        setUpView()
        bindData()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        otpCollection[0].becomeFirstResponder()
    }
    
    func setUpView(){
        self.title = "Verification"
        setupNavigationBar()
        
        otpVerificationMessage.text = "We sent an OTP code to +20\(phoneNumber) to verify it’s you!"
        otpVerificationMessage.twoColorLabel(word: "+20\(phoneNumber)", color: UIColor(named: "accent") ?? .black)
        
        for (index, textField) in otpCollection.enumerated() {
            textField.tag = index
            textField.OTPDelegate = self
            textField.delegate = self
        }
    }
    
    func bindData(){
        viewModel?.checkCodeResult.bind { result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self.showAlert(message: message)
                for otpTextField in self.otpCollection{
                    otpTextField.text = ""
                }
                self.otpCollection[0].becomeFirstResponder()
            }
            else if result?.is_new == true {
                UserInfo.shared.isPhoneVerified(status: true)
                if UserInfo.shared.getLogin() {
                    self.viewModel?.updateProfile(mobile: "20\(self.phoneNumber)")
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    let vc = PersonalInformationVC(nibName: "PersonalInformationVC", bundle: nil)
                    vc.phoneNumber = self.phoneNumber
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else{
                UserInfo.shared.isPhoneVerified(status: true)
                UserInfo.shared.setLogin(value: true)
                UserInfo.shared.setData(model: (result?.data)!)
                let vc = HomeVC(nibName: "HomeVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            print(message)
        }
        
        viewModel?.updateProfileResult.bind { result in
            guard let message = result?.message else { return }
            self.showAlert(message: message)
            print(message)
        }
        
        viewModel?.errorMessage.bind{ error in
            if let error = error {
                self.showAlert(message: error)
                print(error)
            }
        }
        
        viewModel?.isLoading.bind { [weak self] isLoading in
            guard let self = self else { return }
            self.activityIndicator.isHidden = false
            if let isLoading = isLoading, isLoading {
                self.activityIndicator.startAnimating()
                self.view.isUserInteractionEnabled = false
            } else {
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
        
        signInViewModel?.sendCodeResult.bind{ result in
            guard let message = result?.message else { return }
            self.showAlert(message: message)
        }
        
        signInViewModel?.errorMessage.bind{ error in
            if let error = error {
                self.showAlert(message: error)
                print(error)
            }
        }
    }
    
    func startTimer() {
        resendButton.isEnabled = false
        
        remainingTime = totalTime
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.remainingTime -= 1
            self?.updateResendButton()
            
            if self?.remainingTime == 0 {
                UIView.performWithoutAnimation {
                    self?.resendButton.isEnabled = true
                    self?.resendButton.setTitleColor(UIColor(named: "accent"), for: .normal)
                    self?.resendButton.setTitle("Resend", for: .normal)
                    self?.resendButton.layoutIfNeeded()
                }
                // Invalidate the timer
                self?.timer?.invalidate()
                self?.timer = nil
            }
        }
    }
    
    func updateResendButton() {
        let min = Int(remainingTime) / 60
        let sec = Int(remainingTime) % 60
        let timeFormat = String(format: "%2d:%02d", min, sec)
        let text = "Resend (\(timeFormat)s)"
        UIView.performWithoutAnimation {
            resendButton.setTitle(text, for: .normal)
            resendButton.setTitleColor(UIColor(named: "gray1"), for: .normal)
            resendButton.layoutIfNeeded()
        }
    }
    
    @IBAction func verifyCode(_ sender: Any) {
        var verificationCode = ""
        for otpTextField in otpCollection{
            if otpTextField.text!.isEmpty{
                self.showAlert(message: "Please fill in all fields")
                return
            }
            verificationCode += otpTextField.text ?? ""
        }
        viewModel?.checkCode(mobile: "20\(phoneNumber)", verificationCode: verificationCode, deviceToken: "1234", deviceType: "ios")
    }
    
    @IBAction func resendCode(_ sender: Any) {
        startTimer()
        signInViewModel?.sendCode(mobile: "20\(phoneNumber)")
    }
    
}


extension VerificationVC: OTPTextFieldDelegate, UITextFieldDelegate {
    
    func textFieldDidDelete(textfield: OTPTextField) {
        if textfield.text?.count == 0 && textfield.tag != 0 {
            otpCollection[textfield.tag - 1].becomeFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 1 && range.length == 0 {
            textField.text = string
        }
        let nextIndex = textField.tag + 1
        
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

}
