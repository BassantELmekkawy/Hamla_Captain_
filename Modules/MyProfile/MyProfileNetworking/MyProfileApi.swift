//
//  MyProfileApi.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 21/04/2024.
//

import Foundation

protocol MyProfileApiProtocol {
    
    func checkPhone(mobile:String, completion: @escaping (Result<SendCodeModel? , CustomError>) -> Void)
    func updateProfile(mobile:String, completion: @escaping (Result<RegisterModel? , CustomError>) -> Void)
}

class MyProfileApi: BaseAPI<MyProfileNetworking>,MyProfileApiProtocol{
    
    func checkPhone(mobile:String, completion: @escaping (Result<SendCodeModel?, CustomError>) -> Void) {
        self.performRequest(target: .checkPhone(mobile: mobile), responseClass: SendCodeModel.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
    func updateProfile(mobile:String, completion: @escaping (Result<RegisterModel?, CustomError>) -> Void) {
        self.performRequest(target: .updateProfile(mobile: mobile), responseClass: RegisterModel.self) { result in
            print("result", result)
            completion(result)
        }
    }
}
