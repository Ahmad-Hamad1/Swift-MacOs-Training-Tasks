//
//  CustomTableCell.swift
//  UI Task
//
//  Created by Hamad Hamad on 04/10/2022.
//

import Cocoa

class CustomTableCell: NSTableCellView {

    
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var phoneLabel: NSTextField!
    @IBOutlet weak var mailLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
