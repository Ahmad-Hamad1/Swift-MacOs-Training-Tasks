//
//  main.swift
//  Dictionaries
//
//  Created by Ahmad Hamad on 13/09/2022.
//

import Foundation

var todo = ["Buy milk", "Go to gym", "Eat dinner"]
todo.append("Visit relatives")
var done: [String] = []
done.append(todo.removeFirst())
var itemDec: [String: Bool] = [:]
for item in todo {
  itemDec[item] = false
}

for item in done {
  itemDec[item] = true
}

itemDec.removeValue(forKey: "Go to gym")
itemDec["Eat dinner"]?.toggle()
for (item, val) in itemDec {
  print(item, terminator: " ")
  print(val)
}
