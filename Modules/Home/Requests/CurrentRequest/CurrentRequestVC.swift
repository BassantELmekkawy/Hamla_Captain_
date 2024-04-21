//
//  CurrentRequestVC.swift
//  Hamla
//
//  Created by Bassant on 14/03/2024.
//

import UIKit

enum TripStatus{
    case GoingToPickup
    case ArrivedToPickup
    case GoingToDropOff
    case OrderCompleted
}

class CurrentRequestVC: UIViewController {

    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var statusBar: UIView!
    
    var currentStatus: TripStatus = .GoingToPickup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentStatus = .GoingToPickup
    }

    @IBAction func SeeDetail(_ sender: Any) {
        
    }
    
    @IBAction func UpdateStatus(_ sender: Any) {
        switch currentStatus{
        case .GoingToPickup:
            currentStatus = .ArrivedToPickup
            statusTitle.text = "Arrived to pickup"
            statusBar.backgroundColor = UIColor(named: "seagull")
        case .ArrivedToPickup:
            currentStatus = .GoingToDropOff
            statusTitle.text = "Going to drop off"
            statusBar.backgroundColor = UIColor(named: "warm")
        case .GoingToDropOff:
            currentStatus = .OrderCompleted
            statusTitle.text = "Order completed"
            statusBar.backgroundColor = UIColor(named: "forest")
        case .OrderCompleted:
            currentStatus = .OrderCompleted
        }
        
    }

}
