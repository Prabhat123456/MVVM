//
//  DBOperationTests.swift
//  RevolutTests
//
//  Copyright © 2019 Prabhat. All rights reserved.
//

import XCTest
import CoreData
@testable import Revolut

class DBOperationTests: XCTestCase {

    private var sut : DBOperation!
    private var mockDBOperation: MockDBOperation!
    private var completion :((([Any]?)) -> ())?
    private var value = [Any]()
    private var fetchExpectaction: XCTestExpectation?
    
    
    override func setUp() {
        sut = DBOperation()
        mockDBOperation = MockDBOperation()
        sut.persistentContainer = mockDBOperation.mockPersistantContainer
    }
    
    override func tearDown() {
        mockDBOperation.cleanDB()
        sut = nil
        mockDBOperation = nil
    }
    
    func testSystemUnderTestIsNotNil(){
        XCTAssertNotNil(sut)
    }
    
    func testPersistentContainer() {
        XCTAssertNotNil(sut.persistentContainer)
    }
    
    func testFetchingOfDB(){
        fetchExpectaction =  expectation(description: "fetchExpectaction")
        self.completion = { value  in
            self.value = value!
            self.fetchExpectaction?.fulfill()
        }
        mockDBOperation.saveFromToCurrencyMapper()
        sut.fetchData(forTheEntity: "FromAndToCurrencyMapper", completion: completion!)
        waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
            XCTAssert(self.value.count > 0)
        }
    }
    
    func testGetNewEntity(){
        let value = sut.getNewEntity(forTable: "FromAndToCurrencyMapper")
        XCTAssertNotNil(value)
    }
    
    func testGetNewEntityWithWrongTableName(){
        let value = sut.getNewEntity(forTable: "Improper")
        XCTAssertNil(value)
    }
}
