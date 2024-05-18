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
    var captainDetailsResult: Observable<RegisterModel?> { get set }
    var orderDetailsResult:Observable<OrdersDetailsModel?> { get set }
    var errorMessage:Observable<String?> { get set }
    
}

class HomeViewModel: HomeViewModelProtocol {
    
    var captainDetailsResult: Observable<RegisterModel?>  = Observable(nil)
    var orderDetailsResult: Observable<OrdersDetailsModel?>  = Observable(nil)
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
    
}
