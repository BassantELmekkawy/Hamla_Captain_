//
//  RegisterNetworking.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 03/04/2024.
//

import Foundation
import Alamofire

enum RegisterNetworking {
    case register(fullName: String,
                  //gender: String,
                  birthday: String,
                  mobile: String,
                  //nationality: String,
                  nationalID: String,
                  nationalExpiryDate: String,
                  nationalIDImage: String,
                  licenseExpiryDate: String,
                  licenseImage: String,
                  //cityID: String,
                  avatar: String,
                  plateNumber: String,
                  color: String,
                  size: String,
                  truckTypeID: String,
                  truckImage: String,
                  licenseTruckImage: String,
                  licenseTruckExpireDate: String,
                  stcAccount: String,
                  deviceID: String,
                  deviceType: String,
                  deviceToken: String)
}

extension RegisterNetworking: TargetType {
    
    var baseURL: String {
        switch self {
        default:
          return URLs.baseAPIURL.rawValue
        }
    }
    
    var path: String {
        switch self {
        case .register:
            return "register"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register:
            return .post
        }
    }
    
    var task: Task {
        switch self{
        case .register(fullName: let fullName, birthday: let birthday, mobile: let mobile, nationalID: let nationalID, nationalExpiryDate: let nationalExpiryDate, nationalIDImage: let nationalIDImage, licenseExpiryDate: let licenseExpiryDate, licenseImage: let licenseImage, avatar: let avatar, plateNumber: let plateNumber, color: let color, size: let size, truckTypeID: let truckTypeID, truckImage: let truckImage, licenseTruckImage: let licenseTruckImage, licenseTruckExpireDate: let licenseTruckExpireDate, stcAccount: let stcAccount, deviceID: let deviceID, deviceType: let deviceType, deviceToken: let deviceToken):
            
            return .requestParameters(parameters: ["full_name": fullName,
                                                   "birthday": birthday,
                                                   "mobile": mobile,
                                                   "national_id": nationalID,
                                                   "national_expiry_date": nationalExpiryDate,
                                                   "national_id_image": nationalIDImage,
                                                   "license_expiry_date": licenseExpiryDate,
                                                   "license_image": licenseImage,
                                                   "avatar": avatar,
                                                   "plate_number": plateNumber,
                                                   "color": color,
                                                   "size": size,
                                                   "truck_type_id": truckTypeID,
                                                   "truck_image": truckImage,
                                                   "license_truck_image": licenseTruckImage,
                                                   "license_truck_expire_date": licenseTruckExpireDate,
                                                   "stc_account": stcAccount,
                                                   "device_id": deviceID,
                                                   "device_type": deviceType,
                                                   "device_token": deviceToken], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
   }
}
