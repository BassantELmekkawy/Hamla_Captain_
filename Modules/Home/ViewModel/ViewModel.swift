//
//  ViewModel.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 21/04/2024.
//

import Foundation

protocol HomeViewModelProtocol {
    
    func getCaptainDetails()
    func isCaptainOnOrder()
    func getOrdersDetails(orderIDs: [String])
    func acceptOrder(orderID: String, captainLat: String, captainLng: String)
    func rejectOrder(orderID: String)
    
    var captainDetailsResult: Observable<RegisterModel?> { get set }
    var captainOnOrderResult: Observable<CaptainOnOrderModel?> { get set }
    var orderDetailsResult:Observable<OrdersDetailsModel?> { get set }
    var acceptResult:Observable<Model?> { get set }
    var rejectResult:Observable<Model?> { get set }
    var assignOrder: Observable<[Int]?>{get set}
    func updateAvailability(lat: String, lng: String)
    var updateAvailabilityResult:Observable<UpdateAvailabilityModel?> { get set }
    var errorMessage:Observable<String?> { get set }
    
}

class HomeViewModel: HomeViewModelProtocol {
    
    var captainDetailsResult: Observable<RegisterModel?>  = Observable(nil)
    var captainOnOrderResult: Observable<CaptainOnOrderModel?>  = Observable(nil)
    var orderDetailsResult: Observable<OrdersDetailsModel?>  = Observable(nil)
    var acceptResult: Observable<Model?>  = Observable(nil)
    var rejectResult: Observable<Model?>  = Observable(nil)
    var assignOrder: Observable<[Int]?> = Observable(nil)
    var updateAvailabilityResult: Observable<UpdateAvailabilityModel?>  = Observable(nil)
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
    
    func isCaptainOnOrder() {
        self.api.isCaptainOnOrder { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.captainOnOrderResult.value = result
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
    
    func updateAvailability(lat: String, lng: String) {
        self.api.updateAvailability(lat: lat, lng: lng) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.updateAvailabilityResult.value = result
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
    
    func rejectOrder(orderID: String) {
        self.api.rejectOrder(orderID: orderID) { result in
            
            switch result {
            case .success(let result):
                print(result)
                self.rejectResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
    func observeOrders(captainId: String) {
        removeOrdersObserver()
        FirebaseManager.shared.observeNewOrdersAddedToCaptain(captainId: captainId) { assignOrder in
            guard let assignOrder = assignOrder else {
                return
            }
            self.assignOrder.value = assignOrder
            print("New Orders: \(assignOrder)")
        }
    }
    
    func removeOrdersObserver() {
        FirebaseManager.shared.removeObserverForCaptain(captainId: String(UserInfo.shared.get_ID()))
    }
}
