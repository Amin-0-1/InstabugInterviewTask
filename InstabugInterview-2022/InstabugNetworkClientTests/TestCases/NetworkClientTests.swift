//
//  InstabugNetworkClientTests.swift
//  InstabugNetworkClientTests
//
//  Created by Yousef Hamza on 1/13/21.
//

import XCTest
@testable import InstabugNetworkClient
class NetworkClientTests: XCTestCase {
    
    var sut:NetworkClient = NetworkClient(cachMethod: .memory)
    var exp : XCTestExpectation!
    
    override func setUpWithError() throws {
//        sut =
    }

    override func tearDownWithError() throws {
//        sut = nil
        exp = nil
    }
//
    func testGetMethod(){
        let exp = expectation(description: "testGetMethod")

        sut.get(Helper.URL_GET) { data in
            exp.fulfill()
            XCTAssertNotNil(data)
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPostMethod(){
        exp = expectation(description: "testPostMethod")
        
        sut.post(Helper.URL_POST, payload: nil) { data in
            self.exp.fulfill()
            guard let data = data else {fatalError("an error")}
            
            guard let decoded = try? JSONDecoder().decode(PostResponse.self, from: data) else {return}
            XCTAssertEqual(decoded.origin,Helper.IP)
        }
        waitForExpectations(timeout: 2, handler: nil)
        
    }
}
