//
//  PhotoViewerVC.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 26/06/2024.
//

import UIKit
import Kingfisher

class PhotoViewerVC: UIViewController {
    
    private let url: URL
    
    init(with url: URL) {
        self.url = url
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
        imageView.kf.setImage(with: url)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }

}
