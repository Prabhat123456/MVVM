//
//  APIClientTests.swift
//  RevolutTests
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import XCTest
import CoreData
@testable import Revolut

class APIClientTests: XCTestCase {
    
    var sut : APIClient!
    var session:MockURLSession!
    
    override func setUp() {
        super.setUp()
        session = MockURLSession()
        sut = APIClient(session: session)
        
    }
    
    override func tearDown() {
        super.tearDown()
        session = nil
        sut = nil
    }
    
    func testtFetchExchangeRatesWithSuccessResponse(){
        let fakeJson = ["GBPINR":1.2345] as [String : Double]
        let jsonData = try? JSONSerialization.data(withJSONObject: fakeJson, options: .init(rawValue: 0))
        session.nextData = jsonData
        
        sut.fetchExchangeRates(forCountries: ["test"]) { (value, model, error) in
            XCTAssert(model.count == 1)
            XCTAssertEqual(value, true)
            XCTAssertEqual(model.first?.fromAndToCurrencySymbol, "GBPINR")
            XCTAssertEqual(model.first?.rates, 1.2345)
        }
    }
    
    func testtFetchExchangeRatesWithFailureResponse(){
        session.nextData = nil
        sut.fetchExchangeRates(forCountries: ["test"]) { (value, model, error) in
            XCTAssertEqual(value, false)
        }
    }
    
    func testFetchCurrencyListWithCountryName(){
        sut.fetchCurrencyListWithCountryName() { (value, model, error) in
            XCTAssert(model.count > 0)
            XCTAssertNil(error)
        }
    }

}
