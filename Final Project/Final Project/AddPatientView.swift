//
//  AddPatientView.swift
//  Final Project
//
//  Created by Hamad Hamad on 08/10/2022.
//

import Foundation
import AppKit
import AppCommonComponents

protocol NewPatientDelegateProtocol: AnyObject {
    func addPatient(close addPatientView: AddPatientView)
    func closeAddPatientView(close addPatientView: AddPatientView)
}

class AddPatientView: NSView, NibLoaded {
    
    public var currentTestType: TestType?
    public var dataManager: DataManager!
    public weak var delegate: NewPatientDelegateProtocol?
    @IBOutlet private weak var nameTextField: NSTextField!
    @IBOutlet private weak var symptomsSlider: NSSlider!
    @IBOutlet private weak var symptomsLabel: NSTextField!
    @IBOutlet private weak var testTypesStackView: NSStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public static func createFromNib(in bundle: Bundle = Bundle.main) -> Self {
        var topLevelArray: NSArray? = nil
        bundle.loadNibNamed("AddPatientView", owner: self, topLevelObjects: &topLevelArray)
        let views = topLevelArray?.filter({ $0 is Self })
        let last = views?.last
        return (last as? Self)!
        
    }
    
    @objc
    public func radioButtonStateChenged(_ button: NSButton) {
        currentTestType = TestType(rawValue: button.title)
    }
    
    public func addRadioButtons() {
        var button = NSButton()
        for testType in TestType.allCases {
            button = NSButton(radioButtonWithTitle: testType.rawValue, target: self, action: #selector(radioButtonStateChenged(_:)))
            testTypesStackView.addArrangedSubview(button)
        }
        button.state = NSButton.StateValue.on
        currentTestType = TestType(rawValue: button.title)
    }
    
    @IBAction private func sliderChanged(_ sender: Any) {
        symptomsLabel.stringValue = String(symptomsSlider.intValue)
    }
    
    @IBAction private func saveButtonPressed(_ sender: Any) {
        dataManager.addPatient(patientName: nameTextField.stringValue, status: .positive(remainingDays: symptomsSlider.doubleValue),
                               testType: currentTestType!)
        delegate?.addPatient(close: self)
    }
    
    @IBAction private func exitButtonPressed(_ sender: Any) {
        delegate?.closeAddPatientView(close: self)
    }
    
}

