//
//  FleetInformationVC.swift
//  Hamla
//
//  Created by Bassant on 10/03/2024.
//

import UIKit
import JVFloatLabeledTextField

class FleetInformationVC: UIViewController {

    @IBOutlet weak var plateNumberTF: JVFloatLabeledTextField!
    @IBOutlet var imageCollection: [UIImageView]!
    @IBOutlet var fleetInfo: [UIButton]!
    @IBOutlet var dropDownFleetTF: [JVFloatLabeledTextField]!
    @IBOutlet weak var fleetLicenseExpiryDateTF: JVFloatLabeledTextField!
    @IBOutlet var errorMessage: [UILabel]!
    
    var captainRegisterData = registerData()
    var tag = 0
    let pickerVC = PhotoActionSheet()
    var fleetData: [String] = []
    var truckTypes: [String]?
    
    var dropDownMenu: DropdownMenu!
    var circularProgressView: CircularProgressView?
    var overlayView: UIView?
    var viewModel: CreateAccountViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = CreateAccountViewModel(api: RegisterApi())
        setUpView()
        bindData()
        viewModel?.getTruckTypes()
    }
    
    func setUpView() {
        self.title = "Create_account".localized
        setupNavigationBar()
        
        plateNumberTF.addPadding()
        fleetLicenseExpiryDateTF.addPadding()
        let placeholderColor = UIColor(named: "primary-dark")?.withAlphaComponent(0.5)
        let placeholder = plateNumberTF.placeholder ?? ""
        plateNumberTF.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : placeholderColor ?? .placeholderText])
        plateNumberTF.floatingLabelActiveTextColor = placeholderColor
        plateNumberTF.delegate = self
        
        for textfield in dropDownFleetTF {
            textfield.addPadding()
            let placeholder = textfield.placeholder ?? ""
            textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : placeholderColor ?? .placeholderText])
            textfield.floatingLabelActiveTextColor = placeholderColor
            textfield.delegate = self
        }
        
        let licenseDatePlaceholder = fleetLicenseExpiryDateTF.placeholder ?? ""
        fleetLicenseExpiryDateTF.attributedPlaceholder = NSAttributedString(string: licenseDatePlaceholder, attributes: [NSAttributedString.Key.foregroundColor : placeholderColor ?? .placeholderText])
        fleetLicenseExpiryDateTF.floatingLabelActiveTextColor = placeholderColor
        fleetLicenseExpiryDateTF.delegate = self
        
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(viewTapGesture)
    }
    
    @objc func dismissKeyboard() {
        // dismiss the keyboard by making the text field resign its first responder status
        view.endEditing(true)
    }
    
    func showCalender(textfield: UITextField) {
        let alertViewController = CalenderAlert(nibName: "CalenderAlert", bundle: nil)
        alertViewController.modalPresentationStyle = .overCurrentContext
        alertViewController.modalTransitionStyle = .crossDissolve
        alertViewController.didSelectDate = { selectedDate in
            textfield.text = selectedDate
        }
        present(alertViewController, animated: true, completion: nil)
    }
    
    func bindData(){
        
        viewModel?.uploadImageResult.bind { [weak self] result in
            guard let message = result.1?.message else { return }
            if result.1?.status == 0 {
                self?.showAlert(message: message)
            }
            else {
                self?.imageCollection[result.0].subviews.forEach { $0.removeFromSuperview() }
                self?.captainRegisterData.imageDictionary?[result.0 + 3] = result.1?.data  // 3 indicates the number of the previous screen uploaded images
            }

            print(message)
        }
        
//        viewModel?.tag.bind { [weak self] tag in
//            guard let self = self else { return }
//            if let tag = tag{
//                self.imageCollection[tag].subviews.forEach { $0.removeFromSuperview() }
//            }
//        }
        
        viewModel?.truckTypesResult.bind { [weak self] result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            }
            else {
                self?.truckTypes = result?.data?.compactMap { $0.name }
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
    
    
    @IBAction func setFleetInformation(_ sender: UIButton) {
        switch sender.tag{
        case 0:  // Fleet type
            fleetData = truckTypes ?? []
        case 1:  // Fleet color
            fleetData = ["white"]
        case 2:  // Fleet size
            fleetData = ["10"]
        default:
            break
        }
        
        dropDownMenu = DropdownMenu(dataSource: fleetData, button: sender)
        dropDownMenu.setupDropdownMenu()
        dropDownMenu.showTableView(frames: sender.frame)
        
        dropDownMenu.selectedElement = { [weak self] element in
            //self.selectedFleetData[sender.tag] = element
            switch sender.tag{
            case 0:
                self?.captainRegisterData.fleetType = String((self?.dropDownMenu.selectedRow ?? 0) + 1)
            case 1:
                self?.captainRegisterData.fleetColor = element
            case 2:
                self?.captainRegisterData.fleetSize = element
            default:
                break
            }
            self?.dropDownFleetTF[sender.tag].text = element
        }
        
        hideErrorMessage(label: errorMessage[sender.tag+1], view: dropDownFleetTF[sender.tag])
    }
    
    @IBAction func openPhoto(_ sender: UIButton) {
        tag = sender.tag
        hideErrorMessage(label: errorMessage[tag+4], view: imageCollection[tag])
        pickerVC.delegate = self
        pickerVC.showActionSheet(from: self)
    }
    func isValidData() -> Bool {
        if let plateNumber = plateNumberTF.text, plateNumber.isEmpty{
            showErrorMessage(message: "Plate_number_is_required".localized, label: errorMessage[0], view: plateNumberTF)
        }
        else if captainRegisterData.fleetType == nil {
            showErrorMessage(message: "Fleet_type_is_required".localized, label: errorMessage[1], view: dropDownFleetTF[0])
        }
        else if captainRegisterData.fleetColor == nil {
            showErrorMessage(message: "Fleet_color_is_required".localized, label: errorMessage[2], view: dropDownFleetTF[1])
        }
        else if captainRegisterData.fleetSize == nil {
            showErrorMessage(message: "Fleet_size_is_required".localized, label: errorMessage[3], view: dropDownFleetTF[2])
        }
        else if let fleetLicenseExpiryDate = fleetLicenseExpiryDateTF.text, fleetLicenseExpiryDate.isEmpty {
            showErrorMessage(message: "Fleet_license_expiry_date_is_required".localized, label: errorMessage[4], view: fleetLicenseExpiryDateTF)
        }
        else {
            let photoArray = ["Fleet_photo", "Fleet_license"]
            for (index, image) in imageCollection.enumerated() {
                if image.image == nil {
                    showErrorMessage(message: "\(photoArray[index])_is_required".localized, label: errorMessage[index+5], view: image)
                    return false
                }
            }
            return true
        }
        return false
    }
    
    @IBAction func Continue(_ sender: Any) {
        if isValidData() && captainRegisterData.imageDictionary?.count == 5 {
            captainRegisterData.plateNumber = plateNumberTF.text
            captainRegisterData.fleetLicenseExpiryDate = fleetLicenseExpiryDateTF.text
            let vc = STC_Pay_InformationVC(nibName: "STC_Pay_InformationVC", bundle: nil)
            vc.captainRegisterData = captainRegisterData
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension FleetInformationVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case plateNumberTF:
            hideErrorMessage(label: errorMessage[0], view: plateNumberTF)
        case dropDownFleetTF[0]:
            hideErrorMessage(label: errorMessage[1], view: dropDownFleetTF[0])
        case dropDownFleetTF[1]:
            hideErrorMessage(label: errorMessage[2], view: dropDownFleetTF[1])
        case dropDownFleetTF[2]:
            hideErrorMessage(label: errorMessage[3], view: dropDownFleetTF[2])
        default:
            break
        }
        textField.borderColor = UIColor(named: "primary")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.borderColor = .clear
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == fleetLicenseExpiryDateTF {
            hideErrorMessage(label: errorMessage[4], view: textField)
            showCalender(textfield: textField)
            return false
        }
        return true
    }
}

extension FleetInformationVC: PhotoActionSheetDelegate {
    
    func didSelectImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        
//        let circularProgressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        circularProgressView.center = view.center
//        circularProgressView.progress = 0.7 // Set the progress value
//        imageCollection[0].addSubview(circularProgressView)
        
        imageCollection[tag].image = image
        circularProgressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        circularProgressView?.center = imageCollection[tag].center
        imageCollection[tag].addSubview(circularProgressView!)
        
        //self.image = image
        //circularProgressView?.progress = 0
        viewModel?.uploadImageToserver(file: imageData, tag: tag, progressHandler: { progress in
            //self.progressView.progress = Float(progress)
            self.circularProgressView?.progress = Float(progress)
            
            
            self.overlayView = UIView(frame: self.imageCollection[self.tag].bounds)
            self.overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.imageCollection[self.tag].addSubview(self.overlayView ?? UIView())
        })
    }
}
