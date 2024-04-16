//
//  SignInApi.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 03/04/2024.
//

import Foundation

protocol SignInApiProtocol {
    
    func sendCode(mobile:String, completion: @escaping (Result<SendCodeModel? , CustomError>) -> Void)
}

class SignInApi: BaseAPI<SignInNetworking>,SignInApiProtocol{
    
    func sendCode(mobile:String, completion: @escaping (Result<SendCodeModel?, CustomError>) -> Void) {
        self.performRequest(target: .sendCode(mobile: mobile), responseClass: SendCodeModel.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
}
