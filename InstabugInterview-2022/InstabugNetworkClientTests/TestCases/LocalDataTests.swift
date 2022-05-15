//
//  LocalDataTests.swift
//  InstabugNetworkClientTests
//
//  Created by Amin on 14/05/2022.
//

import XCTest
@testable import InstabugNetworkClient
class LocalDataTests: XCTestCase {
    
    var sut: LocalDataManagerProtocol = ClientDataManager(local: CoreDataStack(type: .test))
    var exp:XCTestExpectation!
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
//        exp = nil
    }

    //MARK: Test Recording
    func testLocalDataManagerSaveSuccess(){
        exp = expectation(description: "wait")
        
        let hit = NetworkClientHitData.getDummyInstanceModel()
        sut.prepareForSave(networkData: hit) { savedModel in
            self.exp.fulfill()
            XCTAssertNotNil(savedModel)
        } onFinished: {}
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    //MARK: Test loading
    func testLocalDataManagerLoading(){
        exp = expectation(description: "wait")

        sut.getAllHits { result in
            switch result{
            case .failure(_):
                XCTFail()
            case .success(_):
                self.exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    //MARK: Test Respecting the limit of recording
    func testRespectingTheLimitOfRecording(){
        
        exp = expectation(description: "wait")
        
        let hit = NetworkClientHitData.getDummyInstanceModel()
        
        for _ in 1...Constants.RECORDE_LIMIT{ // 1...1001
            sut.prepareForSave(networkData: hit, onSaved: {_ in}) {
                self.sut.getAllHits { result in
                    switch result{
                    case .success(let hits):
                        print("Number of Hits \(hits.count)")
                        self.exp.fulfill()
                        XCTAssertEqual(hits.count, Constants.RECORDE_LIMIT - 1)
                    case .failure(_):
                        XCTFail()
                    }
                }
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //MARK: Test payload size
    func testPayloadLimit(){
        
        let exp = expectation(description: "wait")
        
        
        guard let url = Bundle.main.url(forResource: "image", withExtension: "jpg") else {return}
        guard let decodedImage = try? Data(contentsOf: url) else {fatalError("unable to encode")}
        
        let hit = NetworkClientHitData.getDummyInstanceModel(httpBody:decodedImage)
        sut.prepareForSave(networkData: hit) { savedData in
            
            exp.fulfill()
            guard let savedData = savedData else {return}
            guard let payload = savedData.requestPayloadBody else {return}
            guard let httpBody = String(data: payload, encoding: .utf8)  else {return}
            XCTAssertEqual(httpBody, Constants.PAYLOAD_MESSAGE)

        } onFinished: {}
        waitForExpectations(timeout: 5, handler: nil)
    }


}
