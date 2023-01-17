//
//  ScannerModelMock.swift
//  Final Project
//
//  Created by Hamad Hamad on 06/10/2022.
//

import Foundation

class ScannerModelMock: ScannerModelInterface {
    
    var patients = [PatientInfo(name: "AAAA",
                                status: .negative,
                                testType: .PCR),
                    PatientInfo(name: "AAAAAAAAAAAAAAAA",
                                status: .negative,
                                testType: .serology),
                    PatientInfo(name: "BBBB",
                                status: .pending(remainingTime: 5),
                                testType: .LFTs),
                    PatientInfo(name: "CCCC",
                                status: .negative,
                                testType: .PCR),
                    PatientInfo(name: "DDDD",
                                status: .positive(remainingDays: 12),
                                testType: .serology)]
    
    var filteredPatients = [PatientInfo]()
    var currentPatients = [PatientInfo]()
    
    init() {
        currentPatients = patients
    }
    
    func getFilteredPatients(showNegativeResults: Bool, typefilters: [TestType]) {
        filteredPatients = patients.filter({ patient in
            if showNegativeResults == false {
                switch patient.status {
                case .negative:
                    return false
                default:
                    break
                }
            }
            
            if typefilters.contains(.PCR) == false {
                switch patient.testType {
                case .PCR:
                    return false
                default:
                    break
                }
            }
            
            if typefilters.contains(.LFTs) == false {
                switch patient.testType {
                case .LFTs:
                    return false
                default:
                    break
                }
            }
            
            if typefilters.contains(.serology) == false {
                switch patient.testType {
                case .serology:
                    return false
                default:
                    break
                }
            }
            return true
        })
        currentPatients = filteredPatients
        Thread.sleep(forTimeInterval: Double.random(in: 1...5))
    }
    
    func addPatient(patient: PatientInfo) {
        patients.append(patient)
        currentPatients = patients
    }
    
    func removePatient(from rawIndex: Int) {
        let removedPatient = currentPatients.remove(at: rawIndex)
        print(rawIndex, filteredPatients.count)
        patients.remove(at: patients.firstIndex(where: { $0.name == removedPatient.name })!)
    }
    
}
