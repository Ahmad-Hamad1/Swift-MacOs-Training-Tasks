//
//  main.swift
//  Task 2
//
//  Created by Ahmad Hamad on 13/09/2022.
//

import Foundation

func getSum(_ arr: [Int]) -> Int {
  return arr.reduce(0, +)
}

func removeDuplicates(_ arr: [Int]) -> [Int] {
  return Array(Set<Int>(arr))
}

func intArrayToStringArray(_ arr: [Int]) -> [String] {
  return arr.map({
    "item - \($0)"
  })
}

func dicToArray(_ dic: [Int: Int]) -> [(Int, Int)] {
  var finalArray: [(Int, Int)] = []
  dic.forEach { (key, val) in
    finalArray.append((key, val))
  }
  return finalArray
}

func findFrequency(_ num: Int, _ arr: [Int]) -> Int {
  return arr.filter({ $0 == num }).count
}

func findIndex(_ num: Int, _ arr: [Int]) -> Int {
  if let ret = arr.firstIndex(of: num) {
    return ret
  }
  return -1
}
print(getSum([1, 2, 3, 4, 5]))
print(removeDuplicates([1, 2, 3, 4, 3, 5, 1, 5]))
print(intArrayToStringArray([1, 2, 3, 4, 5]))
print(dicToArray([1: 1, 2: 3, 4: 5]))
print(findFrequency(1, [1, 2, 3, 4, 3, 5, 1, 5]))
print(findIndex(3, [1, 2, 3, 4, 3, 5, 1, 5]))

