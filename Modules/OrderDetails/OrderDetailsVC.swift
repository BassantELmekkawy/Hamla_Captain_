//
//  OrderDetailsVC.swift
//  Hamla
//
//  Created by Bassant on 13/03/2024.
//

import UIKit

class OrderDetailsVC: UIViewController {

    @IBOutlet weak var phoneNumber: UILabel!
    
    var number: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Order Details"
        //setupNavigationBar()
        
        //phoneNumber.text = number
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
