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
    case isCaptainOnOrder
    case getOrdersDetails(orderIDs: [String])
    case acceptOrder(orderID: String, captainLat: String, captainLng: String)
    case rejectOrder(orderID: String)
    case updateAvailability(lat: String, lng: String)
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
        case .isCaptainOnOrder:
            return "captain-on-order"
        case .getOrdersDetails:
            return "get-orders-details"
        case .acceptOrder:
            return "accept-order"
        case .rejectOrder:
            return "reject-order"
        case .updateAvailability:
            return "update-availability"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .captainDetails:
            return .get
        case .isCaptainOnOrder:
            return .get
        case .getOrdersDetails:
            return .post
        case .acceptOrder:
            return .post
        case .rejectOrder:
            return .post
        case .updateAvailability:
            return .post
        }
    }
    
    var task: Task {
        switch self{
        case .captainDetails:
            return .requestPlain
        case .isCaptainOnOrder:
            return .requestPlain
        case .getOrdersDetails(orderIDs: let orderIDs):
            return.requestParameters(parameters: ["order_ids": orderIDs], encoding: JSONEncoding.default)
        case .acceptOrder(orderID: let orderID, captainLat: let captainLat, captainLng: let captainLng):
            return.requestParameters(parameters: ["order_id": orderID, "captain_lat": captainLat, "captain_lng": captainLng], encoding: JSONEncoding.default)
        case .rejectOrder(orderID: let orderID):
            return.requestParameters(parameters: ["order_id": orderID], encoding: JSONEncoding.default)
        case .updateAvailability(lat: let lat, lng: let lng):
            return .requestParameters(parameters: ["lat" : lat, "lng" : lng], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
   }
}
