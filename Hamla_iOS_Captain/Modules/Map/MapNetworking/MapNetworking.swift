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
    case startLoad(orderID: String)
    case endLoad(orderID: String)
    case startOrder(orderID: String)
    case arrivePoint(orderID: String)
    case movePoint(orderID: String)
    case dropoffOrder(orderID: String)
    case startUnload(orderID: String)
    case endUnload(orderID: String)
    case endOrder(orderID: String, dropoffLat: String, dropoffLng: String)
    case confirmPaymentCash(orderID: String, amount: String)
    case rateOrder(orderID: String, rate: String)
    case cancelOrder(orderID: String)
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
        case .startLoad:
            return "start-load"
        case .endLoad:
            return "end-load"
        case .startOrder:
            return "start-order"
        case .arrivePoint:
            return "arrive-point"
        case .movePoint:
            return "move-point"
        case .dropoffOrder:
            return "dropoff-order"
        case .startUnload:
            return "start-unload"
        case .endUnload:
            return "end-unload"
        case .endOrder:
            return "end-order"
        case .confirmPaymentCash:
            return "confirm-payment-cash"
        case .rateOrder:
            return "rate-order"
        case .cancelOrder:
            return "cancel-order"
        
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
        case .startLoad(orderID: let orderID):
            return.requestParameters(parameters: ["order_id": orderID], encoding: JSONEncoding.default)
        case .endLoad(orderID: let orderID):
            return.requestParameters(parameters: ["order_id": orderID], encoding: JSONEncoding.default)
        case .startOrder(orderID: let orderID):
            return.requestParameters(parameters: ["order_id": orderID], encoding: JSONEncoding.default)
        case .arrivePoint(orderID: let orderID):
            return.requestParameters(parameters: ["order_id": orderID], encoding: JSONEncoding.default)
        case .movePoint(orderID: let orderID):
            return.requestParameters(parameters: ["order_id": orderID], encoding: JSONEncoding.default)
        case .dropoffOrder(orderID: let orderID):
            return.requestParameters(parameters: ["order_id": orderID], encoding: JSONEncoding.default)
        case .startUnload(orderID: let orderID):
            return.requestParameters(parameters: ["order_id": orderID], encoding: JSONEncoding.default)
        case .endUnload(orderID: let orderID):
            return.requestParameters(parameters: ["order_id": orderID], encoding: JSONEncoding.default)
        case .endOrder(orderID: let orderID, dropoffLat: let dropoffLat, dropoffLng: let dropoffLng):
            return.requestParameters(parameters: ["order_id": orderID, "dropoff_lat": dropoffLat, "dropoff_lng": dropoffLng], encoding: JSONEncoding.default)
        case .confirmPaymentCash(orderID: let orderID, amount: let amount):
            return.requestParameters(parameters: ["order_id": orderID, "amount": amount], encoding: JSONEncoding.default)
        case .rateOrder(orderID: let orderID, rate: let rate):
            return.requestParameters(parameters: ["order_id": orderID, "rate": rate], encoding: JSONEncoding.default)
        case .cancelOrder(orderID: let orderID):
            return.requestParameters(parameters: ["order_id": orderID], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
   }
}
