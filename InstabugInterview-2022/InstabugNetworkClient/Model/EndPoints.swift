//
//  EndPoints.swift
//  InstabugNetworkClientTests
//
//  Created by Amin on 14/05/2022.
//

import Foundation

enum EndPoint:String{
    case get = "https://httpbin.org/get"
    case post = "https://httpbin.org/post"
    func asUrl()->URL{
        return URL(string: self.rawValue)!
    }
}
