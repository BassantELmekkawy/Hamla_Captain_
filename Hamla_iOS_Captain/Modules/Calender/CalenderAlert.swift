//
//  CalenderAlert.swift
//  Hamla
//
//  Created by Bassant on 12/03/2024.
//

import UIKit

class CalenderAlert: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var didSelectDate: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAlert))
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissAlert() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: sender.date)
        didSelectDate?(selectedDate)
        print("Selected date: \(selectedDate)")
    }
}
