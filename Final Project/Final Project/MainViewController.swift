//
//  ViewController.swift
//  Final Project
//
//  Created by Hamad Hamad on 05/10/2022.
//

import Cocoa

class ViewController: NSViewController {
    private var patients = [PatientInfo]()
    private var dataManager = DataManager(scanner: ScannerModelMock())
    private var timer: DispatchSourceTimer!
    @IBOutlet weak var refreshDataPopButton: NSPopUpButton!
    @IBOutlet weak var refreshIntervalField: NSTextField!
    @IBOutlet weak var refreshIntervalStepper: NSStepper!
    @IBOutlet weak var negativeResultsSwitch: NSSwitch!
    @IBOutlet weak var serologyButton: NSButton!
    @IBOutlet weak var LFTsButton: NSButton!
    @IBOutlet weak var PCRButton: NSButton!
    @IBOutlet weak var addRemoveControl: NSSegmentedControl!
    @IBOutlet weak var patientNameLabel: NSTextField!
    @IBOutlet weak var remainingTimeProgressBar: NSProgressIndicator!
    @IBOutlet weak var tableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        hidePositiveDetails()
        tableView.delegate = self
        tableView.dataSource = self
        resetFilters()
        reloadData()
        //startTimer(timeInterval: 3.0)
    }
    
    override var representedObject: Any? {
        didSet {
        }
    }
    
    private func startTimer(timeInterval: Double) {
        let queue = DispatchQueue(label: "com.domain.app.timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer.setEventHandler {
            DispatchQueue.main.async {
                self.filterCurrentData()
            }
        }
        timer.schedule(deadline: .now(), repeating: timeInterval)
        timer.resume()
    }
    
    private func stopTimer() {
        timer.cancel()
    }
    
    private func hidePositiveDetails() {
        patientNameLabel.isHidden = true
        remainingTimeProgressBar.isHidden = true
    }
    
    private func resetFilters() {
        negativeResultsSwitch.state = NSControl.StateValue.on
        serologyButton.state = NSControl.StateValue.on
        PCRButton.state = NSControl.StateValue.on
        LFTsButton.state = NSControl.StateValue.on
    }
    
    private func updateFooter() {
        let selectedRaw = tableView.selectedRow
        guard selectedRaw != -1 else {
            patientNameLabel.isHidden = true
            remainingTimeProgressBar.isHidden = true
            return
        }
        let currentPatient = patients[selectedRaw]
        switch currentPatient.status {
        case .positive(let value):
            patientNameLabel.isHidden = false
            remainingTimeProgressBar.isHidden = false
            patientNameLabel.stringValue = currentPatient.name + "'s" + " Recovery Progress:"
            remainingTimeProgressBar.doubleValue = value / 14.0 * 100.0
            
        default:
            patientNameLabel.isHidden = true
            remainingTimeProgressBar.isHidden = true
        }
    }
    
    private func filterCurrentData() {
        var showNegativeResutls = false
        var typefilters = [TestType]()
        if negativeResultsSwitch.state == .on {
            showNegativeResutls = true
        }
        
        if PCRButton.state == .on {
            typefilters.append(.PCR)
        }
        
        if LFTsButton.state == .on {
            typefilters.append(.LFTs)
        }
        
        if serologyButton.state == .on {
            typefilters.append(.serology)
        }
        self.dataManager.getFilteredPatients(showNegativeResults: showNegativeResutls, typefilters: typefilters, completionHandler: reloadData)
    }
    
    func reloadData() {
        patients = dataManager.patients
        tableView.reloadData()
    }
    
    @IBAction private func refreshPressed(_ sender: Any) {
        self.filterCurrentData()
    }
    
    @IBAction private func segmentedControlChanged(_ sender: NSSegmentedControl) {
        if sender.indexOfSelectedItem == 1 && tableView.selectedRow != -1 {
            dataManager.removePatient(rawIndex: tableView.selectedRow)
            reloadData()
            hidePositiveDetails()
            tableView.reloadData()
        } else if sender.indexOfSelectedItem == 0 {
            let viewController = NSViewController()
            let addnewPatientView = AddPatientView.createFromNib()
            addnewPatientView.delegate = self
            addnewPatientView.addRadioButtons()
            addnewPatientView.dataManager = dataManager
            viewController.view = addnewPatientView
            presentAsSheet(viewController)
        }
    }
    
    @IBAction private func stepperChanged(_ sender: NSStepper) {
        refreshIntervalField.intValue = sender.intValue
    }
    
    @IBAction private func refreshPopUpButtonChanged(_ sender: NSPopUpButton) {
        if sender.selectItem(withTag: 0) {
            refreshIntervalStepper.isEnabled = false
            refreshIntervalField.isEnabled = false
            timer.cancel()
        } else {
            refreshIntervalStepper.isEnabled = true
            refreshIntervalField.isEnabled = true
            startTimer(timeInterval: refreshIntervalStepper.doubleValue)
        }
    }
    
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return patients.count
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let currentPatient = patients[row]
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "nameColumn") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "nameCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NameCustomCell else { return nil }
            cellView.nameLabel?.stringValue = currentPatient.name
            cellView.statusImageView?.image = currentPatient.statusImage
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "typeColumn") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "typeCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? TypeCustomCell else { return nil }
            cellView.typeLabel?.stringValue = currentPatient.testType.rawValue
            return cellView
        } else {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "statusCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? StatusCustomCell else { return nil }
            cellView.statusLabel?.stringValue = currentPatient.status.statusText
            return cellView
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateFooter()
    }
}

extension ViewController: NewPatientDelegateProtocol {
    
    func addPatient(close addPatientView: AddPatientView) {
        filterCurrentData()
        addPatientView.window?.close()
    }
    
    func closeAddPatientView(close addPatientView: AddPatientView) {
        addPatientView.window?.close()
    }
}

