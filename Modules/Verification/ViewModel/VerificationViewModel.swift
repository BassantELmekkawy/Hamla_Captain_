//
//  VerificationViewModel.swift
//  Hamla
//
//  Created by Bassant on 06/04/2024.
//

import Foundation

protocol VerificationViewModelProtocol {
    
    func checkCode(mobile: String, verificationCode: String, deviceToken: String, deviceType: String)
    var checkCodeResult:Observable<CheckCodeModel?> { get set }
    var errorMessage:Observable<String?> { get set }
    var isLoading:Observable<Bool?>{get set}
    
}

class VerificationViewModel: VerificationViewModelProtocol {
    
    var isLoading: Observable<Bool?>  = Observable(false)
    var checkCodeResult: Observable<CheckCodeModel?>  = Observable(nil)
    var errorMessage: Observable<String?> = Observable(nil)
    
    var api: VerificationApiProtocol
    
    init(api: VerificationApi) {
        self.api = api
    }
    
    func checkCode(mobile: String, verificationCode: String, deviceToken: String, deviceType: String) {
        self.isLoading.value = true
        self.api.checkCode(mobile: mobile, verificationCode: verificationCode, deviceToken: deviceToken, deviceType: deviceType) { [weak self] result in
            guard let self = self else { return }
            self.isLoading.value = false
            
            switch result {
            case .success(let result):
                print(result)
                self.checkCodeResult.value = result
                
                if let status = result?.status, status == 0 {
                    self.errorMessage.value = result?.message
                }
            case .failure(let error):
                self.errorMessage.value = error.message
                print("error", error.message)

            }
        }
    }
    
}
