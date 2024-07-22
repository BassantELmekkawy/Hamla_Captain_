//
//  BaseApi.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 03/04/2024.
//

import Foundation
import Alamofire
import MOLH
import UIKit

struct CustomError: Error, Codable {
    let status: Bool?
    let message: String?
}

class BaseAPI<T: TargetType> {
    
    func performRequest<M: Codable>(target: T, responseClass: M.Type, completion:@escaping (Result<M?, (CustomError)>) -> Void) {
        let method     = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers    = getHeaders()//Alamofire.HTTPHeaders(target.headers ?? [:])
        let parameters = buildParams(task: target.task)
        
        AF.request(target.baseURL + target.path, method: method, parameters: parameters.0,encoding: parameters.1, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(_):
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                if statusCode == 401 {
                    self.redirectToSignIn()
                    completion(.failure(CustomError(status: false, message: "Unauthorized access")))
                }
                print("Response is", response.value as Any)
                guard let data = response.data else { return }
                do {
                    let jsonData = try JSONDecoder().decode(M.self, from: data)
                    completion(.success(jsonData))
                }catch let jsonError {
                    //completion(.failure())
                    print("Decoding error: \(jsonError)")
                    print("Response data: \(String(data: data, encoding: .utf8) ?? "N/A")")
                    completion(.failure(CustomError(status: false, message: "\(jsonError)")))
                }
            case .failure(let error):
                print(error)

                guard let error = (response.error?.underlyingError as? URLError) else { return }
                
                switch error.code {
                case .timedOut:
                    // Do SomeThing
                    completion(.failure(CustomError(status: false, message: "Timout")))
                case .notConnectedToInternet:
                    // Do SomeThing
                    completion(.failure(CustomError(status: false, message: "No internet")))
                default:
                    break
                }
                
                guard let data = response.data else {
                    completion(.failure(CustomError(status: false, message: "\(error)")))
                    return
                }
                guard let statusCode = response.response?.statusCode else {
                    completion(.failure(CustomError(status: false, message: "\(error)")))
                    return
                }
                print("Status code ->",response.response?.statusCode ?? 0)
                switch statusCode {
                case 400..<500:
                    do {
                        let jsonError = try JSONDecoder().decode(CustomError.self, from: data)
                        //let error = NSError(domain: target.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: jsonError])
                        completion(.failure(jsonError))
                        
                    } catch let jsonError {
                        print(jsonError)
                        let error = NSError(domain: target.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: jsonError])
                        completion(.failure(CustomError(status: false, message: "\(error)")))
                    }
                default:
                    let error = NSError(domain: target.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed"])
                    completion(.failure(CustomError(status: false, message: "\(error)")))
                }

            }
        }
    }
    
    
    
    private func buildParams(task: Task) -> ([String:Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:], URLEncoding())
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
            
        }
        
    }
    
    private func getHeaders() -> HTTPHeaders?{
        var HttpHeaders = HTTPHeaders()
        let User = UserInfo.shared
        
        HttpHeaders = ["Accept-Language": MOLHLanguage.currentAppleLanguage(),
                       "Accept": "application/json",
                       "Authorization": "Bearer \(User.get_token())",
                       "Content-Type":"application/json"
        ]
        
        return HttpHeaders
    }
    
    
    private func redirectToSignIn() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    let navigationController = UINavigationController(rootViewController: SignInVC())
                    window.rootViewController = navigationController
                }
            }
        }
    }
}
