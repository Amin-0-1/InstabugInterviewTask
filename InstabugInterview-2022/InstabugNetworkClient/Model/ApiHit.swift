//
//  Hit.swift
//  InstabugNetworkClient
//
//  Created by Amin on 11/05/2022.
//

import Foundation

public struct ApiHit{
    let httpMethod:String
    let url:String
    var requestPayloadBody:Data?
    let status:ResponseStatus
    var responsePayload:Data?
    let code:Int?
    let errorDomain:String?
    let createdAt:Date

}

