//
//  RegisterApi.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 03/04/2024.
//

import Foundation

protocol RegisterApiProtocol {
    
    func register(fullName: String,
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
                  deviceToken: String,
                  completion: @escaping (Result<RegisterModel? , CustomError>) -> Void)
}

class RegisterApi: BaseAPI<RegisterNetworking>,RegisterApiProtocol{
    
    func register(fullName: String,
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
                  deviceToken: String,
                  completion: @escaping (Result<RegisterModel?, CustomError>) -> Void) {
        self.performRequest(target: .register(fullName: fullName,
                                              //gender: gender,
                                              birthday: birthday,
                                              mobile: mobile,
                                              //nationality: nationality,
                                              nationalID: nationalID,
                                              nationalExpiryDate: nationalExpiryDate,
                                              nationalIDImage: nationalIDImage,
                                              licenseExpiryDate: licenseExpiryDate,
                                              licenseImage: licenseImage,
                                              //cityID: cityID,
                                              avatar: avatar,
                                              plateNumber: plateNumber,
                                              color: color,
                                              size: size,
                                              truckTypeID: truckTypeID,
                                              truckImage: truckImage,
                                              licenseTruckImage: licenseTruckImage,
                                              licenseTruckExpireDate: licenseTruckExpireDate,
                                              stcAccount: stcAccount,
                                              deviceID: deviceID,
                                              deviceType: deviceType,
                                              deviceToken: deviceToken),
                            responseClass: RegisterModel.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
}
