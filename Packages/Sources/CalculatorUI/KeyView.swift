//
//  Key.swift
//  Calculator
//
//  Created by Denny on 01/02/23.
//

import SwiftUI
import CalculatorKit

enum KeyShape {
    case circle
    case ellips
}

struct KeyView: View {
    
    var text: String = ""
    var image: Image?
    var bg: Color = .gray
    var fg: Color = .white
    var bgSelected: Color?
    var fgSelected: Color?
    
    var horizontalSpan: CGFloat = 1.0
    var keyType: KeyType
    
    @Binding var selectedKey: KeyType?
    var callback: ((KeyType) -> Void)?
    
    @State private var isPressed: Bool = false
    
    private var spannedWidth: CGFloat {
        get {
            buttonSize * horizontalSpan + (horizontalSpan - 1) * buttonGapSize
        }
    }
    
    // computed bool that indicates if BG/FG color should be inverted
    // if type is operator and is selected then it should invert
    private var shouldInvertColor: Bool {
        get {
            switch keyType {
            case .divide, .multiply, .plus, .minus:
                return selectedKey == keyType
            default:
                return false
            }
        }
    }
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            // by default the background is a circle when the span is 1
            // if the span is more than 1, it becomes a rectangle with half circles on the left and right
            Text("")
                .cornerRadius(buttonSize / 2)
                .frame(width: spannedWidth, height: buttonSize)
                .background(shouldInvertColor ? fg : self.isPressed ? (bgSelected ?? bg) : bg)
                .animation(shouldInvertColor ? .spring() : self.isPressed ? nil : .spring(), value: 2)
                .cornerRadius(buttonSize / 2)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ (touch) in
                            let isOutsideView = (touch.location.y < 0 || touch.location.x < 0 || touch.location.y > buttonSize || touch.location.x > self.spannedWidth)
                            let isInsideView = (touch.location.y >= 0 && touch.location.x >= 0 && touch.location.y <= buttonSize && touch.location.x <= self.spannedWidth)
                            if self.isPressed && isOutsideView {
                                self.onMoveOutView()
                            } else if !self.isPressed && isInsideView {
                                self.onMoveIntoView()
                            }
                        })
                        .onEnded({ (touch) in
                            self.onMoveEnd()
                        })
                )
            Group {
                // use image if given, otherwise use text
                // dont think too much about these magic numbers, they are adjusted to fit the sizes of images and texts so that they look like to have a same size
                if image != nil {
                    image?
                        .resizable()
                        .scaledToFit()
                        .frame(width: buttonSize / 3, height: buttonSize / 3)
                        .padding(buttonSize / 3)
                        .foregroundColor(shouldInvertColor ? bg : fg)
                        .animation(.spring(), value: 2)
                    
                } else {
                    Text(text)
                        .frame(width: buttonSize / 2, height: buttonSize / 2)
                        .font(.system(size: 500))
                        .minimumScaleFactor(0.01)
                        .padding(buttonSize / 4)
                        .foregroundColor(shouldInvertColor ? bg : fg)
                        .animation(.spring(), value: 2)
                }
            }
        }
    }
    
    // figure moves out of button display area
    private func onMoveIntoView() {
        self.isPressed = true
    }
    
    // figure moves into button display area
    private func onMoveOutView() {
        self.isPressed = false
    }
    
    // move ended, if figure is inside button display area, call the callback function. Reset is touching to false
    private func onMoveEnd() {
        if self.isPressed {
            self.callback?(self.keyType)
        }
        self.isPressed = false
    }
}

struct KeyView_Previews: PreviewProvider {
    static var previews: some View {
        KeyView(keyType: .digit1, selectedKey: .constant(.digit1))
    }
}
