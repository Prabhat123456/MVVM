//
//  MockURLSessionDataTask.swift
//  RevolutTests
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import Foundation
@testable import Revolut

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    private (set) var cancelWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
    
    func cancel(){
        cancelWasCalled = true
    }
}
