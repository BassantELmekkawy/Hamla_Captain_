//
//  MapVC.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 17/05/2024.
//

import UIKit
import GoogleMaps
import FittedSheets

class MapVC: UIViewController, CurrentRequestDelegate, OrderStatusSheetDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    var orderID: String = ""
    var status: orderStatus = .arrivedToPickup
    var viewModel: MapViewModel?
    var currentRequestVC: CurrentRequestVC = CurrentRequestVC()
    let orderStatusSheet = OrderStatusSheet()
    
    var sheet: SheetViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MapViewModel(api: MapApi())
        self.navigationController?.navigationBar.isHidden = false
        currentRequestVC.delegate = self
        orderStatusSheet.delegate = self
        showRequest()
        bindData()
    }
    
    func bindData(){
        viewModel?.pickupResult.bind { [weak self] result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.currentRequestVC.updateStatusUI(status: self!.status)
            }
            print(message)
        }
        
        viewModel?.arrivedResult.bind { [weak self] result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.currentRequestVC.updateStatusUI(status: self!.status)
            }
            print(message)
        }
        
        viewModel?.startResult.bind { [weak self] result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.currentRequestVC.updateStatusUI(status: self!.status)
            }
            print(message)
        }
        
        viewModel?.cancelResult.bind { [weak self] result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.currentRequestVC.updateStatusUI(status: self!.status)
            }
            print(message)
        }
        
        viewModel?.endResult.bind { [weak self] result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.currentRequestVC.updateStatusUI(status: self!.status)
            }
            print(message)
        }
        
        viewModel?.errorMessage.bind{ error in
            if let error = error {
                self.showAlert(message: error)
                print(error)
            }
        }
        
    }
    
    func showRequest() {
        showSheet(controller: currentRequestVC, sizes: [.fixed(240) , .fixed(30)], horizontalPadding: 30)
    }
    
    func showSheet(controller : UIViewController, sizes:[SheetSize], horizontalPadding: CGFloat = 0) {
        let options = SheetOptions(
            pullBarHeight: 0,
            useFullScreenMode: false,
            shrinkPresentingViewController: false,
            useInlineMode: true,
            horizontalPadding: horizontalPadding,
            maxWidth: self.view.frame.width
            
        )
        
        sheet = SheetViewController(controller: controller, sizes: sizes , options: options)
        sheet?.dismissOnPull = false
        sheet?.allowPullingPastMaxHeight = false
        sheet?.overlayColor = UIColor.clear
        sheet?.dismissOnOverlayTap = false
        sheet?.contentBackgroundColor = .clear
        sheet?.cornerRadius = 20
        sheet?.allowGestureThroughOverlay = true
        sheet?.animateIn(to: view, in: self)
        sheet?.didDismiss = { _ in
            print("xxxxxxxxxxxxxxx")
        }
        
    }
    
    func dismissOrder() {
        //sheet?.animateOut()
    }
    
    func dismissSheet() {
        //sheet?.animateOut()
    }
    
    func updateStatus(status: orderStatus) {
        print("dismissssssssssssss")
        sheet?.animateOut()
        
        showSheet(controller: orderStatusSheet, sizes: [.fixed(400)])
    }
    
    func updateOrderStatus(status: orderStatus) {
        switch status {
        case .arrivedToPickup:
            viewModel?.pickupOrder(orderID: orderID)
        case .goingToDropoff:
            viewModel?.arrivedOrder(orderID: orderID)
        case .arrivedToDropoff:
            viewModel?.startOrder(orderID: orderID)
        case .shipmentCompleted:
            viewModel?.endOrder(orderID: orderID)
        }
        //currentRequestVC.updateStatusUI(status: status)
        self.status = status
        sheet?.animateOut()
        showRequest()
    }
    
}
