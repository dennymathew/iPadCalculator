//
//  ContentView.swift
//  Calculator
//
//  Created by Denny on 01/02/23.
//

import SwiftUI

struct CalculatorView: View {
    @State var currentDisplay = "0"
    @State private var calculator = Calculator()
    @State private var isDraggingHandled = false
    @State private var isPresentingPopover = true
    
    // callback functoin when user interacts with display area
    private func onMonitorClick(_ event: MonitorEvent) -> Void {
        switch event {
        case .copy:
            UIPasteboard.general.string = currentDisplay
        case .paste:
            let content = UIPasteboard.general.string
            guard content != nil else {
                return
            }
            calculator.onPaste(content!)
            currentDisplay = calculator.displayedValue
        default:
            break
        }
    }
    
    private func onDelete() {
        calculator.onDelete()
        currentDisplay = calculator.displayedValue
    }
    
    // callback function when user clicks a button in control panel
    private func onControlPanelClick(_ keyType: KeyType) -> Void {
        switch keyType {
        case .plus, .minus, .multiply, .divide:
            calculator.onPressOperator(keyType)
        case .digit0:
            calculator.onPressDigit(0)
        case .digit1:
            calculator.onPressDigit(1)
        case .digit2:
            calculator.onPressDigit(2)
        case .digit3:
            calculator.onPressDigit(3)
        case .digit4:
            calculator.onPressDigit(4)
        case .digit5:
            calculator.onPressDigit(5)
        case .digit6:
            calculator.onPressDigit(6)
        case .digit7:
            calculator.onPressDigit(7)
        case .digit8:
            calculator.onPressDigit(8)
        case .digit9:
            calculator.onPressDigit(9)
        case .dot:
            calculator.onPressDot()
        case .equals:
            calculator.onCalculate()
        case .clear:
            calculator.onAC()
        case .negator:
            calculator.onPlusMinus()
        case .percentage:
            calculator.onPercentage()
        }
        currentDisplay = calculator.displayedValue
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .trailing, spacing: 30.0){
                Spacer()
                Spacer()
                MonitorView(eventCallback: onMonitorClick, currentDisplay: $currentDisplay, isPresentingPopover: $isPresentingPopover)
                    .frame(maxWidth: controlPanelWidth, alignment: .trailing)
                    .padding(.trailing)
                    .frame(maxWidth: controlPanelWidth)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: buttonSize)
                            .onChanged({ value in
                                print(1)
                                guard !self.isDraggingHandled else {
                                    return
                                }
                                guard abs(value.location.y - value.startLocation.y) < buttonSize else {
                                    return
                                }
                                self.isDraggingHandled = true
                                self.onDelete()
                            })
                            .onEnded({ _ in
                                self.isDraggingHandled = false
                            })
                )
                ControlsView(clickCallback: onControlPanelClick).padding(.bottom)
                Spacer()
            }
        }
    }
}
