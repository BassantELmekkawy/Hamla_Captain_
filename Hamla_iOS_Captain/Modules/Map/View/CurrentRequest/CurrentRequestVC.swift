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

enum OrderStatus: String {
    case goingToPickup = "on_the_way"
    case arrivedToPickup = "arrived"
    case startLoad = "start_load"
    case endLoad = "end_load"
    case goingToPoint
    case arrivedPoint
    case goingToDropoff
    case arrivedToDropoff = "dropoff"
    case startUnload = "start_unload"
    case endUnload = "end_unload"
    case orderCompleted = "pay"

    // Initializer to create an OrderStatus from a string
    init?(from string: String) {
        self.init(rawValue: string)
    }
}

protocol CurrentRequestDelegate: AnyObject {
    func updateStatus(status: OrderStatus)
    func chat()
    func dismissOrder()
}

class CurrentRequestVC: UIViewController {

    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    
    weak var delegate: CurrentRequestDelegate?
    
    var status: OrderStatus = .goingToPickup
    var point = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatButton.setImage(UIImage(named: "Chat_enabled"), for: .normal)
    }

    @IBAction func chat(_ sender: Any) {
        delegate?.chat()
    }
    
    @IBAction func SeeDetail(_ sender: Any) {
        
    }
    
    @IBAction func UpdateStatus(_ sender: Any) {
        delegate?.updateStatus(status: status)
    }
    
    func updateStatusUI(status: OrderStatus) {
            switch status {
            case .goingToPickup:
                return
            case .arrivedToPickup:
                statusTitle.text = "Arrived to pickup"
                statusBar.backgroundColor = UIColor(named: "seagull")
            case .startLoad:
                statusTitle.text = "Start load"
                statusBar.backgroundColor = UIColor(named: "primary")
            case .endLoad:
                statusTitle.text = "End load"
                statusBar.backgroundColor = UIColor(named: "primary")
            case .goingToPoint:
                statusTitle.text = "Going to point \(point)"
                statusBar.backgroundColor = UIColor(named: "primary")
            case .arrivedPoint:
                statusTitle.text = "Arrived point \(point)"
                statusBar.backgroundColor = UIColor(named: "primary")
            case .goingToDropoff:
                statusTitle.text = "Going to drop off"
                statusBar.backgroundColor = UIColor(named: "warm")
            case .arrivedToDropoff:
                statusTitle.text = "Arrived to drop off"
                statusBar.backgroundColor = UIColor(named: "forest")
            case .startUnload:
                statusTitle.text = "Start unload"
                statusBar.backgroundColor = UIColor(named: "primary")
            case .endUnload:
                statusTitle.text = "End unload"
                statusBar.backgroundColor = UIColor(named: "primary")
            case .orderCompleted:
                statusTitle.text = "Order completed"
                statusBar.backgroundColor = UIColor(named: "forest")
            }
        }

}
