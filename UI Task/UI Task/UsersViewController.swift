//
//  UsersViewController.swift
//  UI Task
//
//  Created by Hamad Hamad on 03/10/2022.
//

import Cocoa

class UsersViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var usernameLabel: NSTextField!
    @IBOutlet weak var phoneLabel: NSTextField!
    @IBOutlet weak var emailLabel: NSTextField!
    @IBOutlet weak var websiteLabel: NSTextField!
    
    var users = [UserInfo(username: "aa", email: "aa@test.com", fullName: "aa bb", phoneNumber: "123", website: "aa.com"), UserInfo(username: "bb", email: "bb@test.com", fullName: "aa bb", phoneNumber: "123", website: "aa.com"), UserInfo(username: "cc", email: "cc@test.com", fullName: "aa bb", phoneNumber: "123", website: "aa.com"), UserInfo(username: "dd", email: "dd@test.com", fullName: "aa bb", phoneNumber: "123", website: "aa.com")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func updateData() {
        let clickedRow = tableView.selectedRow
        guard clickedRow != -1 else {return}
        usernameLabel.stringValue = users[clickedRow].username
        emailLabel.stringValue = users[clickedRow].email
        websiteLabel.stringValue = users[clickedRow].website
        phoneLabel.stringValue = users[clickedRow].phoneNumber
    }
}

extension UsersViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return users.count
    }
}

extension UsersViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let currentUser = users[row]
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "usersColumn") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "userCell")
             guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? CustomTableCell else { return nil }
            cellView.mailLabel?.stringValue = currentUser.email
            cellView.nameLabel?.stringValue = currentUser.username
            if Int.random(in: 1...10) > 5 {
                cellView.phoneLabel?.stringValue = currentUser.phoneNumber
            }
            cellView.mailLabel?.isHidden = Bool.random()
            return cellView
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateData()
    }
}
