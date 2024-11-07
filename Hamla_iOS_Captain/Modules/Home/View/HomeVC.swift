//
//  HomeVC.swift
//  Hamla
//
//  Created by Bassant on 10/03/2024.
//

import UIKit
import FittedSheets
import CoreLocation

class HomeVC: UIViewController {

    @IBOutlet weak var captainName: UILabel!
    @IBOutlet weak var plateNumber: UILabel!
    @IBOutlet weak var truckColorAndType: UILabel!
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var captainStatus: UILabel!
    @IBOutlet weak var availabilitySwitch: UISwitch!
    @IBOutlet weak var availabilityInfo: UILabel!
    @IBOutlet weak var tableHeader: UILabel!
    
    var sideMenuViewController = SideMenuVC()
    var sideMenuWidth: CGFloat = 260
    var overlay = UIView()
    var captainDetails: CaptainData?
    var ordersDetails: [Order]? = []
    var currentOrderDetails: Order?
    var ordersStatus: [Int: UpcomingRequest] = [:]
    var ordersWithPrice: [Int: String] = [:]
    //var ordersIDs: [Int] = []
    var selectedOrderDetails: Order?
    var selectedOrderID: Int?
    var isCaptainOnline = false
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    let lang = Locale.current.language.languageCode
    
    var viewModel: HomeViewModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        self.viewModel = HomeViewModel(api: HomeApi())
        //setupSideMenu()
        bindData()
        viewModel?.getCaptainDetails()
        
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.register(UINib(nibName: "UpcomingRequestsCell", bundle: nil), forCellReuseIdentifier: "UpcomingRequestsCell")
        
        let user = UserInfo.shared
        captainName.text = user.get_username()
        plateNumber.text = user.getPlateNumber()
        truckColorAndType.text = "\(user.getTruckColor()) - \(user.getTruckType())"
        
        viewModel?.getCaptainStatus(captainID: String(UserInfo.shared.get_ID()))
        
