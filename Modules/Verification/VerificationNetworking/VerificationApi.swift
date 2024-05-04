//
//  VerificationApi.swift
//  Hamla
//
//  Created by Bassant on 06/04/2024.
//

import Foundation

protocol VerificationApiProtocol {
    
    func checkCode(mobile:String, verificationCode: String, deviceToken: String, deviceType: String, completion: @escaping (Result<CheckCodeModel? , CustomError>) -> Void)
    func updateProfile(mobile:String, completion: @escaping (Result<RegisterModel? , CustomError>) -> Void)
}

class VerificationApi: BaseAPI<VerificationNetworking>,VerificationApiProtocol{

    func checkCode(mobile:String, verificationCode: String, deviceToken: String, deviceType: String, completion: @escaping (Result<CheckCodeModel?, CustomError>) -> Void) {
        self.performRequest(target: .checkCode(mobile: mobile, verificationCode: verificationCode, deviceToken: deviceToken, deviceType: deviceType), responseClass: CheckCodeModel.self) { result in
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
