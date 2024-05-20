//
//  MapViewModel.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 20/05/2024.
//

import Foundation

protocol MapViewModelProtocol {
    
    func pickupOrder(orderID: String)
    func arrivedOrder(orderID: String)
    func cancelOrder(orderID: String)
    func startOrder(orderID: String)
    func endOrder(orderID: String)

    var pickupResult:Observable<Model?> { get set }
    var arrivedResult:Observable<Model?> { get set }
    var cancelResult:Observable<Model?> { get set }
    var startResult:Observable<Model?> { get set }
    var endResult:Observable<Model?> { get set }
    var errorMessage:Observable<String?> { get set }
    
}

class MapViewModel: MapViewModelProtocol {
    
    var pickupResult: Observable<Model?>  = Observable(nil)
    var arrivedResult: Observable<Model?> = Observable(nil)
    var cancelResult: Observable<Model?>  = Observable(nil)
    var startResult: Observable<Model?>   = Observable(nil)
    var endResult: Observable<Model?>     = Observable(nil)
    var errorMessage: Observable<String?> = Observable(nil)
    
    var api: MapApiProtocol
    
    init(api: MapApi) {
        self.api = api
    }
    
    func pickupOrder(orderID: String) {
        self.api.pickupOrder(orderID: orderID) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.pickupResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func arrivedOrder(orderID: String) {
        self.api.arrivedOrder(orderID: orderID) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.arrivedResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func cancelOrder(orderID: String) {
        self.api.cancelOrder(orderID: orderID) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.cancelResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func startOrder(orderID: String) {
        self.api.startOrder(orderID: orderID) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.startResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func endOrder(orderID: String) {
        self.api.endOrder(orderID: orderID) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.endResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
}
