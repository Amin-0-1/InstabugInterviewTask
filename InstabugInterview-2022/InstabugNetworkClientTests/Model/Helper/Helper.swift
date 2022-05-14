//
//  Helper.swift
//  InstabugNetworkClientTests
//
//  Created by Amin on 14/05/2022.
//

import Foundation
@testable import InstabugNetworkClient

struct Helper{
    static let CONNECTION_ISSUE = "on internet connection"
    static let IP = "41.46.140.148"
    static let URL_GET = EndPoint.get.asUrl()
    static let URL_POST = EndPoint.post.asUrl()
}
