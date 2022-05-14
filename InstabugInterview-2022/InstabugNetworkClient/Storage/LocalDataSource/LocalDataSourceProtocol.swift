//
//  LocalDataSourceProtocol.swift
//  InstabugNetworkClient
//
//  Created by Amin on 14/05/2022.
//

import Foundation

protocol LocalDataSourceProtocol{
    func saveNewHit(hit:ApiHit,completion:@escaping (ApiHit?)->())
    func getAllHits(completion:@escaping(Result<[ApiHit],LocalDataRetreiveError>)->())
    func removeFirstHit(completion:@escaping ()->())
}
