//
//  OnboardingCollectionViewCell.swift
//  Hamla
//
//  Created by Bassant on 07/03/2024.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var OnboardingImage: UIImageView!
    @IBOutlet weak var slideNum: UILabel!
    @IBOutlet weak var slideDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(slide: OnboardingSlide){
        OnboardingImage.image = slide.image
        slideNum.text = slide.num
        slideDescription.text = slide.description
    }
}

struct OnboardingSlide{
    let image: UIImage
    let num: String
    let description: String
}
