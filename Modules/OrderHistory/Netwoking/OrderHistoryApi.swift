//
//  OrderHistoryApi.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 26/05/2024.
//

import Foundation

protocol OrderHistoryApiProtocol {
    
    func myOrders(type: String, completion: @escaping (Result<OrdersDetailsModel? , CustomError>) -> Void)
}

class OrderHistoryApi: BaseAPI<OrderHistoryNetworking>,OrderHistoryApiProtocol{
    
    func myOrders(type: String, completion: @escaping (Result<OrdersDetailsModel?, CustomError>) -> Void) {
        self.performRequest(target: .myOrders(type: type), responseClass: OrdersDetailsModel.self) { result in
            print("result", result)
            completion(result)
        }
    }
    
}
