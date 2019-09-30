//
//  MockURLSession.swift
//  RevolutTests
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import Foundation
@testable import Revolut

class MockURLSession: URLSessionProtocol {
    
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    
    private (set) var lastURL: URL?
    
    func successHttpURLResponse(url: URL) -> URLResponse {
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = url
        completionHandler(nextData, successHttpURLResponse(url: lastURL!), nextError)
        return nextDataTask
    }
    
}
