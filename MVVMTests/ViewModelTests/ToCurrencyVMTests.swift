//
//  ToCurrencyVMTests.swift
//  RevolutTests
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import XCTest
import CoreData
@testable import Revolut


class ToCurrencyVMTests: XCTestCase {

    var sut: ToCurrencyVM!
    var mockAPIClient : MockAPIClient!
    var mockDBOperation:MockDBOperation!
   
    
    override func setUp() {
        mockAPIClient = MockAPIClient()
        mockDBOperation = MockDBOperation()
        sut = ToCurrencyVM(apiClient: mockAPIClient)
        sut.dbOperation = mockDBOperation
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        mockDBOperation.cleanDB()
        mockAPIClient = nil
        mockDBOperation = nil
        sut = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDidShow(){
        let countryCurrencyModel = Currency(symbol: "test", country: "test", flagImage: "test")
        sut.didSelected(currency: countryCurrencyModel)
        XCTAssertEqual(sut.selectedCurrency?.symbol, "test")
        XCTAssertEqual(sut.selectedCurrency?.country, "test")
        XCTAssertEqual(sut.selectedCurrency?.flagImage, "test")
    }
    
    func testGetPreviousConvertedCurrency() {
        let countryCurrencyModel = Currency(symbol: "fakeFromSymbol", country: "fakeFromCountry", flagImage: "testFromflagImage")
        sut.selectedCurrency = countryCurrencyModel
        sut.getPreviousConvertedCurrency()
        XCTAssertEqual((sut.fromAndToCurrencyMapper?.first?.fromCurrency as? Currency)?.symbol, "fakeFromSymbol")
          XCTAssertEqual((sut.fromAndToCurrencyMapper?.first?.fromCurrency as? Currency)?.country, "fakeFromCountry")
          XCTAssertEqual((sut.fromAndToCurrencyMapper?.first?.fromCurrency as? Currency)?.flagImage, "fakeFromFlagImage")
          XCTAssertEqual((sut.fromAndToCurrencyMapper?.first?.toCurrency as? Currency)?.symbol, "fakeToSymbol")
          XCTAssertEqual((sut.fromAndToCurrencyMapper?.first?.toCurrency as? Currency)?.country, "fakeToCountry")
          XCTAssertEqual((sut.fromAndToCurrencyMapper?.first?.toCurrency as? Currency)?.flagImage, "fakeToFlagImage")
    }
    
    func testCellModelForDisableFalse(){
        let countryCurrencyModel = Currency(symbol: "test", country: "test", flagImage: "test")
        sut.currency = [countryCurrencyModel]
        let model = sut.cellModel(at: [0,0])
        XCTAssertFalse(model.isDisabled)
    }
    
    func testCellModelForDisableTrue(){
        var countryCurrencyModel = Currency(symbol: "testFromSymbol", country: "testFromCountry", flagImage: "testFromflagImage")
        sut.selectedCurrency = countryCurrencyModel
        mockDBOperation.saveFromToCurrencyMapper()
        sut.getPreviousConvertedCurrency()
        countryCurrencyModel = Currency(symbol: "testToymbol", country: "testToCountry", flagImage: "testToflagImage")
        sut.selectedCurrency = countryCurrencyModel
        sut.currency = [countryCurrencyModel]
        let model = sut.cellModel(at: [0,0])
        XCTAssertTrue(model.isDisabled)
    }
    
    func testSaveMappingInDB(){
        let countryCurrencyModel = Currency(symbol: "fromCountrySymbol", country: "fromCountry", flagImage: "testingSaving")
        let countryCurrency = Currency(symbol: "toCountrySymbol", country: "toCountry", flagImage: "testingSaving")
        sut.currency = [countryCurrencyModel]
        sut.selectedCurrency = countryCurrency
        sut.selectedCell(at: [0,0])
        mockDBOperation.fetchData(forTheEntity: "CurrencyConversionMappers") { (value) in
            XCTAssertEqual((value?.first as? FromAndToCurrencyMapper)?.fromAndToCurrencySymbol, "toCountrySymbolfromCountrySymbol")
        }
    }
    
}