        locationManager.delegate = self
        getCurrentLocation()
        viewModel?.observeCurrentOrder(captainId: String(UserInfo.shared.get_ID()))
        //self.viewModel?.observeOrders(captainId: String(UserInfo.shared.get_ID()))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        viewModel?.isCaptainOnOrder()
        ordersTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //viewModel?.removeOrdersObserver()
    }
    
    func getCurrentLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setupSideMenu() {
        addOverlay(view: self.view)
        overlay.isHidden = true
        sideMenuViewController = SideMenuVC(nibName: "SideMenuVC", bundle: nil)
        addChild(sideMenuViewController)
        
        switch lang {
        case "ar":
            sideMenuViewController.view.frame = CGRect(x: view.frame.width, y: 0, width: sideMenuWidth, height: view.frame.height)
        case "en":
            sideMenuViewController.view.frame = CGRect(x: -sideMenuWidth, y: 0, width: sideMenuWidth, height: view.frame.height)
        default:
            sideMenuViewController.view.frame = CGRect(x: -sideMenuWidth, y: 0, width: sideMenuWidth, height: view.frame.height)
        }
        
        view.addSubview(sideMenuViewController.view)
        //sideMenuViewController.didMove(toParent: self)
        
        // Add tap gesture to close side menu
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func updateStatus(status: Bool) {
        switch status {
        case true:
            captainStatus.text = "Online".localized
            availabilitySwitch.isOn = true
            availabilityInfo.text = "You_can_receive_requests_normally".localized
        case false:
            captainStatus.text = "Offline".localized
            availabilitySwitch.isOn = false
            availabilityInfo.text = "You_cannot_receive_any_requests_now".localized
        }
        isCaptainOnline = status
    }
    
    func bindData(){
        viewModel?.captainDetailsResult.bind { result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                //self.showAlert(message: message)
                UserInfo.shared.setRootViewController(SignInVC())
            }
            else {
                self.captainDetails = result?.data
                self.sideMenuViewController.captainDetails = self.captainDetails ?? CaptainData()
                UserInfo.shared.setData(model: (result?.data)!)
            }
            print(message)
        }
        
        viewModel?.currentOrder.bind { currentOrder in
            guard let currentOrder = currentOrder else {
                return
            }
            if currentOrder == 0 {
                UserInfo.shared.setCaptainOnOrder(status: false)
                DispatchQueue.main.async {
                    self.ordersTableView.reloadData()
                }
            } else {
                UserInfo.shared.setCaptainOnOrder(status: true)
                self.viewModel?.isCaptainOnOrder()
            }
        }
        
        viewModel?.captainOnOrderResult.bind { result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self.viewModel?.observeOrders(captainId: String(UserInfo.shared.get_ID()))
                UserInfo.shared.setCaptainOnOrder(status: false)
                //self.ordersIDs = []
                DispatchQueue.main.async {
                    self.ordersTableView.reloadData()
                }
            }
            else {
                UserInfo.shared.setCaptainOnOrder(status: true)
                if let currentOrder = result?.data {
                    //self.ordersIDs = [orderID]
                    self.currentOrderDetails = currentOrder
                }
            }
            DispatchQueue.main.async {
                self.ordersTableView.reloadData()
            }
            print(message)
        }
        
        viewModel?.orderDetailsResult.bind { result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self.showAlert(message: message)
            }
            else {
                if let orders = result?.data {
//                    if UserInfo.shared.isCaptainOnOrder() {
//                        self.currentOrderDetails = orders.first
//                    } else {
//                        self.ordersDetails = orders
//                    }
                    self.ordersDetails = orders
                    DispatchQueue.main.async {
                        self.ordersTableView.reloadData()
                    }
                }
            }
            print(message)
        }
        
        viewModel?.ordersWithPrice.bind { ordersWithPrice in
            for (orderID, price) in ordersWithPrice {
                print("OrderID: \(orderID)")
                print("Price: \(price)")
                self.ordersWithPrice = ordersWithPrice
                self.ordersStatus[orderID] = .updatePrice
                DispatchQueue.main.async {
                    self.ordersTableView.reloadData()
                }
            }
        }

        viewModel?.updateAvailabilityResult.bind { result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self.showAlert(message: message)
                self.availabilitySwitch.isOn.toggle()
            }
            else {
                self.updateStatus(status: (result?.available)!)
                //self.viewModel?.observeOrders(captainId: String(UserInfo.shared.get_ID()))
                //self.ordersIDs = []
                DispatchQueue.main.async {
                    self.ordersTableView.reloadData()
                }
            }
            print(message)
        }
        
        viewModel?.acceptResult.bind { result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self.showAlert(message: message)
                //print("Order ID:....... \(self.ordersIDs)")
            }
            else {
                UserInfo.shared.setCaptainOnOrder(status: true)
                //self.ordersIDs = []
                let mapVC = MapVC(nibName: "MapVC", bundle: nil)
                //let orderID = String(self.selectedOrderID!)
                //self.viewModel?.getOrdersDetails(orderIDs: [orderID])
                mapVC.orderDetails = self.selectedOrderDetails!
                //mapVC.orderID = self.selectedOrderID!
                mapVC.currentLocation = self.currentLocation
                self.navigationController?.pushViewController(mapVC, animated: true)
                //print("Order ID:....... \(self.ordersIDs)")
            }
            print(message)
        }
        
        viewModel?.rejectResult.bind { [weak self] result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self?.showAlert(message: message)
            } else {
                
            }
            print(message)
        }
        
        viewModel?.orderPriceResult.bind { [weak self] result in
            guard let message = result?.0?.message else { return }
            if result?.0?.status == 0 {
                self?.showAlert(message: message)
            } else {
                //self?.ordersTableView.reloadData()
                if let orderID = result?.1 {
                    //let cell = self?.ordersTableView.cellForRow(at: indexPath) as! UpcomingRequestsCell
                    //cell.requestStatus = .updatePrice
                    //self?.ordersTableView.reloadRows(at: [indexPath], with: .none)
                    self?.ordersStatus[orderID] = .updatePrice
                    self?.ordersTableView.reloadData()
                }
            }
            print(message)
        }
        
        viewModel?.assignOrder.bind { assignOrder in
            guard let orders = assignOrder, orders.count != 0 else {
                //self.ordersIDs = []
                self.ordersDetails = []
                DispatchQueue.main.async {
                    self.ordersTableView.reloadData()
                }
                return
            }
            //self.ordersIDs = orders
            let orderIDsStrings = orders.map { String($0) }
            
            print("orders: \(orders)")
            print("orderIDsStrings: \(orderIDsStrings)")
            
            self.viewModel?.getOrdersDetails(orderIDs: orderIDsStrings)
            self.viewModel?.getCaptainPriceForOrders(orderIDs: orders)
            
            //print("orders:  \(self.ordersIDs)")
        }
        
        viewModel?.captainStatus.bind{ isOnline in
            guard let isOnline = isOnline else {
                return
            }
            print("Captain: \(isOnline)")
            
            self.updateStatus(status: isOnline)
        }
        
        viewModel?.errorMessage.bind{ error in
            if let error = error {
                self.showAlert(message: error)
                print(error)
            }
        }
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        if !sideMenuViewController.view.frame.contains(location) {
            hideSideMenu()
        }
    }
    
    func showSideMenu() {
        //self.addOverlay(view: self.view)
        overlay.isHidden = false
        UIView.animate(withDuration: 0.3) {
            switch self.lang {
            case "ar":
                let moveLeft = CGAffineTransform(translationX: -self.sideMenuWidth, y: 0.0)
                self.sideMenuViewController.view.transform = moveLeft
            case "en":
                self.sideMenuViewController.view.frame.origin.x = 0
            default:
                self.sideMenuViewController.view.frame.origin.x = 0
            }
        }
    }
    
    func hideSideMenu() {
        UIView.animate(withDuration: 0.3) {
            switch self.lang {
            case "ar":
                let moveRight = CGAffineTransform(translationX: self.sideMenuWidth, y: 0.0)
                self.sideMenuViewController.view.transform = moveRight
            case "en":
                self.sideMenuViewController.view.frame.origin.x = -self.sideMenuWidth
            default:
                self.sideMenuViewController.view.frame.origin.x = -self.sideMenuWidth
            }
            
            //self.overlay.removeFromSuperview()
            self.overlay.isHidden = true
        }
    }
    
    func addOverlay(view: UIView) {
        overlay = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        overlay.backgroundColor = .black
        overlay.layer.opacity = 0.8
        view.addSubview(overlay)
    }
    
    @IBAction func ShowSideMenu(_ sender: Any) {
        setupSideMenu()
        showSideMenu()
    }
    
    @IBAction func UpdateAvailability(_ sender: UISwitch) {
        viewModel?.updateAvailability(lat: String(currentLocation.coordinate.latitude), lng: String(currentLocation.coordinate.longitude))
    }
    
}

