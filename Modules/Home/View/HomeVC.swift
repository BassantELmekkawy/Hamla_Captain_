//
//  HomeVC.swift
//  Hamla
//
//  Created by Bassant on 10/03/2024.
//

import UIKit
import FittedSheets

class HomeVC: UIViewController, CustomAlertDelegate {

    @IBOutlet weak var CollectionView: UICollectionView!
    
    var sideMenuViewController: SideMenuVC!
    var sideMenuWidth: CGFloat = 260
    var overlay = UIView()
    
    var viewModel: HomeViewModel? 
    
    var upcomingRequests:[UpcomingRequest] = [.pendingAcceptance, .pendingPrice]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        self.viewModel = HomeViewModel(api: HomeApi())
        bindData()
        viewModel?.getCaptainDetails()
        
        CollectionView.delegate = self
        CollectionView.dataSource = self
        CollectionView.register(UINib(nibName: "UpcomingRequestsCell", bundle: nil), forCellWithReuseIdentifier: "UpcomingRequestsCell")
        setupSideMenu()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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
            //self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
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



    func showPriceAlert() {
        let alertViewController = SetPriceAlertView(nibName: "SetPriceAlertView", bundle: nil)
        alertViewController.modalPresentationStyle = .overCurrentContext
        alertViewController.modalTransitionStyle = .crossDissolve
        present(alertViewController, animated: true, completion: nil)
    }
    func acceptRequest() {
        let mapVC = MapVC(nibName: "MapVC", bundle: nil)
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func seeDetail(indexPath: IndexPath) {
        
    }
    
    func reject(at indexPath: IndexPath) {
        print("Deleted IndexPath = \(indexPath.row)")
        self.upcomingRequests.remove(at: indexPath.row)
        //self.CollectionView.deleteItems(at: [indexPath])
        self.CollectionView.reloadData()
        print(self.CollectionView.numberOfItems(inSection: 0))
    }
    
    @IBAction func ShowSideMenu(_ sender: Any) {
        showSideMenu()
    }
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        upcomingRequests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingRequestsCell", for: indexPath) as! UpcomingRequestsCell
        cell.indexPath = indexPath
        cell.requestStatus = upcomingRequests[indexPath.row]
        cell.delegate = self
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
