//
//  CoreDataStack + LocalDataSource.swift
//  InstabugNetworkClient
//
//  Created by Amin on 14/05/2022.
//

import CoreData


extension CoreDataStack:LocalDataSourceProtocol{
    func saveNewHit(hit: ApiHit, completion:@escaping (ApiHit?) -> () = {_ in }) {
        
        backgroundContext.perform {

            let new = Hit(context: self.backgroundContext)
            new.httpMethod = hit.httpMethod
            new.createdAt = hit.createdAt
            new.url = hit.url
            new.code = NSDecimalNumber(decimal: Decimal(hit.code ?? Constants.ERROR_CODE))
            new.requestPayloadBody = hit.requestPayloadBody
            new.responsePayload = hit.responsePayload
            new.status = hit.status.rawValue
            new.errorDomain = hit.errorDomain
            
            do{
                try self.backgroundContext.save()
                let apiHit = ApiHit(httpMethod: hit.httpMethod, url: hit.url, requestPayloadBody: new.requestPayloadBody, status: hit.status, responsePayload: new.responsePayload, code: hit.code, errorDomain: hit.errorDomain, createdAt: hit.createdAt)
                self.mainContext.perform {
                    completion(apiHit)
                }
            }catch{
                completion(nil)
            }
        }
        
    }
    
    func getAllHits(completion: @escaping (Result<[ApiHit], LocalDataRetreiveError>) -> ()) {
        backgroundContext.perform{
            let fetchReq:NSFetchRequest<Hit> = Hit.fetchRequest()
            do{
                let allReq = try fetchReq.execute()
                var hits : [ApiHit] = []
                allReq.forEach { hit in
                    
                    guard let httpMethod = hit.httpMethod,let url = hit.url,let stat = hit.status,let status = ResponseStatus(rawValue: stat) , let createdAt = hit
                            .createdAt,let responsePayload = hit.responsePayload else {return}
                    
                    let loadedHit = ApiHit(httpMethod: httpMethod, url: url, requestPayloadBody: hit.requestPayloadBody , status: status , responsePayload: responsePayload , code: hit.code?.intValue, errorDomain: hit.errorDomain, createdAt: createdAt)
                    
                    hits.append(loadedHit)
                }
                self.mainContext.perform {
                    completion(.success(hits))
                }
            }catch{
                completion(.failure(.retrieveError))
            }
        }
    }
    func removeFirstHit(completion:@escaping  () -> () = {}) {
        backgroundContext.performAndWait {

            self.fetchFirstHit { hit in
                guard let hit = hit else {
                    return
                }
                self.backgroundContext.delete(hit)
                print("record number \(Constants.RECORDE_LIMIT) deleted")
                do{
                    try self.backgroundContext.save()
                }catch{}
                self.mainContext.perform {
                    completion()
                }
            }
        }
    }
    
    private func fetchFirstHit(completion:@escaping (Hit?)->()){
        backgroundContext.perform {
            let req:NSFetchRequest<Hit> = Hit.fetchRequest()
            req.fetchLimit = 1
            req.fetchOffset = 0
            do{
                let hit = try req.execute()

                self.mainContext.perform {
                    completion(hit.first)
                }
            }catch{
                self.mainContext.perform {
                    completion(nil)
                }
            }
        }
    }
    
    
}
