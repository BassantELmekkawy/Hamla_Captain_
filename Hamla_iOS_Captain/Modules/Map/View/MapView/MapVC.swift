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
    var stopPointMarkers: [GMSMarker] = []
    let locationManager = CLLocationManager()
    var stopPoint: Points?
    var point = 0
    
    var orderDetails: Order = Order()
    var cost: Double = 0.0
    var currentLocation = CLLocation()
    var currentStatus: OrderStatus = .goingToPickup
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
        locationManager.delegate = self
        currentRequestVC.delegate = self
        orderStatusSheet.delegate = self
        orderCompletedSheet.delegate = self
        currentRequestVC.orderID = orderDetails.id ?? 0
        setupMapView()
        showRequest()
        bindData()
        
        //carMarker = GMSMarker()
        locationManager.requestWhenInUseAuthorization()
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            //currentLocation = locationManager.location!
            locationManager.startUpdatingLocation()
            print("Lat: ************ \(currentLocation.coordinate.latitude)")
            print("Lng: ************ \(currentLocation.coordinate.longitude)")
        default:
            break
        }
        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.requestLocation()
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//        }
        
        orderStatusSheet.numOfPoints = orderDetails.points?.count ?? 0
        
        if orderDetails.status == "accepted" {
            viewModel?.pickupOrder(orderID: String(orderDetails.id!))
        }
        
        showCurrentStatus()
        
    }
    
    func setupMapView() {
//        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 12.0)
//        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
//        self.view.addSubview(mapView)
//
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
        
        for point in orderDetails.points ?? [] {
            if let pointLat = point.lat, let pointLng = point.lng,
               let lat = Double(pointLat), let lng = Double(pointLng) {
                let stopPoint = GMSMarker()
                stopPoint.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                stopPoint.icon = UIImage(named: "pickup-dropoff-icon")
                stopPoint.map = mapView
                stopPointMarkers.append(stopPoint)
            }
        }
        
        // initialize stopPoint with first point
//        if let point = orderDetails.points?.first {
//            stopPoint = point
//            point = 0
//        }
        
//        carMarker = GMSMarker()
//
//        pickupMarker = GMSMarker()
//        pickupMarker?.position = CLLocationCoordinate2D(latitude: 30.030138, longitude: 31.022553)
//        pickupMarker?.icon = UIImage(named: "pickup-dropoff-icon")
//        pickupMarker?.map = mapView
//
//        dropoffMarker = GMSMarker()
//        dropoffMarker?.position = CLLocationCoordinate2D(latitude: 30.055883, longitude: 31.037779)
//        dropoffMarker?.icon = UIImage(named: "pickup-dropoff-icon")
//        dropoffMarker?.map = mapView
//
//        viewModel?.drawPath(start: carMarker!.position, end: pickupMarker!.position, mapView: mapView)
    }
    
    func changeCameraPosition(latitude: CLLocationDegrees, longitude: CLLocationDegrees, zoom: Float) {
        let newPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        mapView.animate(to: newPosition)
    }
    
    func bindData(){
        viewModel?.pickupResult.bind { [weak self] result in  // going to pickup
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.currentRequestVC.updateStatusUI(status: self!.currentStatus)
                self?.viewModel?.drawPath(start: (self?.carMarker!.position)!, end: (self?.pickupMarker!.position)!, mapView: (self?.mapView)!)
                //self?.carMarker?.position = self!.pickupMarker!.position
                //self?.changeCameraPosition(latitude: (self?.carMarker?.position.latitude)!, longitude: (self?.carMarker?.position.longitude)!, zoom: 12.0)
            }
            print(message)
        }
        
        viewModel?.arrivedResult.bind { [weak self] result in  // arrived to pickup
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.currentRequestVC.updateStatusUI(status: self!.currentStatus)
                self?.pickupMarker?.map = nil
                self?.viewModel?.removeCurrentPolyline()
            }
            print(message)
        }
        
        viewModel?.startLoadResult.bind { [weak self] result in  // start load
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.currentRequestVC.updateStatusUI(status: self!.currentStatus)
            }
            print(message)
        }
        
        viewModel?.endLoadResult.bind { [weak self] result in  // end load
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.currentRequestVC.updateStatusUI(status: self!.currentStatus)
            }
            print(message)
        }
        
        viewModel?.startOrderResult.bind { [weak self] result in  // going to (point/dropoff)
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                if self?.orderDetails.points != nil {
                    self?.currentRequestVC.point = self!.point + 1
                    self?.viewModel?.drawPath(start: (self?.carMarker!.position)!, end: (self?.stopPointMarkers[0].position)!, mapView: (self?.mapView)!)
                } else {
                    self?.viewModel?.drawPath(start: (self?.carMarker!.position)!, end: (self?.dropoffMarker!.position)!, mapView: (self?.mapView)!)
                }
                self?.currentRequestVC.updateStatusUI(status: self!.currentStatus)
            }
            print(message)
        }
        
        viewModel?.arrivedPointResult.bind { [weak self] result in  // arrived point
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                //self?.currentRequestVC.point = self!.point + 1
                self?.currentRequestVC.updateStatusUI(status: self!.currentStatus)
                
                self?.viewModel?.removeCurrentPolyline()
                self?.stopPointMarkers[self!.point].map = nil
            }
            print(message)
        }
        
        viewModel?.movePointResult.bind { [weak self] result in  // going to (point/dropoff)
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.currentRequestVC.point = self!.point + 1
                self?.currentRequestVC.updateStatusUI(status: self!.currentStatus)
                
                if let pointsCount = self?.orderDetails.points?.count, self!.point < pointsCount - 1 {
                    self?.viewModel?.drawPath(start: (self?.carMarker!.position)!, end: (self?.stopPointMarkers[self!.point + 1].position)!, mapView: (self?.mapView)!)
                } else {
                    self?.viewModel?.drawPath(start: (self?.carMarker!.position)!, end: (self?.dropoffMarker!.position)!, mapView: (self?.mapView)!)
                }
            }
            print(message)
        }
        
        viewModel?.dropoffResult.bind { [weak self] result in  // dropoff order
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.currentRequestVC.updateStatusUI(status: self!.currentStatus)
                self?.viewModel?.removeCurrentPolyline()
                self?.dropoffMarker?.map = nil
            }
            print(message)
        }
        
        viewModel?.startUnloadResult.bind { [weak self] result in  // start unload
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.currentRequestVC.updateStatusUI(status: self!.currentStatus)
            }
            print(message)
        }
        
        viewModel?.endUnloadResult.bind { [weak self] result in  // end unload
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.currentRequestVC.updateStatusUI(status: self!.currentStatus)
            }
            print(message)
        }
        
        viewModel?.endOrderResult.bind { [weak self] result in  // order completed
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.cost = result?.data?.cost ?? 0.0
                self?.currentRequestVC.updateStatusUI(status: self!.currentStatus)
                //self?.changeCameraPosition(latitude: (self?.carMarker?.position.latitude)!, longitude: (self?.carMarker?.position.longitude)!, zoom: 10.0)
            }
            print(message)
        }
        
        viewModel?.cancelResult.bind { [weak self] result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                self?.currentRequestVC.updateStatusUI(status: self!.currentStatus)
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
    
    func showCurrentStatus() {
        if orderDetails.status == "start_order" {
            if let points = orderDetails.points {
                for (index, point) in points.enumerated() {
                    if point.move == nil {
                        if point.arrival != nil {
                            currentStatus = .arrivedPoint
                            self.point += 1
                        } else {
                            currentStatus = .goingToPoint
                        }
                        currentRequestVC.point = index + 1
                        
                        break
                    }
                    else if index == points.count - 1 {
                        currentStatus = .goingToDropoff
                    }
                    self.point += 1
                }
            }
            else {
                currentStatus = .goingToDropoff
            }
        }
        else if let orderStatus = OrderStatus(from: orderDetails.status ?? "") {
            currentStatus = orderStatus
        }
        
        currentRequestVC.status = currentStatus
        currentRequestVC.updateStatusUI(status: currentStatus)
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
    
    func chat() {
        let vc = ChatVC()
        vc.orderID = orderDetails.id ?? 0
        vc.receiverID = orderDetails.customer?.id ?? 0
        vc.customerName = orderDetails.customer?.fullName ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateStatus(status: OrderStatus) {
        sheet?.animateOut()
        if isOrderCompleted {
            showSheet(controller: orderCompletedSheet, sizes: [.fixed(370)], horizontalPadding: 30)
            orderCompletedSheet.customerName.text = orderDetails.customer?.fullName
            orderCompletedSheet.cost.text = String(cost)
        } else{
            showSheet(controller: orderStatusSheet, sizes: [.fixed(400)])
        }
    }
    
    func updateOrderStatus(status: OrderStatus) {
        guard let id = orderDetails.id else { return }
        let orderID = String(id)
        switch status {
        case .goingToPickup:
            return
        case .arrivedToPickup:
            viewModel?.arrivedOrder(orderID: orderID)
        case .startLoad:
            viewModel?.startLoad(orderID: orderID)
        case .endLoad:
            viewModel?.endLoad(orderID: orderID)
        case .goingToPoint:  // (start order / move point)
            if point == 0 {
                viewModel?.startOrder(orderID: orderID)
            } else {
                viewModel?.movePoint(orderID: orderID)
            }
        case .arrivedPoint:
            viewModel?.arrivedPoint(orderID: orderID)
            if let pointsCount = orderDetails.points?.count, point < pointsCount - 1 {
                point += 1
            }
        case .goingToDropoff:  // (start order / move point)
            if orderDetails.points != nil {
                viewModel?.movePoint(orderID: orderID)
            } else {
                viewModel?.startOrder(orderID: orderID)
            }
        case .arrivedToDropoff:
            viewModel?.dropoffOrder(orderID: orderID)
        case .startUnload:
            viewModel?.startUnload(orderID: orderID)
        case .endUnload:
            viewModel?.endUnload(orderID: orderID)
        case .orderCompleted:
            let lat = String(locationManager.location?.coordinate.latitude ?? 0.0)
            let lng = String(locationManager.location?.coordinate.longitude ?? 0.0)
            viewModel?.endOrder(orderID: orderID, dropoffLat: lat, dropoffLng: lng)
            isOrderCompleted = true
        }
        //currentRequestVC.updateStatusUI(status: status)
        self.currentStatus = status
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
//30.044895, 31.000131
//30.051379, 30.976656

extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = locationManager.location?.coordinate.latitude ?? 0.0
        let lng = locationManager.location?.coordinate.longitude ?? 0.0
        mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: lat, longitude: lng), zoom: 12.0, bearing: 0, viewingAngle: 0)
        
        carMarker?.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        carMarker?.icon = UIImage(named: "car-icon")
        carMarker?.map = mapView
        
        FirebaseManager.shared.updateLocation(captainId: String(UserInfo.shared.get_ID()), lat: String(lat), lng: String(lng))
        
        switch currentStatus {
        case .goingToPickup:
            viewModel?.drawPath(start: carMarker!.position, end: pickupMarker!.position, mapView: mapView)
        case .goingToPoint:
            viewModel?.drawPath(start: carMarker!.position, end: stopPointMarkers[point].position, mapView: mapView)
        case .goingToDropoff:
            viewModel?.drawPath(start: carMarker!.position, end: dropoffMarker!.position, mapView: mapView)
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error.....\(error)")
    }
}
