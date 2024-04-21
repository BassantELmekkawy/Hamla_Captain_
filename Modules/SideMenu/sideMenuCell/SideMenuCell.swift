//
//  SideMenuCell.swift
//  Hamla
//
//  Created by Bassant on 19/03/2024.
//

import UIKit

class SideMenuCell: UITableViewCell {

    
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var background: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        background.borderColor = UIColor(named: "#F2F2F2")
        background.borderWidth = 1
        background.roundCorners([.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: background.frame.height/2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

struct sideMenuModel{
    var image: String
    var label: String
}
