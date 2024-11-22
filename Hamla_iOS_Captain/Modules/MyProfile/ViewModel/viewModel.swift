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
    var uploadImageResult: Observable<(UploadFileModel?)> { get set }
    var errorMessage: Observable<String?> { get set }
    var isLoading: Observable<Bool?>{get set}
    
}

class MyProfileViewModel: MyProfileViewModelProtocol {
    
    var isLoading: Observable<Bool?>  = Observable(false)
    var checkPhoneResult: Observable<SendCodeModel?>  = Observable(nil)
    var updateProfileResult: Observable<RegisterModel?> = Observable(nil)
    var uploadImageResult: Observable<(UploadFileModel?)> = Observable(nil)
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
    
    func uploadImageToserver(file: Data, progressHandler: @escaping (Double) -> Void) {
        ImageUploader
            .shared
            .uploadImageToServer(File: file, url: URLs.baseDashBoardUrl.rawValue, progressHandler: { progress in
                print("Upload progress: \(progress * 100)%")
                progressHandler(progress)
            }) { result in
                switch result{
                case .success(let result):
                    print(result)
                    if result?.status == 1 {
                        self.uploadImageResult.value = (result)
                    }else{
                        self.errorMessage.value = result?.message
                    }
                case .failure(let error):
                    self.errorMessage.value = error.message
                }
            }
    }
    
    func isValidPhone(phone: String) -> Bool {
        var PHONE_REGEX = ""
        if phone.hasPrefix("20") {
            PHONE_REGEX = #"^20(10|11|12|15)\d{8}$"#
        }
        else if phone.hasPrefix("966") {
            PHONE_REGEX = #"^966(5)(5|0|3|6|4|9|1|8|7)\\d{7}$"#
        }
        let predicate = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = predicate.evaluate(with: phone)
        return result
    }
    
}
