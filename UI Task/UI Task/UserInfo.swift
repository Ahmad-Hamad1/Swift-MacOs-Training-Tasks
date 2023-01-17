//
//  UserInfo.swift
//  UI Task
//
//  Created by Hamad Hamad on 04/10/2022.
//

import Foundation

class UserInfo {
    var username: String
    var email: String
    var fullName: String
    var phoneNumber: String
    var website: String
    
    init(username: String, email: String, fullName: String, phoneNumber: String, website: String) {
        self.username = username
        self.email = email
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.website = website
    }
}
