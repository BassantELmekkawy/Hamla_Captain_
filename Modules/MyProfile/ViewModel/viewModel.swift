//
//  viewModel.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 21/04/2024.
//

import Foundation

protocol MyProfileViewModelProtocol {
    
    func checkPhone(mobile: String)
    func updateProfile(mobile: String)
    func isValidPhone(phone: String) -> Bool
    var checkPhoneResult: Observable<SendCodeModel?> { get set }
    var updateProfileResult: Observable<RegisterModel?> { get set }
    var errorMessage: Observable<String?> { get set }
    var isLoading: Observable<Bool?>{get set}
    
}

class MyProfileViewModel: MyProfileViewModelProtocol {
    
    var isLoading: Observable<Bool?>  = Observable(false)
    var checkPhoneResult: Observable<SendCodeModel?>  = Observable(nil)
    var updateProfileResult: Observable<RegisterModel?> = Observable(nil)
    var errorMessage: Observable<String?> = Observable(nil)
    
    var api: MyProfileApiProtocol
    
    init(api: MyProfileApi) {
        self.api = api
    }
    
    func checkPhone(mobile: String) {
        self.isLoading.value = true
        self.api.checkPhone(mobile: mobile) { result in
            self.isLoading.value = false
            
            switch result {
            case .success(let result):
                print(result)
                self.checkPhoneResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func updateProfile(mobile: String) {
        self.isLoading.value = true
        self.api.updateProfile(mobile: mobile) { result in
            self.isLoading.value = false
            
            switch result {
            case .success(let result):
                print(result)
                self.updateProfileResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func isValidPhone(phone: String) -> Bool {
        let PHONE_REGEX = #"^2(010|011|012|015)\d{8}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = predicate.evaluate(with: phone)
        return result
    }
    
}
