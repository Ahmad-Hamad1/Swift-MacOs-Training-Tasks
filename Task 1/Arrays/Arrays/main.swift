//
//  main.swift
//  Arrays
//
//  Created by Ahmad Hamad on 13/09/2022.
//

import Foundation

var todo = ["Buy milk", "Go to gym", "Eat dinner"]
todo.append("Visit relatives")
var done: [String] = []
done.append(todo.removeFirst())
var allItems = todo + done
print(allItems)
