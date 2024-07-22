//
//  ImageUploader.swift
//  Hamla
//
//  Created by Bassant on 08/04/2024.
//

import Foundation
import Alamofire
import UIKit

final class ImageUploader {
    static let shared = ImageUploader()
    
   
    func uploadImageToServer(File fileData: Data ,
                             url: String,
                             progressHandler: @escaping (Double) -> Void,
                             completion:@escaping (Result<UploadFileModel?, (CustomError)>) -> Void
    ){
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer ",
            "Content-Type":"multipart/form-data",
            "Accept":"application/json"
        ]
      
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(fileData, withName: "file", fileName: "image.png", mimeType: "image/png")
            multipartFormData.append("captains".data(using: .utf8) ?? Data(), withName: "path")
            
        }, to: url + "upload" ,method: .post, headers: headers).uploadProgress(closure: { (progress) in
            print(progress.fractionCompleted)
            progressHandler(progress.fractionCompleted)
            
        }) .responseDecodable { (response: DataResponse<UploadFileModel, AFError>) in
            
            switch response.result {
                
            case .failure(let error):
                
                print(error.localizedDescription)
                completion(.failure(CustomError(status: false, message: "\(error)")))
                break
                
            case .success(let model):
                
                print(response.response!.statusCode)
                
                print(model.message ?? "")
                
                if model.status == 1 {
                    
                    print("-----------------")
                    
                    print(model.message ?? "Success")
                    
                    print("-----------------")
                    
                    completion(.success(model))
                    
                } else {
                    
                    print("Error loading attachment")
                    
                }
                
            }
        }
    }
}
