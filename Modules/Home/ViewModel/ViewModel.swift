//
//  ViewModel.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 21/04/2024.
//

import Foundation

protocol HomeViewModelProtocol {
    
    func getCaptainDetails()
    func getOrdersDetails(orderIDs: [String])
    func acceptOrder(orderID: String, captainLat: String, captainLng: String)
    
    var captainDetailsResult: Observable<RegisterModel?> { get set }
    var orderDetailsResult:Observable<OrdersDetailsModel?> { get set }
    var acceptResult:Observable<Model?> { get set }
    var captainData: Observable<[String: Any]?>{get set}
    var errorMessage:Observable<String?> { get set }
    
}

class HomeViewModel: HomeViewModelProtocol {
    
    var captainDetailsResult: Observable<RegisterModel?>  = Observable(nil)
    var orderDetailsResult: Observable<OrdersDetailsModel?>  = Observable(nil)
    var acceptResult: Observable<Model?>  = Observable(nil)
    var captainData: Observable<[String: Any]?> = Observable(nil)
    var errorMessage: Observable<String?> = Observable(nil)
    
    var api: HomeApiProtocol
    
    init(api: HomeApi) {
        self.api = api
    }
    
    func getCaptainDetails() {
        self.api.getCaptainDetails { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.captainDetailsResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func getOrdersDetails(orderIDs: [String]) {
        print("Received orderIDs: \(orderIDs)")
        self.api.getOrdersDetails(orderIDs: orderIDs) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.orderDetailsResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func acceptOrder(orderID: String, captainLat: String, captainLng: String) {
        self.api.acceptOrder(orderID: orderID, captainLat: captainLat, captainLng: captainLng) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.acceptResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func observeOrders(captainId: String) {
        FirebaseManager.shared.observeNewOrdersAddedToCaptain(captainId: captainId) { captainData in
                guard let captainData = captainData else {
                    return
                }
                self.captainData.value = captainData
                print("New Orders: \(captainData)")
            }
        }
}
