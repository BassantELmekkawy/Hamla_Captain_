//
//  PersonalInformationVC.swift
//  Hamla
//
//  Created by Bassant on 10/03/2024.
//

import UIKit
import PhotosUI

class PersonalInformationVC: UIViewController {
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var governmentID: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var calender: UIImageView!
    @IBOutlet weak var dateOfBirth: UIView!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    
    @IBOutlet var imageCollection: [UIImageView]!
    
    var phoneNumber = ""
    var tag = 0
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
        
        //phoneTF.text = phoneNumber
        
        fullName.addPadding()
        phoneTF.addPadding()
        governmentID.addPadding()
        
        phoneTF.delegate = self
        
        let color = UIColor(named: "primary-dark")?.withAlphaComponent(0.5)
        let fullNamePlaceholder = fullName.placeholder ?? ""
        let governmentPlaceholder = governmentID.placeholder ?? ""
        fullName.attributedPlaceholder = NSAttributedString(string: fullNamePlaceholder, attributes: [NSAttributedString.Key.foregroundColor : color ?? .placeholderText])
        governmentID.attributedPlaceholder = NSAttributedString(string: governmentPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : color ?? .placeholderText])
        
        // Add tap gesture recognizer to the date view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateViewTapped))
        dateOfBirth.addGestureRecognizer(tapGesture)
        
    }
    
    func showCalender() {
        let alertViewController = CalenderAlert(nibName: "CalenderAlert", bundle: nil)
        alertViewController.modalPresentationStyle = .overCurrentContext
        alertViewController.modalTransitionStyle = .crossDissolve
        alertViewController.didSelectDate = { selectedDate in
            print("Date of birth: \(selectedDate)")
            self.dateOfBirthLabel.text = selectedDate
        }
        present(alertViewController, animated: true, completion: nil)
    }
    
    @objc func dateViewTapped() {
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

    @IBAction func Continue(_ sender: Any) {
        let vc = FleetInformationVC(nibName: "FleetInformationVC", bundle: nil)
        vc.fullName = fullName.text ?? ""
        vc.phoneNumber = phoneTF.text ?? ""
        vc.governmentID = governmentID.text ?? ""
        vc.imageDictionary = imageDictionary
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func openPhoto(_ sender: UIButton) {
        tag = sender.tag
        pickerVC.delegate = self
        pickerVC.showActionSheet(from: self)
    }
    
}

extension PersonalInformationVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            //Prevent "0" character as the first character.
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
