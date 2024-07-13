//
//  ChatViewModel.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 26/06/2024.
//

import Foundation

protocol ChatViewModelProtocol {
    
    func uploadImageToserver(file: Data)
    
    var uploadImageResult: Observable<UploadFileModel?> { get set }
    var errorMessage: Observable<String?> { get set }
}

class ChatViewModel: ChatViewModelProtocol {
    
    var uploadImageResult: Observable<UploadFileModel?> = Observable(nil)
    var errorMessage: Observable<String?> = Observable(nil)
    
    func uploadImageToserver(file: Data) {
        ImageUploader
            .shared
            .uploadImageToServer(File: file, url: URLs.baseDashBoardUrl.rawValue, progressHandler: { progress in
                
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
}
