//
//  DashBoardVMTests.swift
//  RevolutTests
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import XCTest
import CoreData
@testable import Revolut

class DashBoardVMTests: XCTestCase {
    var sut : DashBoardVM!
    var mockAPIClient : MockAPIClient!
    var mockDBOperation:MockDBOperation!
    var completion :((([Any]?)) -> ())?
    
    override func setUp() {
        mockAPIClient = MockAPIClient()
        sut = DashBoardVM(apiClient: mockAPIClient)
        mockDBOperation = MockDBOperation()
        sut.dbOperation = mockDBOperation
        mockAPIClient.key = "testFromSymboltestToymbol"
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        mockDBOperation.cleanDB()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testFetchCurrencyList() {
        sut.reloadTableView = {[weak self] in
            self?.sut.cancelDispatchTimer()
            XCTAssertEqual((self?.sut.dashBoard.first?.fromCurrency)?.keys.first, "fakeFromSymbol")
        }
        mockDBOperation.fromAndToCurrencySymbol = "testFromSymboltestToymbol"
        sut.fetchCurrencyList()
    }
    
    func testNumberOfCells(){
        sut.reloadTableView = {[weak self] in
            self?.sut.cancelDispatchTimer()
            XCTAssertEqual(self?.sut.numberOfCells(), 1)
        }
        mockDBOperation.fromAndToCurrencySymbol = "testFromSymboltestToymbol"
        sut.fetchCurrencyList()
    }
    
    func testCellModelAtIndexPath(){
        sut.reloadTableView = {[weak self] in
            self?.sut.cancelDispatchTimer()
            let value = self?.sut.cellModel(at: [0,0])
            XCTAssertEqual((value?.fromCurrency)?.keys.first, "fakeFromSymbol")
        }
         mockDBOperation.fromAndToCurrencySymbol = "testFromSymboltestToymbol"
        sut.fetchCurrencyList()
    }
}
