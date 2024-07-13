//
//  STC_Pay_InformationVC.swift
//  Hamla
//
//  Created by Bassant on 10/03/2024.
//

import UIKit
import JVFloatLabeledTextField

class STC_Pay_InformationVC: UIViewController {

    @IBOutlet weak var STC_AccountNumberTF: JVFloatLabeledTextField!
    @IBOutlet weak var changeNumberBtn: UIButton!
    @IBOutlet weak var submitMyRequestBtn: UIButton!
    @IBOutlet weak var startAuthentication: UIButton!
    @IBOutlet weak var authenticatedView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorMessage: UILabel!
    
    var viewModel: CreateAccountViewModel?
    
    var captainRegisterData = registerData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = CreateAccountViewModel(api: RegisterApi())
        setUpView()
        bindData()
    }

    func setUpView() {
        self.title = "Create_account".localized
        setupNavigationBar()
        submitMyRequestBtn.isUserInteractionEnabled = false
        //activityIndicator.isHidden = true
        STC_AccountNumberTF.addPadding()
        
        let placeholderColor = UIColor(named: "primary-dark")?.withAlphaComponent(0.5)
        let placeholder = STC_AccountNumberTF.placeholder ?? ""
        STC_AccountNumberTF.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : placeholderColor ?? .placeholderText])
        STC_AccountNumberTF.floatingLabelActiveTextColor = placeholderColor
        STC_AccountNumberTF.delegate = self
        
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(viewTapGesture)
    }
    
    @objc func dismissKeyboard() {
        // dismiss the keyboard by making the text field resign its first responder status
        view.endEditing(true)
    }
    
    func bindData(){
        self.activityIndicator.isHidden = true
        
        viewModel?.registerResult.bind { result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self.showAlert(message: message)
            }
            else{
                print("registered successfully")
                
                UserInfo.shared.setData(model: (result?.data)!)
                if UserInfo.shared.isPhoneVerified() {
                    UserInfo.shared.setLogin(value: true)
                    let vc = HomeVC(nibName: "HomeVC", bundle: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    let vm = SignInViewModel(api: SignInApi())
                    vm.sendCode(mobile: "20\(self.captainRegisterData.phoneNumber ?? "")")
                    let vc = VerificationVC(nibName: "VerificationVC", bundle: nil)
                    vm.sendCodeResult.bind { sendCodeResult in
                        guard let message = sendCodeResult?.message else { return }
                        if result?.status == 0 {
                            vc.showAlert(message: message)
                        }
                    }
                    vc.phoneNumber = self.captainRegisterData.phoneNumber ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
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
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                self.view.isUserInteractionEnabled = false
            } else {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func SubmitMyRequest(_ sender: UIButton) {
        viewModel?.register(fullName: captainRegisterData.fullName ?? "",
                            birthday: captainRegisterData.dateOfBirth ?? "",
                            mobile: "20\(captainRegisterData.phoneNumber ?? "")",
                            nationalID: captainRegisterData.governmentID ?? "",
                            nationalExpiryDate: captainRegisterData.idExpiryDate ?? "",
                            nationalIDImage: captainRegisterData.imageDictionary?[1] ?? "",
                            licenseExpiryDate: captainRegisterData.licenseExpiryDate ?? "",
                            licenseImage: captainRegisterData.imageDictionary?[2] ?? "",
                            avatar: captainRegisterData.imageDictionary?[0] ?? "",
                            plateNumber: captainRegisterData.plateNumber ?? "",
                            color: captainRegisterData.fleetColor ?? "",
                            size: captainRegisterData.fleetSize ?? "",
                            truckTypeID: captainRegisterData.fleetType ?? "",
                            truckImage: captainRegisterData.imageDictionary?[3] ?? "",
                            licenseTruckImage: captainRegisterData.imageDictionary?[4] ?? "",
                            licenseTruckExpireDate: captainRegisterData.fleetLicenseExpiryDate ?? "",
                            stcAccount: STC_AccountNumberTF.text ?? "",
                            deviceID: "123456",
                            deviceType: "ios",
                            deviceToken: "123456")

    }

    @IBAction func StartAuthentication(_ sender: Any) {
        dismissKeyboard()
        guard let STC_Account = STC_AccountNumberTF.text, !STC_Account.isEmpty
        else {
            showErrorMessage(message: "Enter_STC_account_number".localized, label: errorMessage, view: STC_AccountNumberTF)
            return
        }
        hideErrorMessage(label: errorMessage, view: STC_AccountNumberTF)
        STC_AccountNumberTF.isEnabled = false
        captainRegisterData.STC_Account = STC_Account
        startAuthentication.isHidden = true
        changeNumberBtn.isHidden = false
        authenticatedView.isHidden = false
        submitMyRequestBtn.backgroundColor = UIColor(named: "primary")
        submitMyRequestBtn.isUserInteractionEnabled = true
    }
    
    @IBAction func changeNumber(_ sender: Any) {
        STC_AccountNumberTF.isEnabled = true
        STC_AccountNumberTF.becomeFirstResponder()
        startAuthentication.isHidden = false
        authenticatedView.isHidden = true
        submitMyRequestBtn.backgroundColor = UIColor(named: "gray1")
        submitMyRequestBtn.isUserInteractionEnabled = false
        changeNumberBtn.isHidden = true
    }
    
    @IBAction func SkipAndSubmit(_ sender: Any) {
//        let vc = HomeVC(nibName: "HomeVC", bundle: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
        
        viewModel?.register(fullName: captainRegisterData.fullName ?? "",
                            birthday: captainRegisterData.dateOfBirth ?? "",
                            mobile: "20\(captainRegisterData.phoneNumber ?? "")",
                            nationalID: captainRegisterData.governmentID ?? "",
                            nationalExpiryDate: "2025-12-31",
                            nationalIDImage: captainRegisterData.imageDictionary?[1] ?? "",
                            licenseExpiryDate: "2025-12-31",
                            licenseImage: captainRegisterData.imageDictionary?[2] ?? "",
                            avatar: captainRegisterData.imageDictionary?[0] ?? "",
                            plateNumber: captainRegisterData.plateNumber ?? "",
                            color: captainRegisterData.fleetColor ?? "",
                            size: captainRegisterData.fleetSize ?? "",
                            truckTypeID: "1",
                            truckImage: captainRegisterData.imageDictionary?[3] ?? "",
                            licenseTruckImage: captainRegisterData.imageDictionary?[4] ?? "",
                            licenseTruckExpireDate: "2025-12-31",
                            stcAccount: nil,
                            deviceID: "123456",
                            deviceType: "ios",
                            deviceToken: "123456")
    }
}

extension STC_Pay_InformationVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideErrorMessage(label: errorMessage, view: STC_AccountNumberTF)
        textField.borderColor = UIColor(named: "primary")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.borderColor = .clear
    }
}
