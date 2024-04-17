//
//  VerificationApi.swift
//  Hamla
//
//  Created by Bassant on 06/04/2024.
//

import Foundation

protocol VerificationApiProtocol {
    
    func checkCode(mobile:String, verificationCode: String, deviceToken: String, deviceType: String, completion: @escaping (Result<CheckCodeModel? , CustomError>) -> Void)
}

class VerificationApi: BaseAPI<VerificationNetworking>,VerificationApiProtocol{

    func checkCode(mobile:String, verificationCode: String, deviceToken: String, deviceType: String, completion: @escaping (Result<CheckCodeModel?, CustomError>) -> Void) {
        self.performRequest(target: .checkCode(mobile: mobile, verificationCode: verificationCode, deviceToken: deviceToken, deviceType: deviceType), responseClass: CheckCodeModel.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
}
