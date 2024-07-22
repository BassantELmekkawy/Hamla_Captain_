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
    
    let dateFormatter = DateFormatter()
    var didSelectDate: ((String) -> Void)?
    var minDate: Date?
    var maxDate: Date?
    var initialDate: Date?
    
    init(minDate: Date? = nil, maxDate: Date? = nil) {
        self.minDate = minDate
        self.maxDate = maxDate
        super.init(nibName: "CalenderAlert", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        setupDateFormatter()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAlert))
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupDatePicker() {
        if let minDate = minDate {
            datePicker.minimumDate = minDate
        }
        if let maxDate = maxDate {
            datePicker.maximumDate = maxDate
        }
        initialDate = datePicker.date
    }
    
    func setupDateFormatter() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    @objc func dismissAlert() {
        if initialDate == datePicker.date {
            let selectedDate = dateFormatter.string(from: datePicker.date)
            didSelectDate?(selectedDate)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let selectedDate = dateFormatter.string(from: sender.date)
        didSelectDate?(selectedDate)
        print("Selected date: \(selectedDate)")
    }
}
