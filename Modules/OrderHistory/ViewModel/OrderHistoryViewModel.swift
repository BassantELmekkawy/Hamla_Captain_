//
//  OrderHistoryViewModel.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 26/05/2024.
//

import Foundation

protocol OrderHistoryViewModelProtocol {
    
    func myOrders(type: String)
    
    var myOrdersResult:Observable<OrdersDetailsModel?> { get set }
    var errorMessage:Observable<String?> { get set }
    
}

class OrderHistoryViewModel: OrderHistoryViewModelProtocol {
    
    var myOrdersResult: Observable<OrdersDetailsModel?>  = Observable(nil)
    var errorMessage: Observable<String?> = Observable(nil)
    
    var api: OrderHistoryApiProtocol
    
    init(api: OrderHistoryApi) {
        self.api = api
    }
    
    func myOrders(type: String) {
        self.api.myOrders(type: type) { result in
        switch result {
            case .success(let result):
                print(result)
                self.myOrdersResult.value = result
            case .failure(let error):
                self.errorMessage.value = error.message
                
                print("error", error.message)

            }
        }
    }
    
}
