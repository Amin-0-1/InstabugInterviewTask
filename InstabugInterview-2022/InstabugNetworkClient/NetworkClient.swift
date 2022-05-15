//
//  NetworkClient.swift
//  InstabugNetworkClient
//
//  Created by Yousef Hamza on 1/13/21.
//

import Foundation

public class NetworkClient {
//    public static var shared = NetworkClient()
    private var manager : ClientDataManager!
    

    public init(cachMethod:CacheMethod){
        let type:CoreDataStackType = (cachMethod == .memory) ? .test  : .prod
        manager = ClientDataManager(local: CoreDataStack(type: type))
    }
    // MARK: Network requests
    public func get(_ url: URL, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "GET", payload: nil, completionHandler: completionHandler)
    }

    public func post(_ url: URL, payload: Data?=nil, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "POSt", payload: payload, completionHandler: completionHandler)
    }

    public func put(_ url: URL, payload: Data?=nil, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "PUT", payload: payload, completionHandler: completionHandler)
    }
    public func delete(_ url: URL, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "DELETE", payload: nil, completionHandler: completionHandler)
    }

    private func executeRequest(_ url: URL, method: String, payload: Data?, completionHandler: @escaping (Data?) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.httpBody = payload
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            

            var networkClientHit:NetworkClientHitData
            if let httpResponse = urlResponse as? HTTPURLResponse{
                
                switch httpResponse.statusCode{
                case Constants.SUCCESS_CODE:
                    networkClientHit = NetworkClientHitData(url: url, urlRequest: urlRequest, urlResponse: httpResponse, responsePayload: data, error: nil, status: .Success)
                default:
                    guard let error = error as NSError? else {return}

                    networkClientHit = NetworkClientHitData(url: url, urlRequest: urlRequest, urlResponse: httpResponse, responsePayload: data, error: error, status: .Failure)
                }
                
            }else{
                let error = (error as NSError?)
                networkClientHit = NetworkClientHitData(url: url, urlRequest: urlRequest, urlResponse: nil, responsePayload: data, error: error, status: .ConnectionError)
            }

            self.manager.prepareForSave(networkData: networkClientHit) { hit in
                 completionHandler(data)
            } onFinished: {}

        }.resume()
    }

    // MARK: Network recording
    public func allNetworkRequests(completion:@escaping([ApiHit])->()) {
        manager.getAllHits { result in
            switch result{
            case .success(let hits):
                completion(hits)
            case .failure(_):
                completion([])
            }
        }
    }
}
