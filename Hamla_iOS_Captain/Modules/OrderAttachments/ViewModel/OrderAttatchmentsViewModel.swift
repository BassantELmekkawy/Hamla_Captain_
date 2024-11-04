//
//  OrderAttatchmentsViewModel.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant Elmekkawy on 04/11/2024.
//

import Foundation

protocol OrderAttatchmentsViewModelProtocol {
    
    func uploadImageToserver(file: Data, tag: Int)

    var uploadImageResult: Observable<(Int, UploadFileModel?)> { get set }
    var errorMessage: Observable<String?> { get set }
    var tag: Observable<Int?>{get set}
    var isLoading:Observable<Bool?>{get set}
}

class OrderAttatchmentsViewModel: OrderAttatchmentsViewModelProtocol {
    
    var tag: Observable<Int?>  = Observable(0)
    var uploadImageResult: Observable<(Int, UploadFileModel?)> = Observable((0, nil))
    var errorMessage: Observable<String?> = Observable(nil)
    var isLoading: Observable<Bool?>  = Observable(false)
    
    func uploadImageToserver(file: Data, tag: Int) {
        ImageUploader
            .shared
            .uploadImageToServer(File: file, url: URLs.baseDashBoardUrl.rawValue, progressHandler: { progress in
                print("Upload progress: \(progress * 100)%")
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
 
}
