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

enum orderStatus {
    case arrivedToPickup
    case goingToDropoff
    case arrivedToDropoff
    case shipmentCompleted
}

protocol CurrentRequestDelegate: AnyObject {
    func updateStatus(status: orderStatus)
    func dismissOrder()
}

class CurrentRequestVC: UIViewController {

    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var customerName: UILabel!
    
    weak var delegate: CurrentRequestDelegate?
    
    var currentStatus: TripStatus = .GoingToPickup
    var status: orderStatus = .arrivedToPickup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentStatus = .GoingToPickup
    }

    @IBAction func SeeDetail(_ sender: Any) {
        
    }
    
    @IBAction func UpdateStatus(_ sender: Any) {
        print("sssssssssss")
        delegate?.updateStatus(status: status)
        //delegate?.dismissOrder()
//        switch currentStatus{
//        case .GoingToPickup:
//            currentStatus = .ArrivedToPickup
//            statusTitle.text = "Arrived to pickup"
//            statusBar.backgroundColor = UIColor(named: "seagull")
//        case .ArrivedToPickup:
//            currentStatus = .GoingToDropOff
//            statusTitle.text = "Going to drop off"
//            statusBar.backgroundColor = UIColor(named: "warm")
//        case .GoingToDropOff:
//            currentStatus = .OrderCompleted
//            statusTitle.text = "Order completed"
//            statusBar.backgroundColor = UIColor(named: "forest")
//        case .OrderCompleted:
//            currentStatus = .OrderCompleted
//        }
        
    }
    
    func updateStatusUI(status: orderStatus) {
            switch status {
            case .arrivedToPickup:
                statusTitle.text = "Arrived to pickup"
                statusBar.backgroundColor = UIColor(named: "seagull")
            case .goingToDropoff:
                statusTitle.text = "Going to drop off"
                statusBar.backgroundColor = UIColor(named: "warm")
            case .arrivedToDropoff:
                statusTitle.text = "Arrived to drop off"
                statusBar.backgroundColor = UIColor(named: "forest")
            case .shipmentCompleted:
                statusTitle.text = "Order completed"
                statusBar.backgroundColor = UIColor(named: "forest")
            }
        }

}
