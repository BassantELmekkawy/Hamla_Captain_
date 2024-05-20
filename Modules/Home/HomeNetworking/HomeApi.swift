//
//  HomeApi.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 21/04/2024.
//

import Foundation

protocol HomeApiProtocol {
    
    func getCaptainDetails(completion: @escaping (Result<RegisterModel? , CustomError>) -> Void)
    func updateAvailability(lat: String, lng: String, completion: @escaping (Result<UpdateAvailabilityModel? , CustomError>) -> Void)
}

class HomeApi: BaseAPI<HomeNetworking>,HomeApiProtocol{
    
    func getCaptainDetails(completion: @escaping (Result<RegisterModel?, CustomError>) -> Void) {
        self.performRequest(target: .captainDetails, responseClass: RegisterModel.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
    func updateAvailability(lat: String, lng: String, completion: @escaping (Result<UpdateAvailabilityModel?, CustomError>) -> Void) {
        self.performRequest(target: .updateAvailability(lat: lat, lng: lng), responseClass: UpdateAvailabilityModel.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
}
