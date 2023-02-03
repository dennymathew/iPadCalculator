//
//  Calculator.swift
//  Calculator
//
//  Created by Denny on 01/02/23.
//

import Foundation

import Foundation

struct Calculator {
    private var selectedKey: KeyType? = nil
    private var result: Double = 0
    private var inputs: String =  ""
    private var isError = false
    private var isNegative = false
    private var lastInput: Double = 0
    private let maxInput = 9
    private let formatterUpperBreakPoint = 999999999.9
    private let formatterLowerBreakPoint = 0.000000001
    private let decimalFormatter = NumberFormatter()
    private let scientificFormatter = NumberFormatter()
    
    init() {
        decimalFormatter.numberStyle = .decimal
        decimalFormatter.groupingSeparator = ","
        decimalFormatter.maximumIntegerDigits = maxInput
        decimalFormatter.maximumSignificantDigits = maxInput + 1
        scientificFormatter.numberStyle = .scientific
        scientificFormatter.maximumSignificantDigits = maxInput + 1
    }
    
    var displayedValue: String {
        get {
            if isError && inputs.isEmpty {
                return "Error"
            } else if !inputs.isEmpty {
                var parsedInputs = Double(inputs) ?? 0
                guard parsedInputs != 0 else {
                    // e.g. -0.00003
                    if isNegative {
                        return "-" + inputs
                    } else {
                        return inputs
                    }
                }
                if isNegative {
                    parsedInputs.negate()
                }
                var formattedInputs = decimalFormatter.string(from: NSNumber(value: parsedInputs)) ?? "0"
                if inputs.last == "." {
                    formattedInputs += "."
                }
                return formattedInputs
            } else if inputs.isEmpty && isNegative {
                return "-0"
            } else if result != 0 {
                if abs(result) < formatterUpperBreakPoint && abs(result) > formatterLowerBreakPoint {
                    return decimalFormatter.string(from: NSNumber(value: result)) ?? "0"
                } else {
                    return scientificFormatter.string(from: NSNumber(value: result)) ?? "0"
                }
            } else {
                return "0"
            }
        }
    }
    
    var computedValue: Double {
        get {
            0
        }
    }
    
    mutating func onPressDigit(_ number: Int) {
        print("Input number", number)
        if inputs.isEmpty {
            if number != 0 {
                inputs.append(String(number))
            }
        } else if inputs.count >= maxInput {
            // discard any additional inputs if the pool is full
            // allow one digit if the last input is a dot
            if inputs.last == "." && inputs.count <= maxInput {
                inputs.append(String(number))
            }
        } else {
            inputs.append(String(number))
        }
    }
    
    mutating func onPressDot() {
        print("dot typed")
        guard !inputs.contains(".") else {
            return
        }
        if inputs.count >= maxInput {
            // discard if pool is full
        } else if inputs.isEmpty {
            inputs.append("0.")
        } else {
            inputs.append(".")
        }
    }
    
    mutating func onAC() {
        print("AC")
        self.result = 0
        self.inputs.removeAll()
        self.selectedKey = nil
        self.isNegative = false
        self.isError = false
        self.lastInput = 0
    }
    
    mutating func onPressOperator(_ selectedKey: KeyType) {
        print("operator", selectedKey)
        self.selectedKey = selectedKey
        let inputNumber = Double(inputs) ?? 0
        if inputNumber != 0 {
            result = inputNumber
        }
        inputs.removeAll()
    }
    
    mutating func onCalculate() {
        print("calculate")
        var inputNumber = Double(inputs) ?? 0
        if isNegative {
            inputNumber.negate()
        }
        
        isNegative = false
        inputs.removeAll()
        
        if inputNumber != 0 {
            lastInput = inputNumber
        }
        
        guard !isError else {
            return
        }
        
        switch selectedKey {
        case nil:
            result = lastInput
        case .plus:
            result += lastInput
        case .minus:
            result -= lastInput
        case .multiply:
            result *= lastInput
        case .divide:
            guard lastInput != 0 else {
                isError = true
                result = 0
                lastInput = 0
                return
            }
            result /= lastInput
        default:
            break
        }
    }
    
    mutating func onPlusMinus() {
        print("plusminus")
        if result != 0 {
            result = -result
        } else {
            self.isNegative.toggle()
        }
    }
    
    mutating func onPercentage() {
        print("percentage")
        lastInput = Double(inputs) ?? 0
        if isNegative {
            lastInput.negate()
        }
        
        isNegative = false
        inputs.removeAll()
        
        if lastInput != 0 {
            result = lastInput / 100
            lastInput = 0
        } else {
            result /= 100
        }
    }
    
    mutating func onDelete() {
        print("onDelete")
        guard !inputs.isEmpty else {
            return
        }
        _ = inputs.popLast()
        print(inputs)
    }
    
    mutating func onPaste(_ content: String) {
        var parsedContent: Double? = Double(content)
        guard parsedContent != nil else {
            return
        }
        if abs(parsedContent!) > formatterUpperBreakPoint || abs(parsedContent!) < formatterLowerBreakPoint {
            result = parsedContent!
        } else {
            if parsedContent! < 0 {
                isNegative = true
                parsedContent?.negate()
            }
            inputs = String(parsedContent!).trimmingCharacters(in: CharacterSet.init(charactersIn: ".0"))
        }
        isError = false
    }
    
    private mutating func recordAns() {
        result = Double(inputs) ?? 0
        if isNegative {
            isNegative = false
            result = -result
        }
        markNoError()
    }
    
    private mutating func markNoError() {
        self.isError = false
    }
}
