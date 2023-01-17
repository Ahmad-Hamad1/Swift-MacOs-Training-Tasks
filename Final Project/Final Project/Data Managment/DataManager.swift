//
//  DataManager.swift
//  Final Project
//
//  Created by Hamad Hamad on 06/10/2022.
//

import Foundation

class DataManager {
    
    var patients: [PatientInfo] {
        scanner.currentPatients
    }
    
    private var scanner: ScannerModelInterface
    
    init(scanner: ScannerModelInterface) {
        self.scanner = scanner
    }
    
    func getFilteredPatients(showNegativeResults: Bool, typefilters: [TestType], completionHandler: @escaping (() -> Void)) {
        DispatchQueue.global().async {
            self.scanner.getFilteredPatients(showNegativeResults: showNegativeResults, typefilters: typefilters)
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    func removePatient(rawIndex: Int) {
        scanner.removePatient(from: rawIndex)
    }
    
    func addPatient(patientName: String, status: PatientStatus, testType: TestType) {
        scanner.addPatient(patient: PatientInfo(name: patientName, status: status, testType: testType))
    }
}
