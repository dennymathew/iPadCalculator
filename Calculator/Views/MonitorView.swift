//
//  MonitorView.swift
//  Calculator
//
//  Created by Denny on 01/02/23.
//

import SwiftUI

enum MonitorEvent {
    case delete
    case copy
    case paste
}

// display area displays current result
struct MonitorView: View {
    var eventCallback: ((MonitorEvent) -> Void)?
    
    // bindind display text from calculator
    @Binding var currentDisplay: String
    
    @Binding var isPresentingPopover: Bool
    
    // dynamic font size for different display text length so that it does not exceed the control panel width
    var fontSize: CGFloat {
        get {
            if currentDisplay.count > 11 {
                return 70
            } else if currentDisplay.count > 9 {
                return 75
            } else if currentDisplay.count > 8 {
                return 80
            } else {
                return 100
            }
        }
    }
    
    var body: some View {
        Text(currentDisplay)
            .foregroundColor(Color.white)
            .font(.system(size: fontSize))
            .contextMenu {
                Button(action: {
                    self.eventCallback?(.copy)
                }) {
                    Text("Copy")
                    Image(systemName: "doc.on.doc")
                }
                Button(action: {
                    self.eventCallback?(.paste)
                }) {
                    Text("Paste")
                    Image(systemName: "doc.on.clipboard")
                }
        }
        .id(UUID.init())
        .frame(minHeight: 120)
    }
}
