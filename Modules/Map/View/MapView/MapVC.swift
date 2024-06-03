//
//  MapVC.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 17/05/2024.
//

import UIKit
import GoogleMaps
import FittedSheets

class MapVC: UIViewController, CurrentRequestDelegate, OrderStatusSheetDelegate, OrderCompletedSheetDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    var carMarker: GMSMarker?
    var pickupMarker: GMSMarker?
    var dropoffMarker: GMSMarker?
    
    var orderDetails: Order = Order()
    var cost: Double = 0.0
    var currentLocation = CLLocation()
    var status: orderStatus = .arrivedToPickup
    var viewModel: MapViewModel?
    var currentRequestVC: CurrentRequestVC = CurrentRequestVC()
    let orderStatusSheet = OrderStatusSheet()
    let orderCompletedSheet = OrderCompletedSheet()
    
    var sheet: SheetViewController?
    var isOrderCompleted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MapViewModel(api: MapApi())
        self.navigationController?.navigationBar.isHidden = false
        currentRequestVC.delegate = self
        orderStatusSheet.delegate = self
        orderCompletedSheet.delegate = self
        setupMapView()
        showRequest()
        bindData()
    }
    
    func setupMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        carMarker = GMSMarker()
        carMarker?.position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        carMarker?.icon = UIImage(named: "car-icon")
        carMarker?.map = mapView
        
        if let pickupLat = orderDetails.pickupLat, let pickupLng = orderDetails.pickupLng {
            pickupMarker = GMSMarker()
            pickupMarker?.position = CLLocationCoordinate2D(latitude: Double(pickupLat)!, longitude: Double(pickupLng)!)
            pickupMarker?.icon = UIImage(named: "pickup-dropoff-icon")
            pickupMarker?.map = mapView
        }
        
        if let dropoffLat = orderDetails.dropoffLat, let dropoffLng = orderDetails.dropoffLng {
            dropoffMarker = GMSMarker()
            dropoffMarker?.position = CLLocationCoordinate2D(latitude: Double(dropoffLat)!, longitude: Double(dropoffLng)!)
            dropoffMarker?.icon = UIImage(named: "pickup-dropoff-icon")
            dropoffMarker?.map = mapView
        }
        
        viewModel?.drawPath(start: carMarker!.position, end: pickupMarker!.position, mapView: mapView)
    }
    
    func changeCameraPosition(latitude: CLLocationDegrees, longitude: CLLocationDegrees, zoom: Float) {
        let newPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        mapView.animate(to: newPosition)
    }
    
    func bindData(){
        viewModel?.pickupResult.bind { [weak self] result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.currentRequestVC.updateStatusUI(status: self!.status)
                self?.carMarker?.position = self!.pickupMarker!.position
                self?.pickupMarker?.map = nil
                self?.viewModel?.removeCurrentPolyline()
                self?.changeCameraPosition(latitude: (self?.carMarker?.position.latitude)!, longitude: (self?.carMarker?.position.longitude)!, zoom: 12.0)
            }
            print(message)
        }
        
        viewModel?.arrivedResult.bind { [weak self] result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.currentRequestVC.updateStatusUI(status: self!.status)
                self?.viewModel?.drawPath(start: self!.carMarker!.position, end: self!.dropoffMarker!.position, mapView: self!.mapView)
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
                self?.cost = result?.data?.cost ?? 0.0
                self?.currentRequestVC.updateStatusUI(status: self!.status)
                self?.carMarker?.position = self!.dropoffMarker!.position
                self?.viewModel?.removeCurrentPolyline()
                self?.dropoffMarker?.map = nil
                self?.changeCameraPosition(latitude: (self?.carMarker?.position.latitude)!, longitude: (self?.carMarker?.position.longitude)!, zoom: 10.0)
            }
            print(message)
        }
        
        viewModel?.confirmPaymentCashResult.bind { [weak self] result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.orderCompletedSheet.isPaymentConfirmed = true
                self?.orderCompletedSheet.setupUI()
            }
            print(message)
        }
        
        viewModel?.rateOrderResult.bind { [weak self] result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.navigationController?.popViewController(animated: true)
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
        currentRequestVC.customerName.text = orderDetails.customer?.fullName
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
        
    }
    
    func dismissOrder() {
        //sheet?.animateOut()
    }
    
    func dismissSheet() {
        //sheet?.animateOut()
    }
    
    func updateStatus(status: orderStatus) {
        sheet?.animateOut()
        if isOrderCompleted {
            showSheet(controller: orderCompletedSheet, sizes: [.fixed(370)], horizontalPadding: 30)
            orderCompletedSheet.customerName.text = orderDetails.customer?.fullName
            orderCompletedSheet.cost.text = String(cost)
        } else{
            showSheet(controller: orderStatusSheet, sizes: [.fixed(400)])
        }
    }
    
    func updateOrderStatus(status: orderStatus) {
        guard let id = orderDetails.id else { return }
        let orderID = String(id)
        switch status {
        case .arrivedToPickup:
            viewModel?.pickupOrder(orderID: orderID)
        case .goingToDropoff:
            viewModel?.arrivedOrder(orderID: orderID)
        case .arrivedToDropoff:
            viewModel?.startOrder(orderID: orderID)
        case .shipmentCompleted:
            viewModel?.endOrder(orderID: orderID, dropoffLat: String((dropoffMarker?.position.latitude)!), dropoffLng: String((dropoffMarker?.position.longitude)!))
            isOrderCompleted = true
        }
        //currentRequestVC.updateStatusUI(status: status)
        self.status = status
        sheet?.animateOut()
        showRequest()
    }
    
    func submitAmount(amount: String) {
        guard let id = orderDetails.id else { return }
        let orderID = String(id)
        viewModel?.confirmPaymentCash(orderID: orderID, amount: amount)
    }
    
    func submitRating(rate: Int) {
        guard let id = orderDetails.id else { return }
        let orderID = String(id)
        
        print(orderCompletedSheet.rating)
        let rate = String(orderCompletedSheet.rating)
        viewModel?.rateOrder(orderID: orderID, rate: rate)
    }
}
