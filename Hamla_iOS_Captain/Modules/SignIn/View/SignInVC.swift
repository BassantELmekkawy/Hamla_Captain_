//
//  SignInVC.swift
//  Hamla
//
//  Created by Bassant on 28/03/2024.
//

import UIKit

class SignInVC: UIViewController {
    
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: SignInViewModel?    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = SignInViewModel(api: SignInApi())
        setUpView()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setUpView(){
        //self.navigationController?.navigationBar.isHidden = true
        setupNavigationBar()
        
        activityIndicator.isHidden = true
        phoneTF.addPadding()
        phoneTF.delegate = self
    }
    func bindData(){
        viewModel?.sendCodeResult.bind { result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self.showAlert(message: message)
            }
            else{
                let vc = VerificationVC(nibName: "VerificationVC", bundle: nil)
                vc.phoneNumber = self.phoneTF.text ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
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
    }
    
    @IBAction func Login(_ sender: Any) {
        if phoneTF.text!.isEmpty{
            self.showAlert(message: "Phone_number_is_required".localized)
        }
        if viewModel!.isValidPhone(phone: "0\(phoneTF.text ?? "")"){
            viewModel?.sendCode(mobile: "20\(phoneTF.text ?? "")" )
        }
        else{
            self.showAlert(message: "Invalid_phone_number".localized)
        }
    }
    
    @IBAction func CreateCaptainAccount(_ sender: Any) {
        let vc = PersonalInformationVC(nibName: "PersonalInformationVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SignInVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            //Prevent "0" characters as the first characters.
            if textField.text?.count == 0 && string == "0" {
                return false
            }
            
            //Limit the character count to 10.
            if ((textField.text!) + string).count > 10 {
                return false
            }
        
        return true
    }
    
}
