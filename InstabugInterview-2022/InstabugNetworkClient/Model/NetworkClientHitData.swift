//
//  NetworkClientHitData.swift
//  InstabugNetworkClient
//
//  Created by Aminon 14/05/2022.
//

import Foundation

struct NetworkClientHitData{
    let url:URL
    let urlRequest:URLRequest
    let urlResponse:HTTPURLResponse?
    let responsePayload:Data?
    let error:NSError?
    let status:ResponseStatus
    
    static func getDummyInstanceModel(httpBody:Data? = nil)->NetworkClientHitData{
        let url = EndPoint.get.asUrl()
        
        guard let requestPayload = httpBody else {
            return NetworkClientHitData(url: url, urlRequest: URLRequest(url: url), urlResponse: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil), responsePayload: Data(count: 1024), error: nil, status: .Success)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = requestPayload
        return NetworkClientHitData(url: url, urlRequest: urlRequest, urlResponse: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil), responsePayload: nil, error: nil, status: .Success)
    }
}
