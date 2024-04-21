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
    let inTrip: Bool?
    let language: String?
    let isDarkMode: Bool?
    let verified: Bool?
    let tokenType: String?
    let accessToken: String?
    let appVersionIos: String?
    let minVersionIos: [String: String]?
    let appVersionAndroid: String?
    let minVersionAndroid: [String: String]?

    enum CodingKeys: String, CodingKey {
        case id, fullName = "full_name", code, gender, suspend, birthday, mobile, email, avatar, rate, isActive = "is_active", available, inTrip = "in_trip", language, isDarkMode = "is_dark_mode", verified, tokenType = "token_type", accessToken = "access_token", appVersionIos = "app_version_ios", minVersionIos = "min_version_ios", appVersionAndroid = "app_version_android", minVersionAndroid = "min_version_android"
    }
}
