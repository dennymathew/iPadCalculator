//
//  ControlsView.swift
//  Calculator
//
//  Created by Denny on 01/02/23.
//

import SwiftUI

// the size and gap of buttons, to be calculated in run time based on screen size
// the strategy to calculate the size of buttons, is to find the shortest side of the screen (height or width) and divide the total screen length by 7 (5 row of buttons + 2 rows of spacing)
var buttonGapSize: CGFloat = (UIScreen.main.bounds.height > UIScreen.main.bounds.width) ?
(UIScreen.main.bounds.width / 50) :
(UIScreen.main.bounds.height / 50)
var buttonSize: CGFloat = (UIScreen.main.bounds.height > UIScreen.main.bounds.width) ?
((UIScreen.main.bounds.width - 4 * buttonGapSize) / 7):
((UIScreen.main.bounds.height - 4 * buttonGapSize) / 7)

var controlPanelWidth = 4 * buttonSize + 3 * buttonGapSize

// add a initialiser by hex color
// https://stackoverflow.com/a/56894458/12208834
extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}

struct ControlsView: View {
    var clickCallback: ((KeyType) -> Void)?
    
    // colours
    private let BGGray = Color(hex: 0xa5a5a5)
    private let BGHoverGray = Color(hex: 0xd9d9d9)
    
    private let BGDarkGray = Color(hex: 0x333333)
    private let BGHoverDarkGray = Color(hex: 0x737373)
    
    private let BGOrange = Color(hex: 0xff9f06)
    private let BGHoverOrange = Color(hex: 0xfcc88d)
    
    private let FGWhite = Color(.white)
    private let FGBlack = Color(.black)
    
    // the operator that is selected. nil if not selecting
    @State private var selectedKey: KeyType? = nil
    
    var body: some View {
        // here are a list of 5 rows of buttons, each row of button includes the specific buttons, and defines their symbol, colors and all of its properties
        VStack(spacing: buttonGapSize) {
            row1()
            row2()
            row3()
            row4()
            row5()
        }
    }
    
    // callback function for buttons on click
    private func onButtonClick(_ keyType: KeyType) -> Void {
        switch keyType {
        case .divide, .multiply, .minus, .plus:
            self.selectedKey = keyType
        case .equals:
            self.selectedKey = nil
        default:
            break
        }
        self.clickCallback?(keyType)
    }
    
    @ViewBuilder
    private func row1() -> some View {
        HStack(spacing: buttonGapSize) {
            KeyView(text: "AC", bg: BGGray, fg: FGBlack, bgSelected: BGHoverGray, keyType: KeyType.clear, selectedKey: $selectedKey, callback: onButtonClick)
            KeyView(image: Image(systemName: "plus.slash.minus"), bg: BGGray, fg: FGBlack, bgSelected: BGHoverGray, keyType: KeyType.negator, selectedKey: $selectedKey, callback: onButtonClick)
            KeyView(text: "%", bg: BGGray, fg: FGBlack, bgSelected: BGHoverGray, keyType: KeyType.percentage, selectedKey: $selectedKey, callback: onButtonClick)
            KeyView(image: Image(systemName: "divide"), bg: BGOrange, fg: FGWhite, bgSelected: BGHoverOrange, keyType: KeyType.divide, selectedKey: $selectedKey, callback: onButtonClick)
        }
    }
    
    @ViewBuilder
    private func row2() -> some View {
        HStack(spacing: buttonGapSize) {
            KeyView(text: "7", bg: BGDarkGray, fg: FGWhite, bgSelected: BGHoverDarkGray, keyType: KeyType.digit7, selectedKey: $selectedKey, callback: onButtonClick)
            KeyView(text: "8", bg: BGDarkGray, fg: FGWhite, bgSelected: BGHoverDarkGray, keyType: KeyType.digit8, selectedKey: $selectedKey, callback: onButtonClick)
            KeyView(text: "9", bg: BGDarkGray, fg: FGWhite, bgSelected: BGHoverDarkGray, keyType: KeyType.digit9, selectedKey: $selectedKey, callback: onButtonClick)
            KeyView(image: Image(systemName: "multiply"), bg: BGOrange, fg: FGWhite, bgSelected: BGHoverOrange, keyType: KeyType.multiply, selectedKey: $selectedKey, callback: onButtonClick)
        }
    }
    
    @ViewBuilder
    private func row3() -> some View {
        HStack(spacing: buttonGapSize) {
            KeyView(text: "4", bg: BGDarkGray, fg: FGWhite, bgSelected: BGHoverDarkGray, keyType: KeyType.digit4, selectedKey: $selectedKey, callback: onButtonClick)
            KeyView(text: "5", bg: BGDarkGray, fg: FGWhite, bgSelected: BGHoverDarkGray, keyType: KeyType.digit5, selectedKey: $selectedKey, callback: onButtonClick)
            KeyView(text: "6", bg: BGDarkGray, fg: FGWhite, bgSelected: BGHoverDarkGray, keyType: KeyType.digit6, selectedKey: $selectedKey, callback: onButtonClick)
            KeyView(image: Image(systemName: "minus"), bg: BGOrange, fg: FGWhite, bgSelected: BGHoverOrange, keyType: KeyType.minus, selectedKey: $selectedKey, callback: onButtonClick)
        }
    }
    
    @ViewBuilder
    private func row4() -> some View {
        HStack(spacing: buttonGapSize) {
            KeyView(text: "1", bg: BGDarkGray, fg: FGWhite, bgSelected: BGHoverDarkGray, keyType: KeyType.digit1, selectedKey: $selectedKey, callback: onButtonClick)
            KeyView(text: "2", bg: BGDarkGray, fg: FGWhite, bgSelected: BGHoverDarkGray, keyType: KeyType.digit2, selectedKey: $selectedKey, callback: onButtonClick)
            KeyView(text: "3", bg: BGDarkGray, fg: FGWhite, bgSelected: BGHoverDarkGray, keyType: KeyType.digit3, selectedKey: $selectedKey, callback: onButtonClick)
            KeyView(image: Image(systemName: "plus"), bg: BGOrange, fg: FGWhite, bgSelected: BGHoverOrange, keyType: KeyType.plus
                    , selectedKey: $selectedKey, callback: onButtonClick)
        }
    }
    
    @ViewBuilder
    private func row5() -> some View {
        HStack(spacing: buttonGapSize) {
            KeyView(text: "0", bg: BGDarkGray, fg: FGWhite, bgSelected: BGHoverDarkGray, horizontalSpan: 2, keyType: KeyType.digit0, selectedKey: $selectedKey, callback: onButtonClick)
            KeyView(text: ".", bg: BGDarkGray, fg: FGWhite, bgSelected: BGHoverDarkGray, keyType: KeyType.dot, selectedKey: $selectedKey, callback: onButtonClick)
            KeyView(image: Image(systemName: "equal"), bg: BGOrange, fg: FGWhite, bgSelected: BGHoverOrange, keyType: KeyType.equals, selectedKey: $selectedKey, callback: onButtonClick)
        }
    }
}


struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView()
    }
}
