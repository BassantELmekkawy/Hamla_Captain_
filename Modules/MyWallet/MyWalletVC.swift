//
//  MyWalletVC.swift
//  Hamla
//
//  Created by Bassant on 18/03/2024.
//

import UIKit

class MyWalletVC: UIViewController {

    @IBOutlet weak var totalBalanceBackground: UIView!
    @IBOutlet weak var transactionsTable: UITableView!
    @IBOutlet weak var noTransactionsView: UIView!
    
    var numberOfTransactions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.title = "My wallet"
        
        transactionsTable.delegate = self
        transactionsTable.dataSource = self
        
        transactionsTable.register(UINib(nibName: "TransactionCell", bundle: nil), forCellReuseIdentifier: "TransactionCell")
        noTransactionsView.isHidden = true
        totalBalanceBackground.twoColorDiagonalView(color1: UIColor(named: "primary") ?? .blue, color2: UIColor(named: "LightBlue") ?? .blue)
    }
    
    func updateEmptyStateVisibility() {
        if numberOfTransactions == 0 {
            noTransactionsView.isHidden = false
        } else {
            noTransactionsView.isHidden = true
        }
    }
}

extension MyWalletVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = numberOfTransactions
        updateEmptyStateVisibility()
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionsTable.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80.0
    }
}
