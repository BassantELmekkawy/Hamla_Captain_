//
//  OrderStatusSheet.swift
//  Hamla
//
//  Created by Bassant on 19/05/2024.
//

import UIKit

protocol OrderStatusSheetDelegate: AnyObject {
    func updateOrderStatus(status: orderStatus)
    func dismissSheet()
}

class OrderStatusSheet: UIViewController {

    @IBOutlet weak var statusTable: UITableView!
    
    weak var delegate: OrderStatusSheetDelegate?
    var status: orderStatus = .arrivedToPickup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusTable.register(UINib(nibName: "OrderStatusCell", bundle: nil), forCellReuseIdentifier: "OrderStatusCell")
        statusTable.delegate = self
        statusTable.dataSource = self
    }

    @IBAction func updateStatus(_ sender: Any) {
        delegate?.updateOrderStatus(status: status)
        //delegate?.dismissSheet()
    }
}

extension OrderStatusSheet: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderStatusCell", for: indexPath) as! OrderStatusCell
        switch indexPath.row {
        case 0:
            cell.orderStatusLabel.text = "Arrived to pickup"
        case 1:
            cell.orderStatusLabel.text = "Going to drop off"
        case 2:
            cell.orderStatusLabel.text = "Arrived to drop off"
        case 3:
            cell.orderStatusLabel.text = "shipment completed"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            status = .arrivedToPickup
        case 1:
            status = .goingToDropoff
        case 2:
            status = .arrivedToDropoff
        case 3:
            status = .shipmentCompleted
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
}
