//
//  OrderImagesVC.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 24/07/2024.
//

import UIKit

class OrderImagesVC: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var numOfImages = 4
    var images: [UIImage?] = Array(repeating: nil, count: 4)
    var indexPath: IndexPath?
    let pickerVC = PhotoActionSheet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.twoColorLabel(word: "minimum 4 image", color: UIColor(named: "quaternary") ?? .gray)
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(UINib(nibName: "OrderImageCell", bundle: nil), forCellWithReuseIdentifier: "OrderImageCell")
        heightConstraint.constant = imagesCollectionView.collectionViewLayout.collectionViewContentSize.height
        pickerVC.delegate = self
    }

    @IBAction func addImage(_ sender: Any) {
        numOfImages += 1
        images.append(nil)
        imagesCollectionView.reloadData()
    }
    
    @IBAction func uploadImages(_ sender: Any) {
        
    }
}

extension OrderImagesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numOfImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "OrderImageCell", for: indexPath) as! OrderImageCell
        cell.imageLabel.text = "Photo \(indexPath.item + 1)"
        cell.orderImage.image = images[indexPath.item]
        heightConstraint.constant = imagesCollectionView.collectionViewLayout.collectionViewContentSize.height
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pickerVC.showActionSheet(from: self)
        self.indexPath = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space = 20.0
        let width = (imagesCollectionView.bounds.width - space) / 2.0
        let height = width * 5 / 6
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20.0
    }
}

extension OrderImagesVC: PhotoActionSheetDelegate {
    func didSelectImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5),
              let indexPath = indexPath else {
            return
        }
        images[indexPath.item] = image
        imagesCollectionView.reloadItems(at: [indexPath])
    }
}
