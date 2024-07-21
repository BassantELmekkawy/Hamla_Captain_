//
//  UpcomingRequestsCell.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 31/05/2024.
//

import UIKit

protocol UpcomingRequestsDelegate: AnyObject {
    func seeDetail(indexPath: IndexPath)
    func reject(at indexPath: IndexPath)
    func showPriceAlert(indexPath: IndexPath)
    func acceptRequest(indexPath: IndexPath)
    func navigateToMap()
}

enum UpcomingRequest{
    case pendingPrice
    case updatePrice
    case pendingAcceptance
    case accepted
}

class UpcomingRequestsCell: UITableViewCell {

    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var pickupLocation: UILabel!
    @IBOutlet weak var dropoffLocation: UILabel!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var setPriceBtn: UIButton!
    @IBOutlet weak var navigateToMapBtn: UIButton!
    
    weak var delegate: UpcomingRequestsDelegate?
    var indexPath: IndexPath!
    var requestStatus: UpcomingRequest? {
        didSet {
            switch requestStatus {
            case .pendingPrice:
                setPriceBtn.backgroundColor = UIColor(named: "quaternary")
                navigateToMapBtn.isHidden = true
                rejectBtn.isHidden = false
                setPriceBtn.isHidden = false
            case .updatePrice:
                setPriceBtn.backgroundColor = UIColor(named: "quaternary")
                navigateToMapBtn.isHidden = true
                rejectBtn.isHidden = true
                setPriceBtn.isHidden = false
                setPriceBtn.setTitle("Update price", for: .normal)
            case .pendingAcceptance:
                setPriceBtn.backgroundColor = UIColor(named: "accent")
                setPriceBtn.setTitle("Accept".localized, for: .normal)
                price.textColor = UIColor(named: "primary")
                //price.textColor = UIColor(named: "accent")
                navigateToMapBtn.isHidden = true
                rejectBtn.isHidden = false
                setPriceBtn.isHidden = false
            case .accepted:
                navigateToMapBtn.isHidden = false
                rejectBtn.isHidden = true
                setPriceBtn.isHidden = true
            case .none:
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.cornerRadius = 30
        self.contentView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func SeeDetails(_ sender: Any) {
        delegate?.seeDetail(indexPath: indexPath)
    }
    
    @IBAction func Reject(_ sender: Any) {
        delegate?.reject(at: indexPath)
    }
    
    @IBAction func SetPrice(_ sender: Any) {
        switch requestStatus {
        case .pendingPrice, .updatePrice:
            delegate?.showPriceAlert(indexPath: indexPath)
        case .pendingAcceptance:
            delegate?.acceptRequest(indexPath: indexPath)
        case .accepted:
            break
        case .none:
            break
        }
    }
    
    @IBAction func navigateToMap(_ sender: Any) {
        delegate?.navigateToMap()
    }
    
}
