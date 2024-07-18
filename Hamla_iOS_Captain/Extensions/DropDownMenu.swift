//
//  DropDownMenu.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 21/04/2024.
//

import Foundation
import UIKit

class DropdownMenu: NSObject {

    private let tableView = UITableView()
    private let transparentView = UIView()
    private var dataSource = [String]()
    private var tableViewButton: UIButton?
    
    var selectedElement: ((String) -> Void)?
    var selectedRow: Int?

    init(dataSource: [String], button: UIButton) {
        self.dataSource = dataSource
        self.tableViewButton = button
        
        super.init()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func setupDropdownMenu() {
        guard let button = tableViewButton else { return }
        addTableView(frames: button.frame)
    }

    private func addTableView(frames: CGRect) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        guard let button = tableViewButton else { return }
        let buttonFrameInWindow = button.convert(button.bounds, to: window)

        transparentView.backgroundColor = UIColor.clear
        transparentView.frame = window.frame
        window.addSubview(transparentView)

        tableView.rowHeight = 40
        let tableViewHeight = (dataSource.count > 3) ? 120.0 : CGFloat(dataSource.count) * tableView.rowHeight
        tableView.frame = CGRect(x: buttonFrameInWindow.minX, y: buttonFrameInWindow.maxY, width: buttonFrameInWindow.width, height: tableViewHeight)
        window.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        tableView.separatorStyle = .none
        tableView.layer.borderColor = UIColor.systemGray5.cgColor
        tableView.layer.borderWidth = 1.0

        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        //tableViewButton?.setTitle(dataSource[0], for: .normal)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideTableView))
        transparentView.addGestureRecognizer(tapGesture)

        tableView.isHidden = true
        transparentView.isHidden = true
    }

    func showTableView(frames: CGRect) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        guard let button = tableViewButton else { return }
        let buttonFrameInWindow = button.convert(button.bounds, to: window)

        tableView.frame = CGRect(x: buttonFrameInWindow.minX, y: buttonFrameInWindow.maxY, width: buttonFrameInWindow.width, height: tableView.frame.height)
        tableView.isHidden = false
        transparentView.isHidden = false
        window.bringSubviewToFront(transparentView)
        window.bringSubviewToFront(tableView)
    }

    @objc private func hideTableView() {
        tableView.isHidden = true
        transparentView.isHidden = true
    }
}

extension DropdownMenu: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        selectedElement?(dataSource[indexPath.row])
        //tableViewButton?.setTitle(dataSource[indexPath.row], for: .normal)
        hideTableView()
    }
}