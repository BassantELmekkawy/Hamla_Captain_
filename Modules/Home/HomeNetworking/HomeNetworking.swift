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
        case .updateAvailability:
            return "update-availability"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .captainDetails:
            return .get
        case .updateAvailability:
            return .post
        }
    }
    
    var task: Task {
        switch self{
        case .captainDetails:
            return .requestPlain
        case .updateAvailability(lat: let lat, lng: let lng):
            return .requestParameters(parameters: ["lat" : lat, "lng" : lng], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
   }
}
