//
//  OrderHistoryCell.swift
//  Hamla
//
//  Created by Bassant on 20/03/2024.
//

import UIKit

class OrderHistoryCell: UITableViewCell {

    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var orderStateBtn: UIButton!
    @IBOutlet weak var pickupLocation: UILabel!
    @IBOutlet weak var dropoffLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
