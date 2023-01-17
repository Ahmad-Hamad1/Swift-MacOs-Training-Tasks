//
//  main.swift
//  Coffe Machine
//
//  Created by Ahmad Hamad on 26/09/2022.
//

import Foundation

enum Resources: Int, CaseIterable {
    case water
    case coffe
    case milk
    var resourceTimeAllocation: Double {
        switch self {
        case .water:
            return 1
        case .coffe:
            return 2
        case .milk:
            return 3
        }
    }
}

struct Order {
    var id: Int
    var requiredResorces: [Resources]
    var priority: Int
    
    init(id: Int, requiredResources: [Resources], priority: Int) {
        self.id = id
        self.requiredResorces = requiredResources
        self.priority = priority
    }
}

class CoffeMachine {
    var queue = DispatchQueue(label: "Orders queue", qos: .background, attributes: .concurrent)
    var resourcesLock = [NSLock(), NSLock(), NSLock()]
    var disparchGroup = DispatchGroup()
    var orders = [[Order]]()
    var ordersLock = NSLock()
    var timer: DispatchSourceTimer!
    
    func startTimer() {
        let queue = DispatchQueue(label: "com.domain.app.timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer.setEventHandler {
            self.ordersLock.lock()
            for index in 1...9 {
                if self.orders[index].count != 0 {
                    self.orders[index - 1].append(self.orders[index].removeFirst())
                }
            }
            self.ordersLock.unlock()
        }
        timer.schedule(deadline: .now(), repeating: 1.0)
        timer.resume()
    }
    
    init() {
        for _ in 0...9 {
            orders.append([])
        }
        
        processOrders()
    }
    
    func handleOrder(order: Order) {
        disparchGroup.enter()
        queue.async {
            self.ordersLock.lock()
            self.orders[order.priority].append(order)
            self.ordersLock.unlock()
        }
    }
    
    func processOrders() {
        DispatchQueue.global().async {
            while true {
                self.ordersLock.lock()
                var currentOrderOptional: Order?
                for index in 0...9 {
                    if self.orders[index].count != 0 {
                        currentOrderOptional = self.orders[index].removeFirst()
                        break
                    }
                }
                guard let currentOrder = currentOrderOptional else {
                    self.ordersLock.unlock()
                    continue
                }
                self.ordersLock.unlock()
                self.queue.async {
                    self.prepareOrder(order: currentOrder)
                    self.disparchGroup.leave()
                }
            }
        }
    }
    
    func prepareOrder(order: Order) {
        let internalDispatch = DispatchGroup()
        for resource in order.requiredResorces {
            internalDispatch.enter()
            queue.async {
                self.resourcesLock[resource.rawValue].lock()
                Thread.sleep(forTimeInterval: resource.resourceTimeAllocation)
                self.resourcesLock[resource.rawValue].unlock()
                internalDispatch.leave()
            }
        }
        internalDispatch.wait()
        print("Order \(order.id) is ready")
    }
    
    func waitTillFinish() {
        disparchGroup.wait()
    }
}

var coffeMachine = CoffeMachine()
coffeMachine.startTimer()
let start = Date()

// optimal total time about 4 seconds
coffeMachine.handleOrder(order: Order(id: 1, requiredResources: [.water], priority: 0))  // 1
coffeMachine.handleOrder(order: Order(id: 2, requiredResources: [.water, .coffe], priority: 0))  // 1 + 2
coffeMachine.handleOrder(
    order: Order(id: 3, requiredResources: [.water, .coffe, .milk], priority: 0))  // 1 + 2 + 3

coffeMachine.waitTillFinish()
print("\nTime for all drinks", Date().timeIntervalSince(start))
print("\nDone!!")
