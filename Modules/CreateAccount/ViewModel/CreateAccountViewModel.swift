//
//  CreateAccountViewModel.swift
//  Hamla
//
//  Created by Bassant on 08/04/2024.
//

import Foundation

protocol CreateAccountViewModelProtocol {
    

    func uploadImageToserver(file: Data)
    var uploadImageResult:Observable<UploadFileModel?> { get set }
    var errorMessage:Observable<String?> { get set }
    var isLoading:Observable<Bool?>{get set}

}

class CreateAccountViewModel: CreateAccountViewModelProtocol {
    
    var isLoading: Observable<Bool?>  = Observable(false)
    var uploadImageResult: Observable<UploadFileModel?> = Observable(nil)
    var errorMessage: Observable<String?> = Observable(nil)
    
    func uploadImageToserver(file: Data) {
        //self.isLoading.value = true
        ImageUploader
            .shared
            .uploadImageToServer(File: file, url: URLs.baseDashBoardUrl.rawValue) { result in
                //self.isLoading.value = false
                switch result{
                case .success(let result):
                    print(result)
                    if result?.status == 1 {
                        self.uploadImageResult.value = result
                    }else{
                        self.errorMessage.value = result?.message
                    }
                case .failure(let error):
                    self.errorMessage.value = error.message
                }
            }
    }
    
}
