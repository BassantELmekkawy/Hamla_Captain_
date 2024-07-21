//
//  OrderDetailsVC.swift
//  Hamla
//
//  Created by Bassant on 13/03/2024.
//

import UIKit

enum Status{
    case pendingPrice
    case pendingAcceptance
    case orderCompleted
}

protocol OrderDetailsDelegate: AnyObject {
    func showPriceAlert(indexPath: IndexPath)
    func acceptRequest(indexPath: IndexPath)
}

class OrderDetailsVC: UIViewController {

    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet var callButton: [UIButton]!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var pickupLocation: UILabel!
    @IBOutlet weak var dropoffLocation: UILabel!
    @IBOutlet weak var namePhoneLabel: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var pickAmount: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var pickType: UILabel!
    @IBOutlet weak var paymentImage: UIImageView!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var priceRange: UILabel!
    
    var orderDetails = Order()
    weak var delegate: OrderDetailsDelegate?
    var indexPath: IndexPath!
    
    var orderStatus: Status = .pendingPrice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Order_details".localized
        //setupNavigationBar()
        
        switch orderStatus {
        case .pendingPrice:
            statusButton?.backgroundColor = UIColor(named: "quaternary")
            statusButton?.setTitle("Set_price".localized, for: .normal)
        case .pendingAcceptance:
            statusButton?.backgroundColor = UIColor(named: "accent")
            statusButton?.setTitle("Accept".localized, for: .normal)
        case .orderCompleted:
            statusButton?.backgroundColor = UIColor(named: "forest")
            statusButton?.setTitle("Order_confirmed".localized, for: .normal)
            statusButton?.cornerRadius = 10
            statusButton?.isEnabled = false
        }
        
        setupView()
    }
    
    func setupView(){
        customerName.text = orderDetails.customer?.fullName
        phoneNumber.text = orderDetails.customer?.mobile
        pickupLocation.text = orderDetails.pickupLocationName
        dropoffLocation.text = orderDetails.dropoffLocationName
        weight.text = orderDetails.weight
        pickAmount.text = orderDetails.pickAmount
        date.text = orderDetails.date
        pickType.text = orderDetails.pickType
        //paymentImage.image = orderDetails.paymentMethod?.icon
        paymentMethod.text = orderDetails.paymentMethod?.name
        priceRange.text = "\(orderDetails.estimateCostFrom ?? "") \(orderDetails.estimateCostTo ?? "") EGP"
    }
    
    @IBAction func setOrderAction(_ sender: Any) {
        switch orderStatus {
        case .pendingPrice:
            delegate?.showPriceAlert(indexPath: indexPath)
        case .pendingAcceptance:
            delegate?.acceptRequest(indexPath: indexPath)
        case .orderCompleted:
            break
        }
    }
}
