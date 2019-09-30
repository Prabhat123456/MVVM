//
//  ExchangeRateTests.swift
//  RevolutTests
//
//  Created by Philips on 25/09/19.
//  Copyright © 2019 Prabhat. All rights reserved.
//

import XCTest
@testable import Revolut


class DashboardTests: XCTestCase {
    
    var sut: Dashboard!
    override func setUp() {
        sut = Dashboard(fromCurrency: ["testKey":"testValue"], toCurrency:["tokey":"toValue"])
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIntialization() {
        XCTAssertEqual(sut.fromCurrency?.keys.first, "testKey")
        XCTAssertEqual(sut.fromCurrency?.values.first, "testValue")
        XCTAssertEqual(sut.toCurrency?.keys.first, "tokey")
        XCTAssertEqual(sut.toCurrency?.values.first, "toValue")
    }
    
}
