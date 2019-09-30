//
//  CurrencyTests.swift
//  RevolutTests
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import XCTest
@testable import Revolut

class CurrencyTests: XCTestCase {

    var sut: Currency!
    override func setUp() {
        sut = Currency(symbol: "testSymbol", country: "testCountry", flagImage: "testFlag")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIntialization() {
        XCTAssertEqual(sut.country, "testCountry")
        XCTAssertEqual(sut.symbol, "testSymbol")
        XCTAssertEqual(sut.flagImage, "testFlag")
    }

}
