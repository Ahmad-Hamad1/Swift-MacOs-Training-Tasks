//
//  PatientInfo.swift
//  Final Project
//
//  Created by Hamad Hamad on 06/10/2022.
//

import Foundation
import AppKit

enum PatientStatus {
    //swiftlint:disable identifier_name
    case pending(remainingTime: Int)
    case positive(remainingDays: Double)
    case negative
    //swiftlint:enable identifier_name
    var statusText: String {
        switch self {
        case .negative:
            return "Negative"
        case .positive:
            return "Positive"
        case .pending:
            return "Pending"
        }
    }
}

enum TestType: String, CaseIterable {
    case PCR
    case LFTs
    case serology
}

class PatientInfo {
    var name: String
    var status: PatientStatus
    var testType: TestType
    var statusImage: NSImage
    
    init(name: String, status: PatientStatus, testType: TestType) {
        self.name = name
        self.status = status
        self.testType = testType
        switch status {
        case .pending:
            self.statusImage = NSImage(named: "PendingIcon")!
        case .positive:
            self.statusImage = NSImage(named: "PositiveIcon")!
        case .negative:
            self.statusImage = NSImage(named: "NegativeIcon")!
        }
    }
}
