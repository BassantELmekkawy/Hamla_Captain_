//
//  MyProfileNetworking.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 21/04/2024.
//

import Foundation
import Alamofire

enum MyProfileNetworking {
    case checkPhone(mobile: String)
    case updateProfile(mobile: String)
}

extension MyProfileNetworking: TargetType {
    
    var baseURL: String {
        switch self {
        default:
          return URLs.baseAPIURL.rawValue
        }
    }
    
    var path: String {
        switch self {
        case .checkPhone:
            return "check-phone"
        case .updateProfile:
            return "update-profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkPhone:
            return .post
        case .updateProfile:
            return .post
        }
    }
    
    var task: Task {
        switch self{
        case .checkPhone(mobile: let mobile):
            return .requestParameters(parameters: ["mobile" : mobile], encoding: JSONEncoding.default)
        case .updateProfile(mobile: let mobile):
            return .requestParameters(parameters: ["mobile" : mobile], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
   }
}
