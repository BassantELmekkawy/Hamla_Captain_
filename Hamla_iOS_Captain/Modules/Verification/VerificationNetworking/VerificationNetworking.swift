//
//  VerificationNetworking.swift
//  Hamla
//
//  Created by Bassant on 06/04/2024.
//

import Foundation
import Alamofire

enum VerificationNetworking {
    case checkCode(mobile: String, verificationCode: String, deviceToken: String, deviceType: String)
    case updateProfile(mobile: String)
}

extension VerificationNetworking: TargetType {
    
    var baseURL: String {
        switch self {
        default:
          return URLs.baseAPIURL.rawValue
        }
    }
    
    var path: String {
        switch self {
        case .checkCode:
            return "check-code"
        case .updateProfile:
            return "update-profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkCode:
            return .post
        case .updateProfile:
            return .post
        }
    }
    
    var task: Task {
        switch self{
        case .checkCode(mobile: let mobile, verificationCode: let code, deviceToken: let deviceToken, deviceType: let deviceType):
            return .requestParameters(parameters: ["mobile" : mobile, "verification_code" : code, "device_token" : deviceToken, "device_type" : deviceType], encoding: JSONEncoding.default)
        case .updateProfile(mobile: let mobile):
            return .requestParameters(parameters: ["mobile" : mobile], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
   }
}
