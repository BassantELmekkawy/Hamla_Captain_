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
    
    var captainDetails: CaptainData = CaptainData()
    
    let sideMenu: [sideMenuModel] = [sideMenuModel(image: "wallet", label: "My_wallet".localized), sideMenuModel(image: "delivery-truck", label: "My-orders".localized), sideMenuModel(image: "settings", label: "Settings".localized), sideMenuModel(image: "credit-card", label: "Bank_accounts".localized), sideMenuModel(image: "wallet-2", label: "STC_account".localized), sideMenuModel(image: "Help Center", label: "Help_center".localized)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuTable.delegate = self
        sideMenuTable.dataSource = self
        setupView()
        sideMenuTable.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
        
    }
    
    func setupView() {
        let url = URL(string: captainDetails.avatar ?? "")
        photo.kf.setImage(with: url, placeholder: UIImage(systemName: "person.fill")?.withTintColor(.white))
        name.text = captainDetails.fullName
        phone.text = captainDetails.mobile
    }
    
    @IBAction func goToProfile(_ sender: Any) {
        let vc = MyProfileVC(nibName: "MyProfileVC", bundle: nil)
        vc.captainDetails = captainDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func logout(_ sender: Any) {
        if UserInfo.shared.isCaptainOnOrder() {
            Toast.show(message: "Cannot_log_out_while_on_order".localized, controller: self)
        }else{
            UserInfo.shared.logOut()
            UserInfo.shared.setRootViewController(SignInVC())
        }
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
        switch indexPath.row{
        case 0:
            let vc = MyWalletVC(nibName: "MyWalletVC", bundle: nil)
            vc.totalBalance = captainDetails.walletBalance ?? 0.0
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = OrderHistoryVC(nibName: "OrderHistoryVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = SettingsVC(nibName: "SettingsVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = BankAccountsVC(nibName: "BankAccountsVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = SupportChatVC()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("default")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        sideMenuTable.frame.height/6
    }
}
