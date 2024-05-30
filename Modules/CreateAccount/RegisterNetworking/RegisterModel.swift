//
//  RegisterModel.swift
//  Hamla
//
//  Created by Bassant on 15/04/2024.
//

import Foundation

struct RegisterModel: Codable {
    let status: Int
    let message: String
    let data: CaptainData?
}

struct CaptainData: Codable {
    let id: Int?
    let fullName: String?
    let code: String?
    let gender: String?
    let suspend: Bool?
    let birthday: String?
    let mobile: String?
    let email: String?
    let avatar: String?
    let rate: Int?
    let isActive: Bool?
    let available: Bool?
    let inOrder: Bool?
    let truck: Truck?
    let ordersCount: Int?
    let walletBalance: Double?
    let language: String?
    let isDarkMode: Bool?
    let verified: String?
    let tokenType: String?
    let accessToken: String?
    let appVersionIos: String?
    let minVersionIos: [String: String]?
    let appVersionAndroid: String?
    let minVersionAndroid: [String: String]?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case code
        case gender
        case suspend
        case birthday
        case mobile
        case email
        case avatar
        case rate
        case isActive = "is_active"
        case available
        case inOrder = "in_order"
        case truck
        case ordersCount = "orders_count"
        case walletBalance = "wallet_balance"
        case language
        case isDarkMode = "is_dark_mode"
        case verified
        case tokenType = "token_type"
        case accessToken = "access_token"
        case appVersionIos = "app_version_ios"
        case minVersionIos = "min_version_ios"
        case appVersionAndroid = "app_version_android"
        case minVersionAndroid = "min_version_android"
    }
}

struct Truck: Codable {
    let plate: String?
    let color: String?
    let type: String?
}
