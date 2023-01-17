//
// main.swift
// Task 3
//
// Created by Hamad Hamad on 18/09/2022.
//
import Foundation

enum CollectionErrors: Error {
    case emptyStack
    case fullStack
    case indexNotFound
    case fullQueue
    case emptyQueue
}

class Node: Comparable & Hashable {
    static func < (lhs: Node, rhs: Node) -> Bool {
        return lhs.desc < rhs.desc
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.desc == rhs.desc
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(desc)
    }
    
    var id: String
    var desc: String
    init(_ desc: String) {
        id = UUID().uuidString
        self.desc = desc
    }
    
    func getDesc() -> String {
        return "Node with id \(id) and description: \(desc)"
    }
    
}

class Stack<T> {
    var stack: [T] = []
    var maxCapacity = -1 {
        didSet {
            if stack.count > maxCapacity {
                for _ in 0..<stack.count - maxCapacity {
                    stack.removeLast()
                }
            }
        }
    }
    func push(_ element: T) throws {
        if stack.count == maxCapacity {
            throw CollectionErrors.emptyStack
        }
        stack.append(element)
    }
    
    func pop() throws -> T {
        if stack.count == 0 {
            throw CollectionErrors.emptyStack
        }
        return stack.popLast()!
    }
    
    func peek() throws -> T {
        if stack.count == 0 {
            throw CollectionErrors.emptyStack
        }
        return stack.last!
    }
    
    func isEmpty() -> Bool {
        return stack.isEmpty
    }
}

class Queue<T> {
    var queue: [T] = []
    var maxCapacity = -1 {
        didSet {
            if queue.count > maxCapacity {
                for _ in 0..<queue.count - maxCapacity {
                    queue.removeFirst()
                }
            }
        }
    }
    func add(_ element: T) throws {
        if queue.count == maxCapacity {
            throw CollectionErrors.fullQueue
        }
        queue.append(element)
    }
    func remove() throws -> T {
        if queue.count == 0 {
            throw CollectionErrors.emptyQueue
        }
        let ret = queue.first
        queue.removeFirst()
        return ret!
    }
    func peek() throws -> T {
        if queue.count == 0 {
            throw CollectionErrors.emptyQueue
        }
        return queue.first!
    }
    func isEmpty() -> Bool {
        return queue.isEmpty
    }
}

extension Stack {
    convenience init(_ maxCapacity: Int) {
        self.init()
        self.maxCapacity = maxCapacity
    }
    
    func insertAt(_ element: T, _ idx: Int) throws {
        if idx >= self.stack.count {
            throw CollectionErrors.indexNotFound
        }
        self.stack.insert(element, at: idx)
    }
    
    func removeAt(_ idx: Int) throws {
        if !stack.indices.contains(idx) {
            throw CollectionErrors.indexNotFound
        }
        self.stack.remove(at: idx)
    }
    
    func sortStack() where T: Comparable {
        self.stack.sort(by: <)
    }
    
    func resize(_ newSize: Int) {
        self.maxCapacity = newSize
    }
    
    func removeDuplicates() where T: Hashable {
        var found = Set<T>()
        self.stack = self.stack.compactMap({
            guard found.contains($0) else {
                found.insert($0)
                return $0
            }
            return nil
        })
    }
}

print("Stack test: ")
var stack = Stack<Node>()
do {
    try stack.push(Node("aa"))
    try stack.push(Node("bb"))
    try stack.push(Node("cc"))
    try stack.push(Node("dd"))
    print(try stack.peek().getDesc())
    print(try stack.pop().getDesc())
    try stack.push(Node("ee"))
    print(try stack.pop().getDesc())
    print(stack.isEmpty())
    try stack.insertAt(Node("ff"), 2)
    try stack.push(Node("ff"))
    stack.sortStack()
    print("\nAfter sorting but brfore removing duplicates")
    print()
    for elem in stack.stack {
        print(elem.getDesc())
    }
    stack.removeDuplicates()
    print("*********************************************************************")
    print()
    print("After sorting and removing duplicates")
    print()
    for elem in stack.stack {
        print(elem.getDesc())
    }
} catch CollectionErrors.emptyStack {
    print("The stack is empty")
} catch CollectionErrors.fullStack {
    print("The stack is full")
} catch CollectionErrors.indexNotFound {
    print("Index not found")
}

print()
print("Queue test: ")
var queue = Queue<Node>()
do {
    try queue.add(Node("aa"))
    try queue.add(Node("bb"))
    try queue.add(Node("cc"))
    try queue.add(Node("dd"))
    print(try queue.peek().getDesc())
    print(try queue.remove().getDesc())
    try queue.add(Node("ee"))
    print(try queue.remove().getDesc())
    print(queue.isEmpty())
} catch CollectionErrors.emptyQueue {
    print("The queue is empty")
} catch CollectionErrors.fullQueue {
    print("The queue is full")
} catch CollectionErrors.indexNotFound {
    print("Index not found")
}
