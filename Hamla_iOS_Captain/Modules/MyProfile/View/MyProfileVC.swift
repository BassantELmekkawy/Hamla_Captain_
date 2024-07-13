//
//  MyProfileVC.swift
//  Hamla
//
//  Created by Bassant on 17/03/2024.
//

import UIKit

class MyProfileVC: UIViewController {

    @IBOutlet weak var photoBackgroundView: UIView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    var viewModel: MyProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.viewModel = MyProfileViewModel(api: MyProfileApi())
        bindData()
        self.navigationController?.navigationBar.isHidden = false
        self.title = "My_profile".localized
        photoBackgroundView.twoColorDiagonalView(color1: UIColor(named: "primary") ?? .blue, color2: UIColor(named: "LightBlue") ?? .blue, cornerRadius: 8)
    }
    
    func setupView() {
        let user = UserInfo.shared
        let url = URL(string: user.get_image())
        photo.kf.setImage(with: url)
        name.text = user.get_username()
        phone.text = user.get_phone()
    }
    
    func bindData(){
        viewModel?.checkPhoneResult.bind { result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self.showAlert(message: message)
            }
            else{
                let vc = VerificationVC(nibName: "VerificationVC", bundle: nil)
                vc.phoneNumber = String( self.phone.text?.dropFirst(2) ?? "")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            print(message)
        }
        
        viewModel?.updateProfileResult.bind { result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self.showAlert(message: message)
            }
            print(message)
        }
        
        viewModel?.errorMessage.bind{ error in
            if let error = error {
                self.showAlert(message: error)
                print(error)
            }
        }
        
//        viewModel?.isLoading.bind { [weak self] isLoading in
//            guard let self = self else { return }
//            self.activityIndicator.isHidden = false
//            if let isLoading = isLoading, isLoading {
//                self.activityIndicator.startAnimating()
//                self.view.isUserInteractionEnabled = false
//            } else {
//                self.activityIndicator.stopAnimating()
//                self.view.isUserInteractionEnabled = true
//            }
//        }
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        if viewModel!.isValidPhone(phone: phone.text ?? "" ){
            viewModel?.checkPhone(mobile: phone.text ?? "" )
        }
        else{
            self.showAlert(message: "Invalid_phone_number".localized)
        }
    }
    
}
