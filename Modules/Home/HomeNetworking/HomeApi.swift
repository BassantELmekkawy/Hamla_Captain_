//
//  HomeApi.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 21/04/2024.
//

import Foundation

protocol HomeApiProtocol {
    
    func getCaptainDetails(completion: @escaping (Result<RegisterModel? , CustomError>) -> Void)
}

class HomeApi: BaseAPI<HomeNetworking>,HomeApiProtocol{
    
    func getCaptainDetails(completion: @escaping (Result<RegisterModel?, CustomError>) -> Void) {
        self.performRequest(target: .captainDetails, responseClass: RegisterModel.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
}
