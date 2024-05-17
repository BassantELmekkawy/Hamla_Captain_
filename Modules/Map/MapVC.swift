//
//  MapVC.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 17/05/2024.
//

import UIKit
import GoogleMaps
import FittedSheets

class MapVC: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        showRequest(controller: CurrentRequestVC())
    }
    
    func showRequest(controller : UIViewController) {
        let options = SheetOptions(
            pullBarHeight: 0,
            useFullScreenMode: false,
            shrinkPresentingViewController: false,
            useInlineMode: true,
            horizontalPadding: 30,
            maxWidth: self.view.frame.width
            
        )
        
        let sheet = SheetViewController(controller: controller, sizes: [.fixed(240) , .fixed(30)] , options: options)
        sheet.dismissOnPull = false
        sheet.allowPullingPastMaxHeight = false
        sheet.overlayColor = UIColor.clear
        sheet.dismissOnOverlayTap = false
        sheet.contentBackgroundColor = .clear
        sheet.cornerRadius = 20
        sheet.allowGestureThroughOverlay = true
        sheet.animateIn(to: view, in: self)
        //self.present(sheet, animated: true, completion: nil)
    }
    
}
