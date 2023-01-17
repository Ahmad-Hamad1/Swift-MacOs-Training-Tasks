//
//  main.swift
//  Sets
//
//  Created by Ahmad Hamad on 13/09/2022.
//

import Foundation

var todo = ["Buy milk", "Go to gym", "Eat dinner"]
todo.append("Visit relatives")
var done: [String] = []
done.append(todo.removeFirst())
var allItems = todo + done
var todoSet = Set<String>(todo)
todoSet.insert(todo.first!)
print(todoSet)
var doneSet = Set<String>(done)
var intersection = todoSet.intersection(doneSet)
var union = todoSet.union(doneSet)
print(union == Set<String>(allItems))
