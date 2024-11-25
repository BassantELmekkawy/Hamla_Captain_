//
//  SignInVC.swift
//  Hamla
//
//  Created by Bassant on 28/03/2024.
//

import UIKit

class SignInVC: UIViewController {
    
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: SignInViewModel?
    var countryDropDown: DropdownMenu?
    var countryCode = "20"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = SignInViewModel(api: SignInApi())
        setUpView()
        setupToolbar()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setUpView(){
        setupNavigationBar()
        activityIndicator.isHidden = true
        phoneTF.addPadding()
        phoneTF.delegate = self
        
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(viewTapGesture)
    }
    
    func setupToolbar(){
        let bar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, doneButton]
        bar.sizeToFit()
        phoneTF.inputAccessoryView = bar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func bindData(){
        viewModel?.sendCodeResult.bind { result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self.showAlert(message: message)
            }
            else{
                let vc = VerificationVC(nibName: "VerificationVC", bundle: nil)
                vc.countryCode = self.countryCode
                vc.phoneNumber = self.countryCode + (self.phoneTF.text ?? "")
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
    
    @IBAction func selectCountry(_ sender: UIButton) {
        let countries = ["Egypt", "Saudi Arabia"]
        countryDropDown = DropdownMenu(dataSource: countries, button: sender, customCellType: CountryCell.self)
        countryDropDown?.setupDropdownMenu(width: 220, height: 40)
        
        countryDropDown?.customCell = { cell, indexPath in
            if let countryCell = cell as? CountryCell {
                countryCell.countryName = countries[indexPath.row]
            }
        }
        
        countryDropDown?.selectedElement = { [weak self] element in
            switch element {
            case "Egypt":
                self?.flagImage.image = UIImage(named: "Egypt_flag")
                self?.countryCodeLabel.text = "+20"
                self?.countryCode = "20"
                self?.phoneTF.placeholder = "100 123 5678"
            case "Saudi Arabia":
                self?.flagImage.image = UIImage(named: "Saudi_arabia_flag")
                self?.countryCodeLabel.text = "+966"
                self?.countryCode = "966"
                self?.phoneTF.placeholder = "50 235 1456"
            default:
                break
            }
            print(element)
        }
    }
    
    @IBAction func Next(_ sender: Any) {
        if phoneTF.text!.isEmpty{
            self.showAlert(message: "Phone_number_is_required".localized)
        }
        if viewModel!.isValidPhone(phone: phoneTF.text ?? "", countryCode: countryCode){
            viewModel?.sendCode(mobile: "\(countryCode)\(phoneTF.text ?? "")")
        }
        else{
            self.showAlert(message: "Invalid_phone_number".localized)
        }
    }
    
//    @IBAction func CreateCaptainAccount(_ sender: Any) {
//        let vc = PersonalInformationVC(nibName: "PersonalInformationVC", bundle: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
}

extension SignInVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Prevent "0" characters as the first characters.
        if textField.text?.count == 0 && string == "0" {
            return false
        }
        
        //Limit the character count.
        var max = 0
        switch countryCode {
        case "20":
            max = 10
        case "966":
            max = 9
        default:
            break
        }
        if ((textField.text!) + string).count > max {
            return false
        }
        
        return true
    }
    
}
