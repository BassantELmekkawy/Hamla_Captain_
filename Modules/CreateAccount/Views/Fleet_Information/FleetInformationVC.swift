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
    
    var captainRegisterData = registerData()
    var tag = 0
    let pickerVC = PhotoActionSheet()
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
                self.captainRegisterData.imageDictionary?[result.0 + 3] = result.1?.data  // 3 indicates the number of the previous screen uploaded images
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
        
        dropDownMenu.selectedElement = { element in
            //self.selectedFleetData[sender.tag] = element
            switch sender.tag{
            case 0:
                self.captainRegisterData.fleetType = element
            case 1:
                self.captainRegisterData.fleetColor = element
            case 2:
                self.captainRegisterData.fleetSize = element
            default:
                break
            }
        }
    }
    
    @IBAction func openPhoto(_ sender: UIButton) {
        tag = sender.tag
        pickerVC.delegate = self
        pickerVC.showActionSheet(from: self)
    }
    func isValidData() -> Bool {
        if let plateNumber = plateNumber.text, plateNumber.isEmpty{
            self.showAlert(message: "Please enter plate number")
        }
        else if captainRegisterData.fleetType == nil {
            self.showAlert(message: "Please select fleet type")
        }
        else if captainRegisterData.fleetColor == nil {
            self.showAlert(message: "Please select fleet color")
        }
        else if captainRegisterData.fleetSize == nil {
            self.showAlert(message: "Please select fleet size")
        }
        else {
            let photoArray = ["fleet photo", "fleet license"]
            for (index, image) in imageCollection.enumerated() {
                if image.image == nil {
                    self.showAlert(message: "Please upload \(photoArray[index])")
                    return false
                }
            }
            return true
        }
        return false
    }
    
    @IBAction func Continue(_ sender: Any) {
        if isValidData() && captainRegisterData.imageDictionary?.count == 5 {
            captainRegisterData.plateNumber = plateNumber.text
            let vc = STC_Pay_InformationVC(nibName: "STC_Pay_InformationVC", bundle: nil)
            vc.captainRegisterData = captainRegisterData
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
