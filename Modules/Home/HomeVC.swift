//
//  HomeVC.swift
//  Hamla
//
//  Created by Bassant on 10/03/2024.
//

import UIKit
//import FittedSheets

class HomeVC: UIViewController {

    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var mapView: UIView!
    
    //var sideMenuViewController: SideMenuVC!
    var sideMenuWidth: CGFloat = 260
    var overlay = UIView()
    
    var upcomingRequests:[UpcomingRequest] = [.pendingAcceptance, .pendingPrice]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        mapView.isHidden = true
        
        CollectionView.delegate = self
        CollectionView.dataSource = self
        CollectionView.register(UINib(nibName: "UpcomingRequestsCell", bundle: nil), forCellWithReuseIdentifier: "UpcomingRequestsCell")
        //setupSideMenu()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
//    func setupSideMenu() {
//        addOverlay(view: self.view)
//        overlay.isHidden = true
//        sideMenuViewController = SideMenuVC(nibName: "SideMenuVC", bundle: nil)
//        addChild(sideMenuViewController)
//        sideMenuViewController.view.frame = CGRect(x: -sideMenuWidth, y: 0, width: sideMenuWidth, height: view.frame.height)
//        view.addSubview(sideMenuViewController.view)
//        sideMenuViewController.didMove(toParent: self)
//
//        // Add tap gesture to close side menu
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        tapGesture.cancelsTouchesInView = false
//        view.addGestureRecognizer(tapGesture)
//    }
    
//    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        let location = sender.location(in: sideMenuViewController.view)
//        if !sideMenuViewController.view.frame.contains(location) {
//            hideSideMenu()
//        }
//    }
    
//    func showSideMenu() {
//        //self.addOverlay(view: self.view)
//        overlay.isHidden = false
//        UIView.animate(withDuration: 0.3) {
//            self.sideMenuViewController.view.frame.origin.x = 0
//            //self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//
//        }
//    }
    
//    func hideSideMenu() {
//        UIView.animate(withDuration: 0.3) {
//            self.sideMenuViewController.view.frame.origin.x = -self.sideMenuWidth
//            //self.overlay.removeFromSuperview()
//            self.overlay.isHidden = true
//        }
//    }
    
    func addOverlay(view: UIView) {
        overlay = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        overlay.backgroundColor = .black
        overlay.layer.opacity = 0.8
        view.addSubview(overlay)
    }

//    func showRequest(controller : UIViewController) {
//        let options = SheetOptions(
//            pullBarHeight: 0,
//            useFullScreenMode: false,
//            shrinkPresentingViewController: false,
//            useInlineMode: true,
//            horizontalPadding: 30,
//            maxWidth: self.view.frame.width
//
//        )
//
//        let sheet = SheetViewController(controller: controller, sizes: [.fixed(240) , .fixed(30)] , options: options)
//        sheet.dismissOnPull = false
//        sheet.allowPullingPastMaxHeight = false
//        sheet.overlayColor = UIColor.clear
//        sheet.dismissOnOverlayTap = false
//        sheet.contentBackgroundColor = .clear
//        sheet.cornerRadius = 20
//        sheet.allowGestureThroughOverlay = true
//        sheet.animateIn(to: view, in: self)
//        //self.present(sheet, animated: true, completion: nil)
//    }

//    func showPriceAlert() {
//        let alertViewController = SetPriceAlertView(nibName: "SetPriceAlertView", bundle: nil)
//        alertViewController.modalPresentationStyle = .overCurrentContext
//        alertViewController.modalTransitionStyle = .crossDissolve
//        present(alertViewController, animated: true, completion: nil)
//    }
//    func acceptRequest() {
//        mapView.isHidden = false
//        showRequest(controller: CurrentRequestVC())
//    }
//    func seeDetail(indexPath: IndexPath) {
//        let vc = OrderDetailsVC(nibName: "OrderDetailsVC", bundle: nil)
//        print("\(upcomingRequests[indexPath.row])")
//        //vc.number = "\(upcomingRequests[indexPath.row])"
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    func reject(at indexPath: IndexPath) {
//        print("Deleted IndexPath = \(indexPath.row)")
//        self.upcomingRequests.remove(at: indexPath.row)
//        //self.CollectionView.deleteItems(at: [indexPath])
//        self.CollectionView.reloadData()
//        print(self.CollectionView.numberOfItems(inSection: 0))
//    }
    
//    @IBAction func ShowSideMenu(_ sender: Any) {
//        showSideMenu()
////        let sideMenuVC = SideMenuVC(nibName: "SideMenuVC", bundle: nil)
////        sideMenuVC.modalPresentationStyle = .overCurrentContext
////        sideMenuVC.modalTransitionStyle = .crossDissolve
////        present(sideMenuVC, animated: true, completion: nil)
//    }
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        upcomingRequests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingRequestsCell", for: indexPath) as! UpcomingRequestsCell
        cell.indexPath = indexPath
        cell.requestStatus = upcomingRequests[indexPath.row]
        //cell.delegate = self
        return cell
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.bounds.width
            let height: CGFloat = 230
            
            return CGSize(width: width, height: height)
        }
}
