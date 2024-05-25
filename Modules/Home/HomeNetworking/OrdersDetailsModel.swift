//
//  OrdersDetailsModel.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 17/05/2024.
//

import Foundation

// MARK: - Response
struct OrdersDetailsModel: Codable {
    let status: Int
    let message: String
    let data: [Order]?
}

// MARK: - Order
struct Order: Codable {
    var id: Int?
    var code: String?
    var status: String?
    var statusTitle: String?
    var cost: String?
    var estimateTime: String?
    var dropoffLocationName: String?
    var dropoffLat: String?
    var dropoffLng: String?
    var pickupLocationName: String?
    var pickupLat: String?
    var pickupLng: String?
    var paymentMethod: String?
    var customer: Customer?
    var type: String?
    var estimateCost: String?

    enum CodingKeys: String, CodingKey {
        case id, code, status
        case statusTitle = "status_title"
        case cost
        case estimateTime = "estimate_time"
        case dropoffLocationName = "dropoff_location_name"
        case dropoffLat = "dropoff_lat"
        case dropoffLng = "dropoff_lng"
        case pickupLocationName = "pickup_location_name"
        case pickupLat = "pickup_lat"
        case pickupLng = "pickup_lng"
        case paymentMethod = "payment_method"
        case customer, type
        case estimateCost = "estimate_cost"
    }
}

// MARK: - Customer
struct Customer: Codable {
    let id: Int?
    let fullName: String?
    let mobile: String?
    let code: String?
    let rate: Int?
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case mobile, code, rate, avatar
    }
}
