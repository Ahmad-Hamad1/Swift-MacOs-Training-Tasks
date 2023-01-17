//
//  ScannerModelInterface.swift
//  Final Project
//
//  Created by Hamad Hamad on 06/10/2022.
//

import Foundation

protocol ScannerModelInterface {
    var patients: [PatientInfo] { get }
    var filteredPatients: [PatientInfo] { get }
    var currentPatients: [PatientInfo] { get }
    func getFilteredPatients(showNegativeResults: Bool, typefilters: [TestType])
    func addPatient(patient: PatientInfo)
    func removePatient(from rawIndex: Int)
}
