//
//  PersonalInformationVC.swift
//  Hamla
//
//  Created by Bassant on 10/03/2024.
//

import UIKit
import PhotosUI
import JVFloatLabeledTextField

struct registerData{
    var fullName: String?
    var phoneNumber: String?
    var dateOfBirth: String?
    var governmentID: String?
    var imageDictionary: [Int: String]?
    var plateNumber: String?
    var fleetType: String?
    var fleetColor: String?
    var fleetSize: String?
    var STC_Account: String?
}

class PersonalInformationVC: UIViewController {
    
    @IBOutlet weak var fullNameTF: JVFloatLabeledTextField!
    @IBOutlet weak var governmentID_TF: JVFloatLabeledTextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var calender: UIImageView!
    @IBOutlet weak var dateOfBirthView: UIView!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    
    @IBOutlet var imageCollection: [UIImageView]!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var errorMessage: [UILabel]!
    
    var phoneNumber = ""
    var tag = 0
    var selectedDate = ""
    let pickerVC = PhotoActionSheet()
    var image: UIImage?
    var datePicker: UIDatePicker?
    var imageDictionary: [Int: String] = [:]
    var circularProgressView: CircularProgressView?
    var overlayView: UIView?
    
    var viewModel: CreateAccountViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = CreateAccountViewModel(api: RegisterApi())
        setUpView()
        bindData()
    }
    
    func setUpView() {
        self.title = "Create account"
        setupNavigationBar()
        
        if !phoneNumber.isEmpty {
            phoneTF.text = phoneNumber
        }
        
        fullNameTF.addPadding()
        phoneTF.addPadding()
        governmentID_TF.addPadding()
        
        phoneTF.delegate = self
        fullNameTF.delegate = self
        governmentID_TF.delegate = self
        
        let placeholderColor = UIColor(named: "primary-dark")?.withAlphaComponent(0.5)
        let fullNamePlaceholder = fullNameTF.placeholder ?? ""
        let governmentPlaceholder = governmentID_TF.placeholder ?? ""
        fullNameTF.attributedPlaceholder = NSAttributedString(string: fullNamePlaceholder, attributes: [NSAttributedString.Key.foregroundColor : placeholderColor ?? .placeholderText])
        governmentID_TF.attributedPlaceholder = NSAttributedString(string: governmentPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : placeholderColor ?? .placeholderText])
        
        // Add tap gesture recognizer to the date view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateViewTapped))
        dateOfBirthView.addGestureRecognizer(tapGesture)
        
        self.automaticallyAdjustsScrollViewInsets = false
