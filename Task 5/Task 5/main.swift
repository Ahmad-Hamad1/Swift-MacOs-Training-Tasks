//
//  main.swift
//  Task 5
//
//  Created by Hamad Hamad on 21/09/2022.
//

import Foundation

struct User {
    var username: String
    var address: String
}

var users: [User] = []
let queue = DispatchQueue(label: "Serving Queue", attributes: .concurrent)
let lock = NSLock()

func addUser (_ user: User) {
    lock.lock()
    users.append(user)
    lock.unlock()
}

func registerUsers(_ usersDetails: [(username: String, address: String)]) {
    let dispatchGroup = DispatchGroup()
    for userDetails in  usersDetails{
        dispatchGroup.enter()
        queue.async {
            addUser(User(username: userDetails.username, address: userDetails.address))
            dispatchGroup.leave()
        }
    }
    dispatchGroup.wait()
}

func simulate() {
    var testArray: [(String, String)] = []
    for _ in 0..<15 {
        testArray.append(("Ahmad", "Ramallah"))
    }
    registerUsers(testArray)
}

simulate()
print(users.count)
