//
//  LocalDataManager.swift
//  InstabugNetworkClient
//
//  Created by Amin on 12/05/2022.
//

import Foundation

protocol LocalDataManagerProtocol{
    func prepareForSave(networkData: NetworkClientHitData,onSaved:@escaping (ApiHit?)->(),onFinished:@escaping ()->())
    func getAllHits(completion:@escaping(Result<[ApiHit],LocalDataRetreiveError>)->())
}

public class ClientDataManager:LocalDataManagerProtocol{
//    private let localDataStore:LocalDataSourceProtocol

    private let localDataSource:CoreDataStack!
    private var recordsCount:Int
    init(local:CoreDataStack){
        self.localDataSource = local
        recordsCount = 0
    }
    
    func prepareForSave(networkData: NetworkClientHitData,onSaved:@escaping (ApiHit?)->() = {_ in} ,onFinished:@escaping ()->() = {}) {
        recordsCount += 1
        
        guard let httpMethod = networkData.urlRequest.httpMethod else {return}
        
        var requestPayload:Data? = nil
        var responsePayload:Data? = nil
        if let requestPayloadBody = networkData.urlRequest.httpBody{
            requestPayload = (requestPayloadBody.byteSize > Constants.ONE_MEGA_BYTE) ?  Data(Constants.PAYLOAD_MESSAGE.utf8) : requestPayloadBody
        }
        if let responsePayloadBody = networkData.responsePayload{
            responsePayload = (responsePayloadBody.byteSize > Constants.ONE_MEGA_BYTE) ?  Data(Constants.PAYLOAD_MESSAGE.utf8) : responsePayloadBody
        }
        
        var hit:ApiHit
        switch networkData.status{
        case .Success:
            hit = ApiHit(httpMethod: httpMethod, url: networkData.url.absoluteString, requestPayloadBody: requestPayload, status: networkData.status, responsePayload: responsePayload, code: networkData.urlResponse?.statusCode, errorDomain: nil, createdAt: Date())
        case .Failure:
            hit = ApiHit(httpMethod: httpMethod, url: networkData.url.absoluteString, requestPayloadBody: requestPayload, status: networkData.status, responsePayload: responsePayload, code: networkData.urlResponse?.statusCode, errorDomain: networkData.error?.domain, createdAt: Date())
        case .ConnectionError:
            hit = ApiHit(httpMethod: httpMethod, url: networkData.url.absoluteString, requestPayloadBody: requestPayload, status: networkData.status, responsePayload: responsePayload, code: networkData.error?.code, errorDomain: networkData.error?.domain, createdAt: Date())
        }
        

            self.localDataSource.saveNewHit(hit: hit, completion: onSaved)
            print("count, \(self.recordsCount)")
            if self.recordsCount == Constants.RECORDE_LIMIT{
                print("limit")
                self.removeFirstRecord {onFinished()}
            }
    }
    
    func getAllHits(completion: @escaping (Result<[ApiHit], LocalDataRetreiveError>) -> ()) {
        self.localDataSource.getAllHits(completion: completion)
    }
    
    private func removeFirstRecord(completion:@escaping ()->() = {}){
        self.localDataSource.removeFirstHit(completion: completion)
    }
}
