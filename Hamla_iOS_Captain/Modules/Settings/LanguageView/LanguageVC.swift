//
//  LanguageVC.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant Elmekkawy on 24/10/2024.
//

import UIKit
import MOLH

class LanguageVC: UIViewController {

    @IBOutlet weak var languageTableView: UITableView!
    let languages = ["ar","en"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Language".localized
        languageTableView.register(UINib(nibName: "LanguageCell", bundle: nil), forCellReuseIdentifier: "LanguageCell")
        languageTableView.delegate = self
        languageTableView.dataSource = self
    }

}

extension LanguageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = languageTableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        if languages[indexPath.row] == MOLHLanguage.currentAppleLanguage() {
            cell.language.textColor = UIColor(named: "primary")
        }
        switch indexPath.row {
        case 0:
            cell.language.text = "Arabic"
        case 1:
            cell.language.text = "English"
        default:
            cell.language.text = "English"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if languages[indexPath.row] == MOLHLanguage.currentAppleLanguage() {
            return
        }
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        
        switch indexPath.row {
        case 0:
            MOLH.setLanguageTo("ar")
            transition.subtype = .fromLeft
        case 1:
            MOLH.setLanguageTo("en")
            transition.subtype = .fromRight
        default:
            break
        }
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                let navigationController = UINavigationController(rootViewController: HomeVC())
                
                window.layer.add(transition, forKey: kCATransition)
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
}
