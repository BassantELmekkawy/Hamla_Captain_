//
//  RegisterModel.swift
//  Hamla
//
//  Created by Bassant on 15/04/2024.
//

import Foundation

struct RegisterModel: Codable {
    let status: Int?
    let message: String?
    let data: CaptainData?
}

struct CaptainData: Codable {
    var id: Int?
    var fullName: String?
    var code: String?
    var gender: String?
    var suspend: Bool?
    var birthday: String?
    var mobile: String?
    var email: String?
    var avatar: String?
    var rate: Double?
    var isActive: Bool?
    var available: Bool?
    var inOrder: Bool?
    var truck: Truck?
    var ordersCount: Int?
    var walletBalance: Double?
    var language: String?
    var isDarkMode: Bool?
    var verified: String?
    var tokenType: String?
    var accessToken: String?
    var appVersionIos: String?
    var minVersionIos: [String: String]?
    var appVersionAndroid: String?
    var minVersionAndroid: [String: String]?

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
