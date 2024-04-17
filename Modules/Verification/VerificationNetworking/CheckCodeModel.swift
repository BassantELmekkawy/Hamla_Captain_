//
//  CheckCodeModel.swift
//  Hamla
//
//  Created by Bassant on 05/04/2024.
//

import Foundation

struct CheckCodeModel: Codable {
    let status: Int
    let message: String
    let is_new: Bool?
    let data: UserData?
    
    struct UserData: Codable {
        let id: Int
        let fullName: String
        let code: String
        let gender: String
        let suspend: Bool
        let birthday: String
        let mobile: String
        let email: String
        let avatar: String
        let rate: Int
        let isActive: Bool
        let available: Bool
        let inTrip: Bool
        let language: String
        let isDarkMode: Bool
        let verified: Bool?
        let tokenType: String
        let accessToken: String
        let appVersionIos: String
        let minVersionIos: String
        let appVersionAndroid: String
        let minVersionAndroid: String
        
//        enum CodingKeys: String, CodingKey {
//            case id, fullName, code, gender, suspend, birthday, mobile, email, avatar, rate, isActive, available, inTrip, language, isDarkMode, verified, tokenType, accessToken
//            case appVersionIos = "app_version_ios"
//            case minVersionIos = "min_version_ios"
//            case appVersionAndroid = "app_version_android"
//            case minVersionAndroid = "min_version_android"
//        }
    }
}
