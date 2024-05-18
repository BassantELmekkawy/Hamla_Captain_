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
    case getOrdersDetails(orderIDs: [String])
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
        case .getOrdersDetails:
            return "get-orders-details"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .captainDetails:
            return .get
        case .getOrdersDetails:
            return .post
        }
    }
    
    var task: Task {
        switch self{
        case .captainDetails:
            return .requestPlain
        case .getOrdersDetails(orderIDs: let orderIDs):
            return.requestParameters(parameters: ["order_ids": orderIDs], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
   }
}
