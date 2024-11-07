//
//  SettingsVC.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant Elmekkawy on 24/10/2024.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings".localized
        self.navigationController?.navigationBar.isHidden = false
        setupNavigationBar()
        
        settingsTableView.rowHeight = UITableView.automaticDimension
        settingsTableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }

}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LanguageVC(nibName: "LanguageVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
