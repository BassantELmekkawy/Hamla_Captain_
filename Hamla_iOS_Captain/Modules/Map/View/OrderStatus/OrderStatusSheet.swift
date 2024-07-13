//
//  OrderStatusSheet.swift
//  Hamla
//
//  Created by Bassant on 19/05/2024.
//

import UIKit

//struct OrderStatus {
//    var status: orderStatus
//    var label: String
//}
protocol OrderStatusSheetDelegate: AnyObject {
    func updateOrderStatus(status: OrderStatus)
    func dismissSheet()
}

class OrderStatusSheet: UIViewController {

    @IBOutlet weak var statusTable: UITableView!
    
    weak var delegate: OrderStatusSheetDelegate?
    var status: OrderStatus = .goingToPickup
    var numOfPoints = 0
    var statusList: [OrderStatus] = [.arrivedToPickup,
                                     .startLoad,
                                     .endLoad,
                                     .goingToDropoff,
                                     .arrivedToDropoff,
                                     .startUnload,
                                     .endUnload,
                                     .orderCompleted]

    override func viewDidLoad() {
        super.viewDidLoad()
        statusTable.register(UINib(nibName: "OrderStatusCell", bundle: nil), forCellReuseIdentifier: "OrderStatusCell")
        statusTable.delegate = self
        statusTable.dataSource = self
        
        let pointStatus: [OrderStatus] = [.goingToPoint, .arrivedPoint]
        if numOfPoints > 0 {
            for i in 0..<numOfPoints {
                statusList.insert(contentsOf: pointStatus, at: i * 2 + 3)
            }
        }
    }

    @IBAction func updateStatus(_ sender: Any) {
        delegate?.updateOrderStatus(status: status)
        //delegate?.dismissSheet()
    }
}

extension OrderStatusSheet: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        statusList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderStatusCell", for: indexPath) as! OrderStatusCell
        
        var text = ""
        switch statusList[indexPath.row] {
        case .goingToPickup:
            text = "Going to pickup"
        case .arrivedToPickup:
            text = "Arrived to pickup"
        case .startLoad:
            text = "Start load"
        case .endLoad:
            text = "End load"
        case .goingToPoint:
            text = "Going to point \(indexPath.row / 2)"
        case .arrivedPoint:
            text = "Arrived point \(indexPath.row / 2 - 1)"
        case .goingToDropoff:
            text = "Going to drop off"
        case .arrivedToDropoff:
            text = "Arrived to drop off"
        case .startUnload:
            text = "Start unload"
        case .endUnload:
            text = "End unload"
        case .orderCompleted:
            text = "Shipment completed"
        }
        
        cell.orderStatusLabel.text = text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        status = statusList[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
}
