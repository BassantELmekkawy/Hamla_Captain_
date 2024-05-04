//
//  SideMenuVC.swift
//  Hamla
//
//  Created by Bassant on 15/03/2024.
//

import UIKit
import Kingfisher

class SideMenuVC: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var sideMenuTable: UITableView!
    
    let sideMenu: [sideMenuModel] = [sideMenuModel(image: "wallet", label: "My wallet"), sideMenuModel(image: "delivery-truck", label: "Order history"), sideMenuModel(image: "settings", label: "Settings"), sideMenuModel(image: "credit-card", label: "Bank accounts"), sideMenuModel(image: "wallet-2", label: "STC account"), sideMenuModel(image: "Help Center", label: "Help center")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuTable.delegate = self
        sideMenuTable.dataSource = self
        setupView()
        sideMenuTable.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
        
    }
    
    func setupView() {
        let user = UserInfo.shared
        let url = URL(string: user.get_image())
        photo.kf.setImage(with: url)
        name.text = user.get_username()
        phone.text = user.get_phone()
    }
    
    @IBAction func goToProfile(_ sender: Any) {
        let vc = MyProfileVC(nibName: "MyProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func logout(_ sender: Any) {
        UserInfo.shared.logOut()
        UserInfo.shared.setRootViewController(SignInVC())
    }
}

extension SideMenuVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sideMenuTable.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        cell.menuImage.image = UIImage(named: sideMenu[indexPath.row].image)
        cell.menuLabel.text = sideMenu[indexPath.row].label
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var vc: UIViewController?
//        switch indexPath.row{
//        case 0:
//            vc = MyWalletVC(nibName: "MyWalletVC", bundle: nil)
//        case 1:
//            vc = OrderHistoryVC(nibName: "OrderHistoryVC", bundle: nil)
//        case 3:
//            vc = BankAccountsVC(nibName: "BankAccountsVC", bundle: nil)
//        default:
//            print("default")
//        }
//        if let viewController = vc{
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        sideMenuTable.frame.height/6
    }
}
