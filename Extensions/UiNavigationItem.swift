//
//  UiNavigationItem.swift
//  Hamla
//
//  Created by Bassant on 08/03/2024.
//

import UIKit
import Foundation

//extension UINavigationItem{
//
//    override open func awakeFromNib() {
//        super.awakeFromNib()
//
//        let backItem = UIBarButtonItem()
//        backItem.title = "Hello"
//        backItem.image = UIImage(named: "Back")
//
////        if let font = UIFont(name: "Copperplate-Light", size: 32){
////            backItem.setTitleTextAttributes([NSAttributedString.Key.font:font], for: .normal)
////        }else{
////
////            print("Font Not available")
////        }
//        /*Changing color*/
////        backItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.green], for: .normal)
//
//        self.backBarButtonItem = backItem
//    }
//
//}

extension UIViewController{
    func setupNavigationBar(){
        //navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackButton")
        //navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackButton")
        //navigationController?.navigationBar.backgroundColor = .red
        
        //let backButton = UIBarButtonItem()
        //backButton.image = UIImage(systemName: "heart.fill")
//        backButton.title = "xxx"
        ////self.navigationController?.navigationBar.topItem?.title = " "
        //navigationController?.navigationItem.setLeftBarButton(backButton, animated: false)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
}
