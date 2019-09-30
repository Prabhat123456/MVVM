//
//  FromCurrencyVMTests.swift
//  RevolutTests
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import XCTest
@testable import Revolut

class FromCurrencyVMTests: XCTestCase {
    var sut : FromCurrencyVM!
    var mockAPIClient : MockAPIClient!
    var mockDisplayCurrency: MockDisplayCurrency!
    
    override func setUp() {
        mockAPIClient = MockAPIClient()
        mockDisplayCurrency = MockDisplayCurrency()
        sut = FromCurrencyVM(apiClient: mockAPIClient)
        sut.fromCurrencySelectedProtocol = mockDisplayCurrency
        mockAPIClient.countryCurrencyModel = Currency(symbol: "test", country: "test", flagImage: "test")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        mockAPIClient = nil
        mockDisplayCurrency = nil
        sut = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchCurrencyList() {
        sut.fetchCurrencyList()
        sut.reloadTableView = {[weak self] in
            XCTAssertEqual(self?.sut.currency.first?.symbol, "test")
            XCTAssertEqual(self?.sut.currency.first?.country, "test")
            XCTAssertEqual(self?.sut.currency.first?.flagImage, "test")
        }
    }
    
    
    
    func testNumberOfCells(){
        sut.fetchCurrencyList()
        sut.reloadTableView = {[weak self] in
             XCTAssertEqual(self?.sut.numberOfCells(), 1)
        }
    }
    
    func testCellModelAtIndexPath(){
        sut.fetchCurrencyList()
        sut.reloadTableView = {[weak self] in
            let value = self?.sut.cellModel(at: [0,0])
            XCTAssertEqual(value!.symbol, "test")
            XCTAssertEqual(value!.country, "test")
            XCTAssertEqual(value!.flagImage, "test")
        }
    }
    
    func testSelectedCell(){
        sut.fetchCurrencyList()
        sut.reloadTableView = {[weak self] in
            XCTAssertEqual(self?.mockDisplayCurrency.didShowCalled, false)
            self?.sut.selectedCell(at: [0,0])
            XCTAssertEqual(self?.mockDisplayCurrency.didShowCalled, true)
        }
    }
    
}

class MockDisplayCurrency: FromCurrencySelectedProtocol {
    var didShowCalled = false
    func didSelected(currency: Currency) {
         didShowCalled = true
    }
}

