//
//  HomeNetworking.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 21/04/2024.
//

import Foundation
import Alamofire

enum HomeNetworking {
    case captainDetails
}

extension HomeNetworking: TargetType {
    
    var baseURL: String {
        switch self {
        default:
          return URLs.baseAPIURL.rawValue
        }
    }
    
    var path: String {
        switch self {
        case .captainDetails:
            return "captain-details"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .captainDetails:
            return .get
        }
    }
    
    var task: Task {
        switch self{
        case .captainDetails:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [:]
   }
}
