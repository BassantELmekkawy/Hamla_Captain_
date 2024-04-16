//
//  TargetType.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 03/04/2024.
//

import Foundation
import Alamofire

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

enum Task {
    /// A request with no addditional data
    case requestPlain
    
    /// A request body set with encoded parameters
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
    
}

protocol TargetType {
    /// the target's base URL
    var baseURL: String { get }
    
    /// the path to be appended tp `baseURL`to form the full `URL`
    var path: String { get }
    
    /// the HTTP method used in the request
    var method: HTTPMethod { get }
    
    /// the type of HTTP task used in the request
    var task: Task { get }
    
    /// the type of HTTP task used in the request
    var headers: [String: String]? { get }
}
