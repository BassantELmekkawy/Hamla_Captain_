//
//  MyProfileVC.swift
//  Hamla
//
//  Created by Bassant on 17/03/2024.
//

import UIKit

class MyProfileVC: UIViewController {

    @IBOutlet weak var photoBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.title = "My profile"
        photoBackgroundView.twoColorDiagonalView(color1: UIColor(named: "primary") ?? .blue, color2: UIColor(named: "LightBlue") ?? .blue, cornerRadius: 8)
    }
    

    
}
