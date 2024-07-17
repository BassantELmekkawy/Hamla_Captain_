//
//  CountryCell.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 14/07/2024.
//

import UIKit

class CountryCell: UITableViewCell {
    
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    
    var countryName = "Egypt" {
        didSet {
            switch countryName {
            case "Egypt":
                flagImage.image = UIImage(named: "Egypt_flag")
                countryLabel.text = "Egypt  (+20)"
            case "Saudi Arabia":
                flagImage.image = UIImage(named: "Saudi_arabia_flag")
                countryLabel.text = "Saudi Arabia  (+966)"
            default:
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
