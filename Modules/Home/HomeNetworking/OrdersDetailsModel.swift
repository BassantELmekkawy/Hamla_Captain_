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
    let id: Int?
    let code: String?
    let status: String?
    let statusTitle: String?
    let cost: String?
    let estimateTime: String?
    let dropoffLocationName: String?
    let dropoffLat: String?
    let dropoffLng: String?
    let pickupLocationName: String?
    let pickupLat: String?
    let pickupLng: String?
    let paymentMethod: String?
    let customer: Customer?
    let type: String?
    let estimateCost: String?

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
