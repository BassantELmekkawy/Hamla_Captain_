//
//  OrderDetailsVC.swift
//  Hamla
//
//  Created by Bassant on 13/03/2024.
//

import UIKit
import Kingfisher

enum Status{
    case pendingPrice
    case pendingAcceptance
    case orderConfirmed
    case orderCanceled
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
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var pickAmount: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var pickType: UILabel!
    @IBOutlet weak var paymentImage: UIImageView!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceRange: UILabel!
    @IBOutlet weak var imagesBtn: UIView!
    
    var orderDetails = Order()
    weak var delegate: OrderDetailsDelegate?
    var indexPath: IndexPath!
    
    var orderStatus: Status = .pendingPrice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Order_details".localized
        setupNavigationBar()
        
        switch orderStatus {
        case .pendingPrice:
            statusButton?.backgroundColor = UIColor(named: "quaternary")
            statusButton?.setTitle("Set_price".localized, for: .normal)
            imagesBtn.isHidden = true
        case .pendingAcceptance:
            statusButton?.backgroundColor = UIColor(named: "accent")
            statusButton?.setTitle("Accept".localized, for: .normal)
            imagesBtn.isHidden = true
        case .orderConfirmed:
            statusButton?.backgroundColor = UIColor(named: "forest")
            statusButton?.setTitle("      \("Order_confirmed".localized)", for: .normal)
            statusButton.contentHorizontalAlignment = .left
            statusButton?.cornerRadius = 18
            statusButton?.isEnabled = false
            imagesBtn.isHidden = false
        case .orderCanceled:
            statusButton?.backgroundColor = UIColor(named: "forest")
            statusButton?.setTitle("      \("Order_canceled".localized)", for: .normal)
            statusButton.contentHorizontalAlignment = .left
            statusButton?.cornerRadius = 18
            statusButton?.isEnabled = false
            imagesBtn.isHidden = true
        }
        
        customerName.text = orderDetails.customer?.fullName
        phoneNumber.text = "+\(orderDetails.customer?.mobile ?? "0")"
        pickupLocation.text = orderDetails.pickupLocationName
        dropoffLocation.text = orderDetails.dropoffLocationName
        weight.text = "\(orderDetails.weight ?? "0") Kg"
        pickAmount.text = "\(orderDetails.pickAmount ?? "0") Fills"
        date.text = orderDetails.date
        pickType.text = orderDetails.pickType
        paymentImage.kf.setImage(with: URL(string: orderDetails.paymentMethod?.icon ?? ""), placeholder: UIImage(named: "cash"))
        paymentMethod.text = orderDetails.paymentMethod?.name
        if orderStatus == .pendingPrice {
            priceLabel.text = "Price_range".localized
            priceRange.text = "\(orderDetails.estimateCostFrom ?? "0") EGP -  \(orderDetails.estimateCostTo ?? "0") EGP"
        }
        else {
            priceLabel.text = "Total_price".localized
            priceRange.text = "\(orderDetails.cost ?? "0") EGP"
        }
        
        if orderDetails.date == "Now" {
            date.textColor = UIColor(named: "sunrise")
        }
    }
    
    @IBAction func setOrderAction(_ sender: Any) {
        switch orderStatus {
        case .pendingPrice:
            delegate?.showPriceAlert(indexPath: indexPath)
        case .pendingAcceptance:
            delegate?.acceptRequest(indexPath: indexPath)
        default:
            break
        }
    }
    
    @IBAction func seeOrderImages(_ sender: Any) {
        let vc = OrderImagesVC(nibName: "OrderImagesVC", bundle: nil)
        vc.orderId = orderDetails.id ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
}
