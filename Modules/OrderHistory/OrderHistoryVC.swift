//
//  OrderHistoryVC.swift
//  Hamla
//
//  Created by Bassant on 19/03/2024.
//

import UIKit

enum orderState{
    case current
    case completed
    case canceled
}

class OrderHistoryVC: UIViewController {

    @IBOutlet weak var orderHistoryTable: UITableView!
    
    var selectedState: orderState = .current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Order History"
        
        orderHistoryTable.delegate = self
        orderHistoryTable.dataSource = self
        
        orderHistoryTable.register(UINib(nibName: "OrderHistoryCell", bundle: nil), forCellReuseIdentifier: "OrderHistoryCell")
    }


    
    @IBAction func segmentValueChanged(_ sender: CustomSegmentedControl) {
        
        switch sender.selectedSegmentIndex{
        case 0:
            selectedState = .current
        case 1:
            selectedState = .completed
        case 2:
            selectedState = .canceled
        default:
            selectedState = .current
        }
        
        orderHistoryTable.reloadData()
    }
    
}

extension OrderHistoryVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderHistoryTable.dequeueReusableCell(withIdentifier: "OrderHistoryCell", for: indexPath) as! OrderHistoryCell
        switch selectedState{
        case .current:
            cell.orderStateBtn.setTitle("On way", for: .normal)
            cell.orderStateBtn.setTitleColor(UIColor(named: "sunrise"), for: .normal)
            cell.orderStateBtn.backgroundColor = UIColor(named: "sunrise")?.withAlphaComponent(0.1)
        case .completed:
            cell.orderStateBtn.setTitle("Completed", for: .normal)
            cell.orderStateBtn.setTitleColor(UIColor(named: "forest"), for: .normal)
            cell.orderStateBtn.backgroundColor = UIColor(named: "forest")?.withAlphaComponent(0.1)
        case .canceled:
            cell.orderStateBtn.setTitle("Canceled", for: .normal)
            cell.orderStateBtn.setTitleColor(UIColor(named: "sunset"), for: .normal)
            cell.orderStateBtn.backgroundColor = UIColor(named: "sunset")?.withAlphaComponent(0.1)
        }
        return cell
    }
    
    
}
