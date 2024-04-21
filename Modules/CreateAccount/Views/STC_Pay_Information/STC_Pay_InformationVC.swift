//
//  STC_Pay_InformationVC.swift
//  Hamla
//
//  Created by Bassant on 10/03/2024.
//

import UIKit

class STC_Pay_InformationVC: UIViewController {

    @IBOutlet weak var STC_AccountNumberTF: UITextField!
    @IBOutlet weak var STC_AccountNumberView: UIView!
    @IBOutlet weak var STC_AccountNumberLabel: UILabel!
    @IBOutlet weak var changeNumberBtn: UIButton!
    @IBOutlet weak var submitMyRequestBtn: UIButton!
    @IBOutlet weak var startAuthentication: UIButton!
    @IBOutlet weak var authenticatedView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: CreateAccountViewModel?
    
    var fullName = ""
    var phoneNumber = ""
    var governmentID = ""
    var plateNumber = ""
    var imageDictionary: [Int: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = CreateAccountViewModel(api: RegisterApi())
        setUpView()
        bindData()
    }

    func setUpView() {
        self.title = "Create account"
        setupNavigationBar()
        submitMyRequestBtn.isUserInteractionEnabled = false
        //activityIndicator.isHidden = true
        STC_AccountNumberTF.addPadding()
        
        let color = UIColor(named: "primary-dark")?.withAlphaComponent(0.5)
        let placeholder = STC_AccountNumberTF.placeholder ?? ""
        STC_AccountNumberTF.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color ?? .placeholderText])
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
                let vc = HomeVC(nibName: "HomeVC", bundle: nil)
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
        
        viewModel?.register(fullName: fullName,
                            birthday: "2001-01-01",
                            mobile: "20\(phoneNumber)",
                            nationalID: governmentID,
                            nationalExpiryDate: "2025-12-31",
                            nationalIDImage: imageDictionary[1] ?? "",
                            licenseExpiryDate: "2025-12-31",
                            licenseImage: imageDictionary[2] ?? "",
                            avatar: imageDictionary[0] ?? "",
                            plateNumber: plateNumber,
                            color: "white",
                            size: "10",
                            truckTypeID: "1",
                            truckImage: imageDictionary[3] ?? "",
                            licenseTruckImage: imageDictionary[4] ?? "",
                            licenseTruckExpireDate: "2025-12-31",
                            stcAccount: STC_AccountNumberTF.text ?? "",
                            deviceID: "123456",
                            deviceType: "ios",
                            deviceToken: "123456")
    }

    @IBAction func StartAuthentication(_ sender: Any) {
        STC_AccountNumberTF.isHidden = true
        startAuthentication.isHidden = true
        STC_AccountNumberView.isHidden = false
        STC_AccountNumberLabel.text = STC_AccountNumberTF.text
        changeNumberBtn.isHidden = false
        authenticatedView.isHidden = false
        submitMyRequestBtn.backgroundColor = UIColor(named: "primary")
        submitMyRequestBtn.isUserInteractionEnabled = true
    }
    
    @IBAction func SkipAndSubmit(_ sender: Any) {
//        let vc = HomeVC(nibName: "HomeVC", bundle: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
        
        viewModel?.register(fullName: "Test Captain",
                            birthday: "2001-01-01",
                            mobile: "20\(phoneNumber)",
                            nationalID: "12345688",
                            nationalExpiryDate: "2025-12-31",
                            nationalIDImage: "captains/0201220020000/111111.jpg",
                            licenseExpiryDate: "2025-12-31",
                            licenseImage: "captains/0201220020000/111112.jpg",
                            avatar: "captains/0201220020000/111113.jpg",
                            plateNumber: "1226 س ص ع",
                            color: "white",
                            size: "10",
                            truckTypeID: "1",
                            truckImage: "captains/0201220020000/111113.jpg",
                            licenseTruckImage: "captains/0201220020000/111114.jpg",
                            licenseTruckExpireDate: "2025-12-31",
                            stcAccount: STC_AccountNumberTF.text ?? "",
                            deviceID: "123456",
                            deviceType: "ios",
                            deviceToken: "123456")
    }
}
