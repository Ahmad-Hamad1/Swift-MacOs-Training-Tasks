//
//  main.swift
//  Task 4
//
//  Created by Hamad Hamad on 20/09/2022.
//

import Foundation
var sum = 0
let arr = Array(1...1000)
let queue = DispatchQueue(label: "swiftlee.concurrent.queue", attributes: .concurrent)
let lock = NSLock()

func segmentSum(_ start: Int, _ end: Int) {
    var temp = 0
    for i in start...end {
        temp += arr[i]
    }
    lock.lock()
    sum += temp
    lock.unlock()
}


func calcSum() {
    let dispatchGroup = DispatchGroup()
    for index in stride(from: 0, to: 1000, by: 10) {
        dispatchGroup.enter()
        queue.async {
            segmentSum(index, index + 9)
            dispatchGroup.leave()
        }
    }
    dispatchGroup.wait()
}

calcSum()
print(sum)



