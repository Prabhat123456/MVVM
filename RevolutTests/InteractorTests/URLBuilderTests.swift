//
//  URLBuilderTests.swift
//  RevolutTests
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import XCTest
@testable import Revolut

class URLBuilderTests: XCTestCase {

    var query:String!
    override func setUp() {
        query = "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios/"
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        query = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetQuery(){
        let firstCountry = "test1"
        let secondCountry = "test2"
        let thirdCountry = "test3"
        let queryFromSUT =  URLBuilder.getURL(forCountries: [firstCountry,secondCountry,thirdCountry])
        let hardCodedQuery = query + "?pairs=\(firstCountry)&pairs=\(secondCountry)&pairs=\(thirdCountry)"
        XCTAssertEqual(URL(string: hardCodedQuery), queryFromSUT)
    }
}
