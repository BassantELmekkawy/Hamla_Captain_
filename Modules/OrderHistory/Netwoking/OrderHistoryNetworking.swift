//
//  OrderHistoryNetworking.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 26/05/2024.
//

import Foundation
import Alamofire

enum OrderHistoryNetworking {
    case myOrders(type: String)
}

extension OrderHistoryNetworking: TargetType {
    
    var baseURL: String {
        switch self {
        default:
          return URLs.baseAPIURL.rawValue
        }
    }
    
    var path: String {
        switch self {
        case .myOrders:
            return "my-orders"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .myOrders:
            return .get
        }
    }
    
    var task: Task {
        switch self{

        case .myOrders(type: let type):
            return.requestParameters(parameters: ["type": type], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
   }
}
