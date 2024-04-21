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
    var heroCode         = "captain_code"
    var isDarkMode       = "isDarkMode"
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
        UserDefaults.standard.setValue(model.email ?? "", forKey: Keys.email)
        UserDefaults.standard.setValue(model.gender ?? "", forKey: Keys.gender)
        UserDefaults.standard.setValue(model.fullName ?? "", forKey: Keys.username)
        UserDefaults.standard.setValue(model.mobile ?? "", forKey: Keys.phone)
        UserDefaults.standard.setValue(model.accessToken ?? "", forKey: Keys.token)
        UserDefaults.standard.setValue(model.avatar ?? "", forKey: Keys.image)
        setLogin(value: true)
      }
     
    
    func setLogin(value: Bool) {
        UserDefaults.standard.setValue(value, forKey: Keys.login)
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
    
    func setheroCode(code:String) {
        UserDefaults.standard.setValue(code, forKey: Keys.heroCode)
    }
    
    func isDarkMode(status:Bool) {
        UserDefaults.standard.setValue(status , forKey: Keys.isDarkMode)
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
    func getheroCode() -> String { UserDefaults.standard.value(forKey: Keys.heroCode) as? String ?? ""}
    func getStatusDarkMode() -> Bool { UserDefaults.standard.value(forKey: Keys.isDarkMode) as? Bool ?? false}

    // MARK: - logOut
    
    func logOut() {
        UserDefaults.standard.removeObject(forKey: Keys.lang)
        UserDefaults.standard.setValue(false, forKey: Keys.login)
        UserDefaults.standard.removeObject(forKey: Keys.email)
        UserDefaults.standard.removeObject(forKey: Keys.gender)
        UserDefaults.standard.removeObject(forKey: Keys.username)
        UserDefaults.standard.removeObject(forKey: Keys.id)
        UserDefaults.standard.removeObject(forKey: Keys.phone)
        UserDefaults.standard.removeObject(forKey: Keys.token)
        UserDefaults.standard.removeObject(forKey: Keys.image)
        UserDefaults.standard.removeObject(forKey: Keys.rank)
        UserDefaults.standard.removeObject(forKey: Keys.available)
        UserDefaults.standard.removeObject(forKey: Keys.heroCode)
    }
    
     func setRootViewController(_ viewController: UIViewController) {
         if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
             if let window = windowScene.windows.first {
                 window.rootViewController = viewController
             }
         }
    }
 
}
