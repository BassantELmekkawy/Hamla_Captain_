//
//  SignInNetworking.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 03/04/2024.
//

import Foundation
import Alamofire

enum SignInNetworking {
    case sendCode(mobile: String)
}

extension SignInNetworking: TargetType {
    
    var baseURL: String {
        switch self {
        default:
          return URLs.baseAPIURL.rawValue
        }
    }
    
    var path: String {
        switch self {
        case .sendCode:
            return "send-code"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sendCode:
            return .post
        }
    }
    
    var task: Task {
        switch self{
        case .sendCode(mobile: let mobile):
            return .requestParameters(parameters: ["mobile" : mobile], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
   }
}
