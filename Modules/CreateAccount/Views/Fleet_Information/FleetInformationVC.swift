//
//  FleetInformationVC.swift
//  Hamla
//
//  Created by Bassant on 10/03/2024.
//

import UIKit

class FleetInformationVC: UIViewController {

    @IBOutlet weak var plateNumber: UITextField!
    @IBOutlet var imageCollection: [UIImageView]!
    
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
        
        let color = UIColor(named: "primary-dark")?.withAlphaComponent(0.5)
        let placeholder = plateNumber.placeholder ?? ""
        plateNumber.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color ?? .placeholderText])
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

    @IBAction func openPhoto(_ sender: UIButton) {
        tag = sender.tag
        pickerVC.delegate = self
        pickerVC.showActionSheet(from: self)
    }
    
    @IBAction func Continue(_ sender: Any) {
        let vc = STC_Pay_InformationVC(nibName: "STC_Pay_InformationVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension FleetInformationVC: PhotoActionSheetDelegate {
    
    func didSelectImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        self.image = image
        viewModel?.uploadImageToserver(file: imageData)
    }
}
