//
//  FleetInformationVC.swift
//  Hamla
//
//  Created by Bassant on 10/03/2024.
//

import UIKit

class FleetInformationVC: UIViewController {

    @IBOutlet weak var plateNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Create account"
        setupNavigationBar()
        
        let color = UIColor(named: "primary-dark")?.withAlphaComponent(0.5)
        let placeholder = plateNumber.placeholder ?? ""
        plateNumber.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color ?? .placeholderText])
    }


    @IBAction func Continue(_ sender: Any) {
        let vc = STC_Pay_InformationVC(nibName: "STC_Pay_InformationVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
