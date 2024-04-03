//
//  SignInVC.swift
//  Hamla
//
//  Created by Bassant on 28/03/2024.
//

import UIKit

class SignInVC: UIViewController {
    
    @IBOutlet weak var phoneTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func Login(_ sender: Any) {
        let vc = VerificationVC(nibName: "VerificationVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func CreateCaptainAccount(_ sender: Any) {
        
    }
}
