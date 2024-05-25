//
//  MapNetworking.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 20/05/2024.
//

import Foundation
import Alamofire

enum MapNetworking {
    case pickupOrder(orderID: String)
    case arrivedOrder(orderID: String)
    case cancelOrder(orderID: String)
    case startOrder(orderID: String)
    case endOrder(orderID: String, dropoffLat: String, dropoffLng: String)
}

extension MapNetworking: TargetType {
    
    var baseURL: String {
        switch self {
        default:
          return URLs.baseAPIURL.rawValue
        }
    }
    
    var path: String {
        switch self {
        case .pickupOrder:
            return "pickup-order"
        case .arrivedOrder:
            return "arrived-order"
        case .cancelOrder:
            return "cancel-order"
        case .startOrder:
            return "start-order"
        case .endOrder:
            return "end-order"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var task: Task {
        switch self{
        case .pickupOrder(orderID: let orderID):
            return.requestParameters(parameters: ["order_id": orderID], encoding: JSONEncoding.default)
        case .arrivedOrder(orderID: let orderID):
            return.requestParameters(parameters: ["order_id": orderID], encoding: JSONEncoding.default)
        case .cancelOrder(orderID: let orderID):
            return.requestParameters(parameters: ["order_id": orderID], encoding: JSONEncoding.default)
        case .startOrder(orderID: let orderID):
            return.requestParameters(parameters: ["order_id": orderID], encoding: JSONEncoding.default)
        case .endOrder(orderID: let orderID, dropoffLat: let dropoffLat, dropoffLng: let dropoffLng):
            return.requestParameters(parameters: ["order_id": orderID, "dropoff_lat": dropoffLat, "dropoff_lng": dropoffLng], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
   }
}
