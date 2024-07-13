//
//  EndOrderModel.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 25/05/2024.
//

import Foundation

struct EndOrderModel: Codable {
    let status: Int?
    let message: String?
    let data: PaymentData?
}

struct PaymentData: Codable {
    let id: Int?
    let cost: Double?
    let paymentMethodName: String?
    let paymentMethodType: String?
    let paymentMethodIcon: String?

    enum CodingKeys: String, CodingKey {
        case id
        case cost
        case paymentMethodName = "payment_method_name"
        case paymentMethodType = "payment_method_type"
        case paymentMethodIcon = "payment_method_icon"
    }
}
