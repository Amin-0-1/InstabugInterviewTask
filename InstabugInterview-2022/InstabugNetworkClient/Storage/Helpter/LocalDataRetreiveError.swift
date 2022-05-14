//
//  LocalDataRetreiveError.swift
//  InstabugNetworkClient
//
//  Created by Amin on 13/05/2022.
//

import Foundation

enum LocalDataRetreiveError:Error{
    case retrieveError
}
extension LocalDataRetreiveError:CustomStringConvertible{
    var description: String {
        switch self {
        case .retrieveError:
            return "an error occured while retrieving hits"
        }
    }
}
