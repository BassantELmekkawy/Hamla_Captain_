//
//  UserInfo.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 21/04/2024.
//

import Foundation
import UIKit

class UserModelKeys{
    var id               = "id"
    var lang             = "language"
    var login            = "login"
    var email            = "email"
    var gender           = "gender"
    var username         = "username"
    var phone            = "phone"
    var token            = "auth-token"
    var image            = "image"
    var rate             = "rate"
    var available        = "available"
    var rank             = "rank"
    var captainCode         = "captain_code"
    var isDarkMode       = "isDarkMode"
    var isPhoneVerified  = "isPhoneVerified"
    var captainOnOrder   = "captainOnOrder"
    var plateNumber      = "plateNumber"
    var truckColor       = "truckColor"
    var truckType        = "truckType"
}
 

class UserInfo{
    private var Keys = UserModelKeys()
    
    static var shared: UserInfo = {
        let object = UserInfo()
        return object
    }()
    
    private init() {}
    
    // MARK: - setters
    
    func setData(model: CaptainData) {
        UserDefaults.standard.setValue(model.id ?? 0, forKey: Keys.id)
        UserDefaults.standard.setValue(model.code ?? 0, forKey: Keys.captainCode)
        UserDefaults.standard.setValue(model.email ?? "", forKey: Keys.email)
        UserDefaults.standard.setValue(model.gender ?? "", forKey: Keys.gender)
        UserDefaults.standard.setValue(model.fullName ?? "", forKey: Keys.username)
        UserDefaults.standard.setValue(model.mobile ?? "", forKey: Keys.phone)
        UserDefaults.standard.setValue(model.accessToken ?? "", forKey: Keys.token)
        UserDefaults.standard.setValue(model.avatar ?? "", forKey: Keys.image)
        UserDefaults.standard.setValue(model.truck?.plate ?? "", forKey: Keys.plateNumber)
        UserDefaults.standard.setValue(model.truck?.color ?? "", forKey: Keys.truckColor)
        UserDefaults.standard.setValue(model.truck?.type ?? "", forKey: Keys.truckType)
        setLogin(value: true)
      }
     
    
    func setLogin(value: Bool) {
        UserDefaults.standard.setValue(value, forKey: Keys.login)
    }
    
    func setPhone(phone: String) {
        UserDefaults.standard.setValue(phone, forKey: Keys.phone)
    }
    
    func setToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: Keys.token)
    }
   
     
    func setImage(image:String) {
        UserDefaults.standard.setValue(image , forKey: Keys.image)
    }
    
    func setavailable(available: Int) {
        UserDefaults.standard.setValue(available, forKey: Keys.available)
    }
    
    func setCaptainCode(code:String) {
        UserDefaults.standard.setValue(code, forKey: Keys.captainCode)
    }
    
    func isDarkMode(status:Bool) {
        UserDefaults.standard.setValue(status , forKey: Keys.isDarkMode)
    }
    
    func isPhoneVerified(status:Bool) {
        UserDefaults.standard.setValue(status , forKey: Keys.isPhoneVerified)
    }
    
    func setCaptainOnOrder(status: Bool) {
        UserDefaults.standard.setValue(status , forKey: Keys.captainOnOrder)
    }
    
    func getLogin() -> Bool{ return UserDefaults.standard.value(forKey: Keys.login) as? Bool ?? false }
    
    func get_email() -> String { UserDefaults.standard.value(forKey: Keys.email) as? String ?? "" }
    func get_gender() -> String { UserDefaults.standard.value(forKey: Keys.gender) as? String ?? "" }
    
    func get_username() -> String { UserDefaults.standard.value(forKey: Keys.username) as? String ?? ""}
    
    func get_ID() -> Int { UserDefaults.standard.value(forKey: Keys.id) as? Int ?? 0 }
    func get_phone() -> String { UserDefaults.standard.value(forKey: Keys.phone) as? String ?? "" }
    func get_token() -> String { UserDefaults.standard.value(forKey: Keys.token) as? String ?? "" }
    func get_image () -> String { UserDefaults.standard.value(forKey: Keys.image) as? String ?? ""}
    func get_rate ()-> Double { UserDefaults.standard.value(forKey: Keys.rate) as? Double ?? 0}
    func get_available ()-> Int { UserDefaults.standard.value(forKey: Keys.available) as? Int ?? 0}
    func get_rank ()-> Int { UserDefaults.standard.value(forKey: Keys.rank) as? Int ?? 0}
    func getCaptainCode() -> String { UserDefaults.standard.value(forKey: Keys.captainCode) as? String ?? ""}
    func getPlateNumber() -> String { UserDefaults.standard.value(forKey: Keys.plateNumber) as? String ?? "" }
    func getTruckColor() -> String { UserDefaults.standard.value(forKey: Keys.truckColor) as? String ?? "" }
    func getTruckType() -> String { UserDefaults.standard.value(forKey: Keys.truckType) as? String ?? "" }
    func getStatusDarkMode() -> Bool { UserDefaults.standard.value(forKey: Keys.isDarkMode) as? Bool ?? false}
    func isPhoneVerified() -> Bool { UserDefaults.standard.value(forKey: Keys.isPhoneVerified) as? Bool ?? false}
    func isCaptainOnOrder() -> Bool { UserDefaults.standard.value(forKey: Keys.captainOnOrder) as? Bool ?? false}

    // MARK: - logOut
    
    func logOut() {
        UserDefaults.standard.removeObject(forKey: Keys.lang)
        UserDefaults.standard.setValue(false, forKey: Keys.login)
        UserDefaults.standard.setValue(false, forKey: Keys.isPhoneVerified)
        UserDefaults.standard.removeObject(forKey: Keys.email)
        UserDefaults.standard.removeObject(forKey: Keys.gender)
        UserDefaults.standard.removeObject(forKey: Keys.username)
        UserDefaults.standard.removeObject(forKey: Keys.id)
        UserDefaults.standard.removeObject(forKey: Keys.phone)
        UserDefaults.standard.removeObject(forKey: Keys.token)
        UserDefaults.standard.removeObject(forKey: Keys.image)
        UserDefaults.standard.removeObject(forKey: Keys.rank)
        UserDefaults.standard.removeObject(forKey: Keys.available)
        UserDefaults.standard.removeObject(forKey: Keys.captainCode)
    }
    
     func setRootViewController(_ viewController: UIViewController) {
         if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
             if let window = windowScene.windows.first {
                 let navigationController = UINavigationController(rootViewController: viewController)
                 window.rootViewController = navigationController
             }
         }
    }
 
}
