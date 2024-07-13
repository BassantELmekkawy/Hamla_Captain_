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
    func startLoad(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void)
    func endLoad(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void)
    func startOrder(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void)
    func arrivePoint(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void)
    func movePoint(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void)
    func dropoffOrder(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void)
    func startUnload(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void)
    func endUnload(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void)
    func endOrder(orderID: String, dropoffLat: String, dropoffLng: String, completion: @escaping (Result<EndOrderModel? , CustomError>) -> Void)
    func confirmPaymentCash(orderID: String, amount: String, completion: @escaping (Result<Model? , CustomError>) -> Void)
    func rateOrder(orderID: String, rate: String, completion: @escaping (Result<Model? , CustomError>) -> Void)
    func cancelOrder(orderID: String, completion: @escaping (Result<Model? , CustomError>) -> Void)
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
    
    func startLoad(orderID: String, completion: @escaping (Result<Model?, CustomError>) -> Void) {
        self.performRequest(target: .startLoad(orderID: orderID), responseClass: Model.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
    func endLoad(orderID: String, completion: @escaping (Result<Model?, CustomError>) -> Void) {
        self.performRequest(target: .endLoad(orderID: orderID), responseClass: Model.self) { result in
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
    
    func arrivePoint(orderID: String, completion: @escaping (Result<Model?, CustomError>) -> Void) {
        self.performRequest(target: .arrivePoint(orderID: orderID), responseClass: Model.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
    func movePoint(orderID: String, completion: @escaping (Result<Model?, CustomError>) -> Void) {
        self.performRequest(target: .movePoint(orderID: orderID), responseClass: Model.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
    func dropoffOrder(orderID: String, completion: @escaping (Result<Model?, CustomError>) -> Void) {
        self.performRequest(target: .dropoffOrder(orderID: orderID), responseClass: Model.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
    func startUnload(orderID: String, completion: @escaping (Result<Model?, CustomError>) -> Void) {
        self.performRequest(target: .startUnload(orderID: orderID), responseClass: Model.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
    func endUnload(orderID: String, completion: @escaping (Result<Model?, CustomError>) -> Void) {
        self.performRequest(target: .endUnload(orderID: orderID), responseClass: Model.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
    func endOrder(orderID: String, dropoffLat: String, dropoffLng: String, completion: @escaping (Result<EndOrderModel? , CustomError>) -> Void) {
        self.performRequest(target: .endOrder(orderID: orderID, dropoffLat: dropoffLat, dropoffLng: dropoffLng), responseClass: EndOrderModel.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
    func confirmPaymentCash(orderID: String, amount: String, completion: @escaping (Result<Model?, CustomError>) -> Void) {
        self.performRequest(target: .confirmPaymentCash(orderID: orderID, amount: amount), responseClass: Model.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
    func rateOrder(orderID: String, rate: String, completion: @escaping (Result<Model?, CustomError>) -> Void) {
        self.performRequest(target: .rateOrder(orderID: orderID, rate: rate), responseClass: Model.self) { result in
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
    
}
