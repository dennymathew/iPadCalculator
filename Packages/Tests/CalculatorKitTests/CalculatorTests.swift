//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Denny on 01/02/23.
//

import XCTest
@testable import CalculatorKit

final class CalculatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCalculatedResultForAddition() {
        var calc = Calculator()
        calc.onPressDigit(5)
        calc.onPressDot()
        calc.onPressDigit(7)
        calc.onPressOperator(.plus)
        calc.onPressDigit(4)
        calc.onPressDot()
        calc.onPressDigit(3)
        calc.onCalculate()
        XCTAssertEqual(calc.displayedValue, "10")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
