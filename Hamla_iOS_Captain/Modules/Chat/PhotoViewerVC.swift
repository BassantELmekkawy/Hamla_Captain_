//
//  PhotoViewerVC.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 26/06/2024.
//

import UIKit
import Kingfisher

class PhotoViewerVC: UIViewController {
    
    private let photo: UIImage?
    
    init(photo: UIImage) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = .black
        view.addSubview(imageView)
        imageView.image = photo
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = .black
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }

}
