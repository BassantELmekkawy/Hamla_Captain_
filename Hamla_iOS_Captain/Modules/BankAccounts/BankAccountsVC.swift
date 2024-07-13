//
//  BankAccountsVC.swift
//  Hamla
//
//  Created by Bassant on 25/03/2024.
//

import UIKit

class BankAccountsVC: UIViewController {

    @IBOutlet weak var bankAccountsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bankAccountsTable.delegate = self
        bankAccountsTable.dataSource = self
        
        bankAccountsTable.register(UINib(nibName: "BankAccountsCell", bundle: nil), forCellReuseIdentifier: "BankAccountsCell")
        
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Bank Accounts"
        let addBarButton = UIBarButtonItem(title: "Add +", style: .plain, target: self, action: #selector(addBankAccount))
        
        addBarButton.tintColor = UIColor(named: "primary")
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        addBarButton.setTitleTextAttributes(attributes, for: .normal)
        addBarButton.setTitleTextAttributes(attributes, for: .highlighted)
        
        self.navigationItem.rightBarButtonItem = addBarButton
    }

    @objc func addBankAccount(){
        
    }

}

extension BankAccountsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bankAccountsTable.dequeueReusableCell(withIdentifier: "BankAccountsCell", for: indexPath) as! BankAccountsCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180.0
    }
}
