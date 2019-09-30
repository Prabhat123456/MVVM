//
//  ExchangeRateTests.swift
//  RevolutTests
//
//  Created by Philips on 25/09/19.
//  Copyright © 2019 Prabhat. All rights reserved.
//

import XCTest
@testable import Revolut


class ExchangeRateTests: XCTestCase {
    
    var sut: ExchangeRate!
    override func setUp() {
        sut = ExchangeRate(fromAndToCurrencySymbol: "testfromAndToCurrencySymbol", rates:1.0)
      // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIntialization() {
        XCTAssertEqual(sut.fromAndToCurrencySymbol, "testfromAndToCurrencySymbol")
        XCTAssertEqual(sut.rates, 1.0)
    }
    
}
