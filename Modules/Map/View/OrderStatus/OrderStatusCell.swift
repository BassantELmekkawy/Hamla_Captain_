//
//  OrderStatusCell.swift
//  Hamla
//
//  Created by Bassant on 19/05/2024.
//

import UIKit

protocol orderStatusDelegate: AnyObject {
    func selectOrderStatus(status: orderStatus)
}

class OrderStatusCell: UITableViewCell {

    @IBOutlet weak var cellBackgrounView: UIView!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    var orderStatus: orderStatus!
    weak var delegate: orderStatusDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            cellBackgrounView.layer.borderColor = UIColor(named: "primary")?.cgColor
            selectButton.setImage(UIImage(named: "radio.fill"), for: .normal)
        } else {
            selectButton.setImage(UIImage(named: "radio.empty"), for: .normal)
        }
    }
    
    @IBAction func selectOrderStatus(_ sender: Any) {
        //delegate?.selectOrderStatus(status: orderStatus)
    }
}