extension HomeVC: UpcomingRequestsDelegate, OrderDetailsDelegate, SetPriceDelegate {
    
    func navigateToMap() {
        let mapVC = MapVC(nibName: "MapVC", bundle: nil)
        mapVC.orderDetails = self.currentOrderDetails!
        mapVC.currentLocation = self.currentLocation
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func showPriceAlert(indexPath: IndexPath) {
        let alertViewController = SetPriceAlertView(nibName: "SetPriceAlertView", bundle: nil)
        alertViewController.delegate = self
        selectedOrderID = ordersDetails?[indexPath.row].id
        alertViewController.modalPresentationStyle = .overCurrentContext
        alertViewController.modalTransitionStyle = .crossDissolve
        alertViewController.minPrice = ordersDetails?[indexPath.row].estimateCostFrom ?? ""
        alertViewController.maxPrice = ordersDetails?[indexPath.row].estimateCostTo ?? ""
        alertViewController.avgPrice = ordersDetails?[indexPath.row].prices?.avg ?? ""
        if let orderID = selectedOrderID, let price = ordersWithPrice[orderID] {
            print(price)
            alertViewController.selectedPrice = price
        }
        present(alertViewController, animated: true, completion: nil)
    }
    
    func sendPrice(price: String) {
        if let selectedOrderID = selectedOrderID {
            viewModel?.setOrderPrice(orderID: String(selectedOrderID), price: price)
            ordersWithPrice[selectedOrderID] = price
        }
    }
    
    func acceptRequest(indexPath: IndexPath) {
        selectedOrderDetails = ordersDetails?[indexPath.row]
        selectedOrderID = ordersDetails?[indexPath.row].id
        //print("Order id = \(ordersIDs[indexPath.row]) is accepted")
        viewModel?.acceptOrder(orderID: String(self.selectedOrderID!), captainLat: String(currentLocation.coordinate.latitude), captainLng: String(currentLocation.coordinate.longitude))
    }
    
    func seeDetail(indexPath: IndexPath) {
        let vc = OrderDetailsVC(nibName: "OrderDetailsVC", bundle: nil)
        if UserInfo.shared.isCaptainOnOrder() {
            vc.orderDetails = self.currentOrderDetails!
            vc.orderStatus = .orderConfirmed
        } else {
            vc.orderDetails = self.ordersDetails![indexPath.row]
            vc.orderStatus = .pendingPrice
        }
        vc.delegate = self
        vc.indexPath = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func reject(at indexPath: IndexPath) {
//        print("Deleted IndexPath = \(indexPath.row)")
//        self.ordersIDs.remove(at: indexPath.row)
//        //self.CollectionView.deleteItems(at: [indexPath])
//        self.CollectionView.reloadData()
//        print(self.CollectionView.numberOfItems(inSection: 0))
        viewModel?.rejectOrder(orderID: String(self.ordersDetails![indexPath.row].id!))
        ordersStatus.removeValue(forKey: (ordersDetails?[indexPath.row].id)!)
        //ordersIDs.remove(at: indexPath.row)
        ordersDetails?.remove(at: indexPath.row)
        ordersTableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserInfo.shared.isCaptainOnOrder() {
            return 1
        } else {
            return ordersDetails?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: "UpcomingRequestsCell", for: indexPath) as! UpcomingRequestsCell
        cell.indexPath = indexPath
        
        let isCurrent = UserInfo.shared.isCaptainOnOrder()
        let order = isCurrent ? currentOrderDetails : ordersDetails?[indexPath.row]
        
        if UserInfo.shared.isCaptainOnOrder() {
            tableHeader.text = "Current_requests".localized
            cell.requestStatus = .accepted
        }
        else {
            tableHeader.text = "Upcoming_requests".localized
            if let orderID = order?.id, let status = ordersStatus[orderID] {
                cell.requestStatus = status
            } else {
                cell.requestStatus = .pendingPrice
            }
        }
        cell.orderID.text = "#\(order?.id ?? 0) "
        cell.price.text = "\(order?.estimateCostFrom ?? "0")-\(order?.estimateCostTo ?? "0") EGP"
        cell.paymentMethod.text = order?.paymentMethod?.name
        cell.pickupLocation.text = order?.pickupLocationName
        cell.dropoffLocation.text = order?.dropoffLocationName
        cell.delegate = self
        return cell
    }
}

extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = locationManager.location {
                currentLocation = location
                locationManager.startUpdatingLocation()
                print("Lat: ************ \(currentLocation.coordinate.latitude)")
                print("Lng: ************ \(currentLocation.coordinate.longitude)")
            }
        case .denied, .restricted:
            print("Location access denied/restricted.")
        case .notDetermined:
            print("Location access not determined.")
        default:
            print("Unknown authorization status.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        currentLocation = location
        if isCaptainOnline {
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            FirebaseManager.shared.updateLocation(captainId: String(UserInfo.shared.get_ID()), lat: String(lat), lng: String(lng))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error.....\(error)")
    }
}
