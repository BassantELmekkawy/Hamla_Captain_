//
//  SignatureVC.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant Elmekkawy on 07/10/2024.
//

import UIKit

protocol SignatureViewDelegate: AnyObject {
    func orderCompleted()
}

class SignatureVC: UIViewController {

    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var signatureView: SignatureView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel = OrderAttatchmentsViewModel()
    static var shared = SignatureVC()
    weak var delegate: SignatureViewDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Assistant’s signature"
        info.twoColorLabel(word: "Assistant's signature", color: UIColor(named: "quaternary") ?? .black)
        print(signatureView.frame)
        print(signatureView.center)
    }
    
    func bindData(){
        viewModel.uploadImageResult.bind { [self] result in
            guard let message = result.1?.message else { return }
            if result.1?.status == 0 {
                self.showAlert(message: message)
            }
            else {
                delegate?.orderCompleted()
                if let viewControllers = self.navigationController?.viewControllers {
                    for viewController in viewControllers {
                        if viewController is MapVC {
                            self.navigationController?.popToViewController(viewController, animated: true)
                            break
                        }
                    }
                }
            }
            print(message)
        }
        
        viewModel.errorMessage.bind{ error in
            if let error = error {
                self.showAlert(message: error)
                print(error)
            }
        }
        
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self else { return }
            self.activityIndicator.isHidden = false
            if let isLoading = isLoading, isLoading {
                self.activityIndicator.startAnimating()
                self.view.isUserInteractionEnabled = false
            } else {
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
        
    }

    @IBAction func submit(_ sender: Any) {
        let image = signatureView.getSignatureImage()
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else {
            return
        }
        viewModel.uploadImageToserver(file: imageData)
    }
}


class SignatureView: DashedBorderView {

    private var path = UIBezierPath()
    private var previousPoint: CGPoint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestureRecognizer()
    }
    
    private func setupGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        self.addGestureRecognizer(panGesture)
    }

    @objc private func panGesture(_ sender: UIPanGestureRecognizer) {
        let currentPoint = sender.location(in: self)
        
        switch sender.state {
        case .began:
            path.move(to: currentPoint)
        case .changed:
            path.addLine(to: currentPoint)
            self.setNeedsDisplay()
        case .ended:
            path.addLine(to: currentPoint)
            self.setNeedsDisplay()
        default:
            break
        }
        
        previousPoint = currentPoint
    }

    override func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        path.lineWidth = 2.0
        path.stroke()
    }
    
    func clearSignature() {
        path.removeAllPoints()
        self.setNeedsDisplay()
    }
    
    func getSignatureImage() -> UIImage? {
        UIGraphicsBeginImageContext(self.frame.size)
        defer { UIGraphicsEndImageContext() }
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
