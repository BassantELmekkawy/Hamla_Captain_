//
//  SignInViewModel.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 03/04/2024.
//

import Foundation

protocol SignInViewModelProtocol {
    
    func sendCode(mobile: String)
    func isValidPhone(phone: String) -> Bool
    var sendCodeResult:Observable<SendCodeModel?> { get set }
    var errorMessage:Observable<String?> { get set }
    var isLoading:Observable<Bool?>{get set}
    
}

class SignInViewModel: SignInViewModelProtocol {
    
    var isLoading: Observable<Bool?>  = Observable(false)
    var sendCodeResult: Observable<SendCodeModel?>  = Observable(nil)
    var errorMessage: Observable<String?> = Observable(nil)
    
    var api: SignInApiProtocol
    
    init(api: SignInApi) {
        self.api = api
    }
    
    func sendCode(mobile: String) {
        self.isLoading.value = true
        self.api.sendCode(mobile: mobile) { result in
            self.isLoading.value = false
            
            switch result {
            case .success(let result):
                print(result)
                self.sendCodeResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func isValidPhone(phone: String) -> Bool {
        let PHONE_REGEX = #"^(010|011|012|015)\d{8}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = predicate.evaluate(with: phone)
        return result
    }
    
}
