//
//  PersonalInformationVC.swift
//  Hamla
//
//  Created by Bassant on 10/03/2024.
//

import UIKit

class PersonalInformationVC: UIViewController {

    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var governmentID: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Create account"
        setupNavigationBar()
        //navigationItem.hidesBackButton = true
        
        let color = UIColor(named: "primary-dark")?.withAlphaComponent(0.5)
        let fullNamePlaceholder = fullName.placeholder ?? ""
        let governmentPlaceholder = governmentID.placeholder ?? ""
        fullName.attributedPlaceholder = NSAttributedString(string: fullNamePlaceholder, attributes: [NSAttributedString.Key.foregroundColor : color ?? .placeholderText])
        governmentID.attributedPlaceholder = NSAttributedString(string: governmentPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : color ?? .placeholderText])
    }
    

    @IBAction func Continue(_ sender: Any) {
        let vc = FleetInformationVC(nibName: "FleetInformationVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
