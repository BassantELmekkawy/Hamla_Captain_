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
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var captainStatus: UILabel!
    @IBOutlet weak var availabilitySwitch: UISwitch!
    @IBOutlet weak var availabilityInfo: UILabel!
    
    var sideMenuViewController: SideMenuVC!
    var sideMenuWidth: CGFloat = 260
    var overlay = UIView()
    var ordersDetails: [Order]? = []
    var ordersIDs: [Int] = []
    var selectedOrderDetails: Order?
    var selectedOrderID: Int?
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    var viewModel: HomeViewModel?
    
    //var upcomingRequests:[UpcomingRequest] = [.pendingAcceptance, .pendingPrice]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        self.viewModel = HomeViewModel(api: HomeApi())
        bindData()
        viewModel?.getCaptainDetails()
        
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.register(UINib(nibName: "UpcomingRequestsCell", bundle: nil), forCellReuseIdentifier: "UpcomingRequestsCell")
        setupSideMenu()
        
        captainName.text = UserInfo.shared.get_username()
        
        let status = UserInfo.shared.getCaptainStatus()
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
        
        getCurrentLocation()
        
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
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            currentLocation = locationManager.location!
            print("Lat: ************ \(currentLocation.coordinate.latitude)")
            print("Lng: ************ \(currentLocation.coordinate.longitude)")
        default:
            break
        }
    }
    
    func setupSideMenu() {
        addOverlay(view: self.view)
        overlay.isHidden = true
        sideMenuViewController = SideMenuVC(nibName: "SideMenuVC", bundle: nil)
        addChild(sideMenuViewController)
        sideMenuViewController.view.frame = CGRect(x: -sideMenuWidth, y: 0, width: sideMenuWidth, height: view.frame.height)
        view.addSubview(sideMenuViewController.view)
        sideMenuViewController.didMove(toParent: self)
        
        // Add tap gesture to close side menu
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func updateStatus(status: Bool) {
        switch status {
        case true:
            captainStatus.text = "Online".localized
            UserInfo.shared.setCaptainStatus(status: true)
        case false:
            captainStatus.text = "Offline".localized
            UserInfo.shared.setCaptainStatus(status: false)
        }
    }
    
    func bindData(){
        viewModel?.captainDetailsResult.bind { result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                //self.showAlert(message: message)
                UserInfo.shared.setRootViewController(SignInVC())
            }
            else {
                UserInfo.shared.setData(model: (result?.data)!)
            }
            print(message)
        }
        
        viewModel?.captainOnOrderResult.bind { result in
            guard let message = result?.message else { return }
            if result?.status == 0 {
                self.viewModel?.observeOrders(captainId: String(UserInfo.shared.get_ID()))
                UserInfo.shared.setCaptainOnOrder(status: false)
                self.ordersIDs = []
            }
            else {
                UserInfo.shared.setCaptainOnOrder(status: true)
                if let currentOrder = result?.data, let orderID = currentOrder.id {
                    self.ordersIDs = [orderID]
                    self.ordersDetails = [currentOrder]
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
                self.ordersDetails = result?.data
                DispatchQueue.main.async {
                    self.ordersTableView.reloadData()
                }
            }
            print(message)
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
                self.ordersIDs = []
                let mapVC = MapVC(nibName: "MapVC", bundle: nil)
                //let orderID = String(self.selectedOrderID!)
                //self.viewModel?.getOrdersDetails(orderIDs: [orderID])
                mapVC.orderDetails = self.selectedOrderDetails!
                //mapVC.orderID = self.selectedOrderID!
                mapVC.currentLocation = self.currentLocation
                self.navigationController?.pushViewController(mapVC, animated: true)
                print("Order ID:....... \(self.ordersIDs)")
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
        
        viewModel?.assignOrder.bind { assignOrder in
            guard let orders = assignOrder, orders.count != 0 else {
                self.ordersIDs = []
                return
            }
            self.ordersIDs = orders
            let orderIDsStrings = orders.map { String($0) }
            
            // Debugging statements
            print("orders: \(orders)")
            print("orderIDsStrings: \(orderIDsStrings)")
            
            self.viewModel?.getOrdersDetails(orderIDs: orderIDsStrings)
            
            
            print("orderrrrrrrss:  \(self.ordersIDs)")
        }
        
        viewModel?.errorMessage.bind{ error in
            if let error = error {
                self.showAlert(message: error)
                print(error)
            }
        }
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: sideMenuViewController.view)
        if !sideMenuViewController.view.frame.contains(location) {
            hideSideMenu()
        }
    }
    
    func showSideMenu() {
        //self.addOverlay(view: self.view)
        overlay.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.sideMenuViewController.view.frame.origin.x = 0
        }
    }
    
    func hideSideMenu() {
        UIView.animate(withDuration: 0.3) {
            self.sideMenuViewController.view.frame.origin.x = -self.sideMenuWidth
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
        showSideMenu()
    }
    
    @IBAction func UpdateAvailability(_ sender: UISwitch) {
        viewModel?.updateAvailability(lat: String(currentLocation.coordinate.latitude), lng: String(currentLocation.coordinate.longitude))
    }
    
}

extension HomeVC: UpcomingRequestsDelegate, OrderDetailsDelegate {
    func navigateToMap() {
        let mapVC = MapVC(nibName: "MapVC", bundle: nil)
        mapVC.orderDetails = self.ordersDetails![0]
        mapVC.currentLocation = self.currentLocation
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func showPriceAlert() {
        let alertViewController = SetPriceAlertView(nibName: "SetPriceAlertView", bundle: nil)
        alertViewController.modalPresentationStyle = .overCurrentContext
        alertViewController.modalTransitionStyle = .crossDissolve
        present(alertViewController, animated: true, completion: nil)
    }
    func acceptRequest(indexPath: IndexPath) {
        selectedOrderDetails = ordersDetails?[indexPath.row]
        selectedOrderID = ordersDetails?[indexPath.row].id
        print("Order id = \(ordersIDs[indexPath.row]) is accepted")
        viewModel?.acceptOrder(orderID: String(self.selectedOrderID!), captainLat: String(currentLocation.coordinate.latitude), captainLng: String(currentLocation.coordinate.longitude))
    }
    
    func seeDetail(indexPath: IndexPath) {
        let vc = OrderDetailsVC(nibName: "OrderDetailsVC", bundle: nil)
        vc.orderDetails = self.ordersDetails![indexPath.row]
        vc.orderStatus = .pendingAcceptance
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
        ordersIDs.remove(at: indexPath.row)
        ordersDetails?.remove(at: indexPath.row)
        ordersTableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ordersIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: "UpcomingRequestsCell", for: indexPath) as! UpcomingRequestsCell
        cell.indexPath = indexPath
        //cell.backgroundColor = .clear
        //cell.requestStatus = upcomingRequests[indexPath.row]
        let order = ordersDetails?[indexPath.row]
        switch order?.status {
        case "pending":
            cell.requestStatus = .pendingAcceptance
//        case "accepted","start_order","approve":
//            cell.requestStatus = .accepted
        default:
            cell.requestStatus = .accepted
        }
        cell.orderID.text = "#\(order?.id ?? 0) "
        //cell.price.text = "\(order?.cost ?? "0") EGP"
        cell.price.text = "\(order?.estimateCostFrom ?? "0")-\(order?.estimateCostTo ?? "0") EGP"
        cell.paymentMethod.text = order?.paymentMethod?.name
        cell.pickupLocation.text = order?.pickupLocationName
        cell.dropoffLocation.text = order?.dropoffLocationName
        cell.delegate = self
        return cell
    }
    
    
}
