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
    @IBOutlet var imageCollection: [UIImageView]!
    
    var phoneNumber = ""
    var tag = 0
    let pickerVC = PhotoActionSheet()
    var image: UIImage?
    
    var viewModel: CreateAccountViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = CreateAccountViewModel()
        setUpView()
        bindData()
    }
    
    func setUpView() {
        self.title = "Create account"
        setupNavigationBar()
        
        phoneTF.text = phoneNumber
        
        let color = UIColor(named: "primary-dark")?.withAlphaComponent(0.5)
        let fullNamePlaceholder = fullName.placeholder ?? ""
        let governmentPlaceholder = governmentID.placeholder ?? ""
        fullName.attributedPlaceholder = NSAttributedString(string: fullNamePlaceholder, attributes: [NSAttributedString.Key.foregroundColor : color ?? .placeholderText])
        governmentID.attributedPlaceholder = NSAttributedString(string: governmentPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : color ?? .placeholderText])
    }
    
    func bindData(){
        viewModel?.uploadImageResult.bind { [self] result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self.showAlert(message: message)
            }
            else {
                imageCollection[tag].image = image
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
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func openPhoto(_ sender: UIButton) {
        tag = sender.tag
        pickerVC.delegate = self
        pickerVC.showActionSheet(from: self)
    }
    
}


extension PersonalInformationVC: PhotoActionSheetDelegate {
    
    func didSelectImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        self.image = image
        viewModel?.uploadImageToserver(file: imageData)
    }
}