//        if #available(iOS 11.0, *) {
//            scrollView.contentInsetAdjustmentBehavior = .never
//        } else {
//            automaticallyAdjustsScrollViewInsets = false
//        }
        
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(viewTapGesture)
        
        fullNameTF.floatingLabelYPadding = 8
        fullNameTF.floatingLabelActiveTextColor = placeholderColor
        governmentID_TF.floatingLabelYPadding = 8
        governmentID_TF.floatingLabelActiveTextColor = placeholderColor
        
    }
    
    @objc func dismissKeyboard() {
        // dismiss the keyboard by making the text field resign its first responder status
        view.endEditing(true)
    }
    
    func showCalender() {
        let alertViewController = CalenderAlert(nibName: "CalenderAlert", bundle: nil)
        alertViewController.modalPresentationStyle = .overCurrentContext
        alertViewController.modalTransitionStyle = .crossDissolve
        alertViewController.didSelectDate = { selectedDate in
            print("Date of birth: \(selectedDate)")
            self.selectedDate = selectedDate
            self.dateOfBirthLabel.text = selectedDate
        }
        present(alertViewController, animated: true, completion: nil)
    }
    
    @objc func dateViewTapped() {
        hideErrorMessage(label: errorMessage[2], view: dateOfBirthView)
        showCalender()
    }
    
    func bindData(){
        viewModel?.uploadImageResult.bind { [self] result in
            guard let message = result.1?.message else { return }
            if result.1?.status == 0 {
                self.showAlert(message: message)
            }
            else {
                self.imageCollection[result.0].subviews.forEach { $0.removeFromSuperview() }
                self.imageDictionary[result.0] = result.1?.data
            }

            print(message)
        }
        
        viewModel?.errorMessage.bind{ error in
            if let error = error {
                self.showAlert(message: error)
                print(error)
            }
        }
        
    }
    
    func isValidData() -> Bool {
        if let fullName = fullNameTF.text, fullName.isEmpty{
            showErrorMessage(message: "Full name is required", label: errorMessage[0], view: fullNameTF)
        }
        else if let phone = phoneTF.text, phone.isEmpty{
            showErrorMessage(message: "Phone number is required", label: errorMessage[1], view: phoneView)
        }
        else if !viewModel!.isValidPhone(phone: "0\(phoneTF.text ?? "")"){
            showErrorMessage(message: "Invalid phone number", label: errorMessage[1], view: phoneView)
        }
        else if selectedDate.isEmpty{
            showErrorMessage(message: "Date of birth is required", label: errorMessage[2], view: dateOfBirthView)
        }
        else if let governmentID = governmentID_TF.text, governmentID.isEmpty{
            showErrorMessage(message: "Government ID is required", label: errorMessage[3], view: governmentID_TF)
        }
        else {
            let photoArray = ["Personal", "Government ID", "Driving license"]
            for (index, image) in imageCollection.enumerated() {
                if image.image == nil {
                    //self.showAlert(message: "\(photoArray[index]) photo is required")
                    showErrorMessage(message: "\(photoArray[index]) photo is required", label: errorMessage[index+4], view: image)
                    return false
                }
            }
            return true
        }
        return false
    }

    @IBAction func Continue(_ sender: Any) {
        if isValidData() && imageDictionary.count == 3 {
            let captainRegisterData = registerData(
                fullName: fullNameTF.text,
                phoneNumber: phoneTF.text,
                dateOfBirth: selectedDate,
                governmentID: governmentID_TF.text,
                imageDictionary: imageDictionary
            )
            if !phoneNumber.isEmpty && phoneTF.text != phoneNumber{
                UserInfo.shared.isPhoneVerified(status: false)
            }
            let vc = FleetInformationVC(nibName: "FleetInformationVC", bundle: nil)
            vc.captainRegisterData = captainRegisterData
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func openPhoto(_ sender: UIButton) {
        tag = sender.tag
        hideErrorMessage(label: errorMessage[tag+4], view: imageCollection[tag])
        pickerVC.delegate = self
        pickerVC.showActionSheet(from: self)
    }
    
}

extension PersonalInformationVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == phoneTF {
            //Prevent "0" character as the first character.
            if textField.text?.count == 0 && string == "0" {
                return false
            }
            
            //Limit the character count to 10.
            if ((textField.text!) + string).count > 10 {
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case fullNameTF:
            hideErrorMessage(label: errorMessage[0], view: fullNameTF)
            textField.borderColor = UIColor(named: "primary")
        case phoneTF:
            hideErrorMessage(label: errorMessage[1], view: phoneView)
            phoneView.borderColor = UIColor(named: "primary")
        case governmentID_TF:
            hideErrorMessage(label: errorMessage[3], view: governmentID_TF)
            textField.borderColor = UIColor(named: "primary")
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneTF {
            phoneView.borderColor = .clear
        }
        textField.borderColor = .clear
    }
}

extension PersonalInformationVC: PhotoActionSheetDelegate {
    
    func didSelectImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        imageCollection[tag].image = image
        circularProgressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        circularProgressView?.center = imageCollection[tag].center
        imageCollection[tag].addSubview(circularProgressView!)
        
        viewModel?.uploadImageToserver(file: imageData, tag: tag, progressHandler: { progress in
            self.circularProgressView?.progress = Float(progress)            
            
            self.overlayView = UIView(frame: self.imageCollection[self.tag].bounds)
            self.overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.imageCollection[self.tag].addSubview(self.overlayView ?? UIView())
        })
    }
}


func showErrorMessage(message: String, label: UILabel, view: UIView) {
    label.text = message
    label.isHidden = false
    view.borderColor = .red
    view.borderWidth = 1
}

func hideErrorMessage(label: UILabel, view: UIView) {
    label.isHidden = true
    view.borderColor = .clear
}
