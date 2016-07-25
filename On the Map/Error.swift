//
//  Error.swift
//  On the Map
//
//  Created by Arif Khan on 6/28/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation

enum LoginError: ErrorType {
    case EmptyEmail
    case EmptyPassword

}

enum MyError : ErrorType {
    case RuntimeError(String)
}

extension LoginError : CustomStringConvertible {
    var description: String {
        switch self {
        case .EmptyEmail:
            return "Email cannot be empty"
        
        case .EmptyPassword:
            return "Password cannot be empty"
        }
    }
}