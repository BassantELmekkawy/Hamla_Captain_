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
    @IBOutlet weak var changeNumberBtn: UIButton!
    @IBOutlet weak var submitMyRequestBtn: UIButton!
    @IBOutlet weak var startAuthentication: UIButton!
    @IBOutlet weak var authenticatedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Create account"
        setupNavigationBar()
        submitMyRequestBtn.isUserInteractionEnabled = false
        
        let color = UIColor(named: "primary-dark")?.withAlphaComponent(0.5)
        let placeholder = STC_AccountNumberTF.placeholder ?? ""
        STC_AccountNumberTF.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color ?? .placeholderText])
    }

    @IBAction func SubmitMyRequest(_ sender: UIButton) {
//        let vc = HomeVC(nibName: "HomeVC", bundle: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func StartAuthentication(_ sender: Any) {
        STC_AccountNumberTF.isHidden = true
        startAuthentication.isHidden = true
        STC_AccountNumberView.isHidden = false
        changeNumberBtn.isHidden = false
        authenticatedView.isHidden = false
        submitMyRequestBtn.backgroundColor = UIColor(named: "primary")
        submitMyRequestBtn.isUserInteractionEnabled = true
    }
    
    @IBAction func SkipAndSubmit(_ sender: Any) {
//        let vc = HomeVC(nibName: "HomeVC", bundle: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
