//
//  UpcomingRequestsCell.swift
//  Hamla
//
//  Created by Bassant on 11/03/2024.
//

import UIKit

protocol CustomAlertDelegate: AnyObject {
    func seeDetail(indexPath: IndexPath)
    func reject(at indexPath: IndexPath)
    func showPriceAlert()
    func acceptRequest(indexPath: IndexPath)
}

enum UpcomingRequest{
    case pendingPrice
    case pendingAcceptance
}

class UpcomingRequestsCell: UICollectionViewCell {

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var setPriceBtn: UIButton!
    @IBOutlet weak var pickupLocation: UILabel!
    @IBOutlet weak var dropoffLocation: UILabel!
    
    weak var delegate: CustomAlertDelegate?
    var indexPath: IndexPath!
    var requestStatus: UpcomingRequest = .pendingPrice {
        didSet {
            switch requestStatus {
            case .pendingPrice:
                setPriceBtn.backgroundColor = UIColor(named: "quaternary")
            case .pendingAcceptance:
                setPriceBtn.backgroundColor = UIColor(named: "accent")
                setPriceBtn.setTitle("Accept", for: .normal)
                price.text = "105 EGP"
                price.textColor = UIColor(named: "accent")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func SeeDetail(_ sender: Any) {
        delegate?.seeDetail(indexPath: indexPath)
    }
    
    @IBAction func Reject(_ sender: Any) {
        delegate?.reject(at: indexPath)
    }
    @IBAction func SetPrice(_ sender: Any) {
        switch requestStatus {
        case .pendingPrice:
            delegate?.showPriceAlert()
        case .pendingAcceptance:
            delegate?.acceptRequest(indexPath: indexPath)
        }
    }
    
}
