//
//  MapApi.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 20/05/2024.
//

import Foundation

protocol MapApiProtocol {
    
    func pickupOrder(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void)
    func arrivedOrder(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void)
    func cancelOrder(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void)
    func startOrder(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void)
    func endOrder(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void)
}

class MapApi: BaseAPI<MapNetworking>,MapApiProtocol{
    
    func pickupOrder(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void) {
        self.performRequest(target: .pickupOrder(orderID: orderID), responseClass: Model.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
    func arrivedOrder(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void) {
        self.performRequest(target: .arrivedOrder(orderID: orderID), responseClass: Model.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
    func cancelOrder(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void) {
        self.performRequest(target: .cancelOrder(orderID: orderID), responseClass: Model.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
    func startOrder(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void) {
        self.performRequest(target: .startOrder(orderID: orderID), responseClass: Model.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
    func endOrder(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void) {
        self.performRequest(target: .endOrder(orderID: orderID), responseClass: Model.self) { result in
            print("result", result)
            completion(result)
        }
    }
}