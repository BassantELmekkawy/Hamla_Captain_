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
    @IBOutlet var fleetInfo: [UIButton]!
    
    var tag = 0
    let pickerVC = PhotoActionSheet()
    var image: UIImage?
    var fullName = ""
    var phoneNumber = ""
    var governmentID = ""
    var imageDictionary: [Int: String] = [:]
    var fleetData: [String] = []
    
    var dropDownMenu: DropdownMenu!
    var circularProgressView: CircularProgressView?
    var overlayView: UIView?
    var viewModel: CreateAccountViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = CreateAccountViewModel(api: RegisterApi())
        setUpView()
        bindData()
        
        //circularProgressView.setProgress(0.5)
        //circularProgressView.createCircleShape()
        //circularProgressView?.addAnimation()
        
//        let circularProgressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        circularProgressView.center = imageCollection[0].center
//        circularProgressView.progress = 0.7 // Set the progress value
//        imageCollection[0].addSubview(circularProgressView)
    }
    
    func setUpView() {
        self.title = "Create account"
        setupNavigationBar()
        
        plateNumber.addPadding()
        let color = UIColor(named: "primary-dark")?.withAlphaComponent(0.5)
        let placeholder = plateNumber.placeholder ?? ""
        plateNumber.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color ?? .placeholderText])
    }
    
    func bindData(){
        viewModel?.uploadImageResult.bind { [self] result in
            guard let message = result.1?.message else { return }
            if result.1?.status == 0 {
                self.showAlert(message: message)
            }
            else {
                self.imageCollection[result.0].subviews.forEach { $0.removeFromSuperview() }
                self.imageDictionary[result.0 + 3] = result.1?.data  // 3 indicates the number of the previous screen uploaded images
            }

            print(message)
        }
        
//        viewModel?.tag.bind { [weak self] tag in
//            guard let self = self else { return }
//            if let tag = tag{
//                self.imageCollection[tag].subviews.forEach { $0.removeFromSuperview() }
//            }
//        }
        
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
            fleetData = ["truck"]
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
    }
    
    @IBAction func openPhoto(_ sender: UIButton) {
        tag = sender.tag
        pickerVC.delegate = self
        pickerVC.showActionSheet(from: self)
    }
    
    @IBAction func Continue(_ sender: Any) {
        let vc = STC_Pay_InformationVC(nibName: "STC_Pay_InformationVC", bundle: nil)
        vc.fullName = fullName
        vc.phoneNumber = phoneNumber
        vc.governmentID = governmentID
        vc.plateNumber = plateNumber.text ?? ""
        vc.imageDictionary = imageDictionary
        self.navigationController?.pushViewController(vc, animated: true)
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
