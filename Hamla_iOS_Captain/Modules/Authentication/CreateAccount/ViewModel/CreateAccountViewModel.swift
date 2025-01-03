//
//  CreateAccountViewModel.swift
//  Hamla
//
//  Created by Bassant on 08/04/2024.
//

import Foundation

protocol CreateAccountViewModelProtocol {
    
    func getTruckTypes()
    func register(fullName: String, birthday: String, mobile: String, nationalID: String, nationalExpiryDate: String, nationalIDImage: String, licenseExpiryDate: String, licenseImage: String, avatar: String, plateNumber: String, color: String, size: String, truckTypeID: String, truckImage: String, licenseTruckImage: String, licenseTruckExpireDate: String, stcAccount: String?, deviceID: String, deviceType: String, deviceToken: String)
    func uploadImageToserver(file: Data, tag: Int, progressHandler: @escaping (Double) -> Void)
    
    var truckTypesResult: Observable<TruckTypesModel?> { get set }
    var registerResult: Observable<RegisterModel?> { get set }
    var uploadImageResult: Observable<(Int, UploadFileModel?)> { get set }
    var errorMessage: Observable<String?> { get set }
    var tag: Observable<Int?>{get set}
    var isLoading:Observable<Bool?>{get set}
}

class CreateAccountViewModel: CreateAccountViewModelProtocol {
    
    var tag: Observable<Int?>  = Observable(0)
    var uploadImageResult: Observable<(Int, UploadFileModel?)> = Observable((0, nil))
    var truckTypesResult: Observable<TruckTypesModel?> = Observable(nil)
    var registerResult: Observable<RegisterModel?>  = Observable(nil)
    var errorMessage: Observable<String?> = Observable(nil)
    var isLoading: Observable<Bool?>  = Observable(false)
    
    var api: RegisterApiProtocol
    
    init(api: RegisterApi) {
        self.api = api
    }
    
    func uploadImageToserver(file: Data, tag: Int, progressHandler: @escaping (Double) -> Void) {
        ImageUploader
            .shared
            .uploadImageToServer(File: file, url: URLs.baseDashBoardUrl.rawValue, progressHandler: { progress in
                print("Upload progress: \(progress * 100)%")
                progressHandler(progress)
            }) { result in
                self.tag.value = tag
                switch result{
                case .success(let result):
                    print(result)
                    if result?.status == 1 {
                        self.uploadImageResult.value = (tag, result)
                    }else{
                        self.errorMessage.value = result?.message
                    }
                case .failure(let error):
                    self.errorMessage.value = error.message
                }
            }
    }
    
    func getTruckTypes() {
        self.api.getTruckTypes { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let result):
                print(result)
                self.truckTypesResult.value = result
                
                if let status = result?.status, status == 0 {
                    self.errorMessage.value = result?.message
                }
            case .failure(let error):
                self.errorMessage.value = error.message
                print("error", error.message)

            }
        }
    }
    
    func register(fullName: String, birthday: String, mobile: String, nationalID: String, nationalExpiryDate: String, nationalIDImage: String, licenseExpiryDate: String, licenseImage: String, avatar: String, plateNumber: String, color: String, size: String, truckTypeID: String, truckImage: String, licenseTruckImage: String, licenseTruckExpireDate: String, stcAccount: String?, deviceID: String, deviceType: String, deviceToken: String) {
        self.isLoading.value = true
        self.api.register(fullName: fullName, birthday: birthday, mobile: mobile, nationalID: nationalID, nationalExpiryDate: nationalExpiryDate, nationalIDImage: nationalIDImage, licenseExpiryDate: licenseExpiryDate, licenseImage: licenseImage, avatar: avatar, plateNumber: plateNumber, color: color, size: size, truckTypeID: truckTypeID, truckImage: truckImage, licenseTruckImage: licenseTruckImage, licenseTruckExpireDate: licenseTruckExpireDate, stcAccount: stcAccount, deviceID: deviceID, deviceType: deviceType, deviceToken: deviceToken) { [weak self] result in
            guard let self = self else { return }
            self.isLoading.value = false
            
            switch result {
            case .success(let result):
                print(result)
                self.registerResult.value = result
                
                if let status = result?.status, status == 0 {
                    self.errorMessage.value = result?.message
                }
            case .failure(let error):
                self.errorMessage.value = error.message
                print("error", error.message)

            }
        }
    }
    
    func isValidPhone(phone: String, countryCode: String) -> Bool {
        var PHONE_REGEX = ""
        switch countryCode {
        case "20":   // Egypt
            PHONE_REGEX = #"^(10|11|12|15)\d{8}$"#
        case "966":  // Saudi Arabia
            PHONE_REGEX = "^(5)(5|0|3|6|4|9|1|8|7)\\d{7}$"
        default:
            return false
        }
        let predicate = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = predicate.evaluate(with: phone)
        return result
    }
}
