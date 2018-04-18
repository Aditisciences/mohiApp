//
//  ApplicationPreference.swift
//  MyPanditJi
//

import Foundation

class ApplicationPreference{
    
    fileprivate static let defaults = UserDefaults.standard
    
    //////////////// Remove all info //////
    class func clearAllData(){
        defaults.removeObject(forKey: AppConstant.userDefaultAppTokenKey)
        defaults.removeObject(forKey: AppConstant.userDefaultUserNameKey)
        defaults.removeObject(forKey: AppConstant.userDefaultUserLoginInfoKey)
        defaults.removeObject(forKey: AppConstant.kAddressInfo)
        defaults.removeObject(forKey: AppConstant.userDefaultUserId)
        defaults.synchronize()
    }
    
    //////////////// GET & SAVE APP TOKEN //////
    class func saveAppToken(appToken: String){
        defaults.set(appToken, forKey: AppConstant.userDefaultAppTokenKey)
        defaults.synchronize()
    }
    
    class func getAppToken()->String?{
        let appToken:String?
        appToken = defaults.object(forKey: AppConstant.userDefaultAppTokenKey) as? String
        return appToken ?? ""
    }
    
    //////////////// GET & SAVE User ID //////
    class func saveUserId(appToken: String){
        defaults.set(appToken, forKey: AppConstant.userDefaultUserId)
        defaults.synchronize()
    }
    
    class func getUserId()->String?{
        let appUserId:String?
        appUserId = defaults.object(forKey: AppConstant.userDefaultUserId) as? String
        return appUserId ?? ""
    }
    
    ///////////////// GET & SAVE UserName //////
    class func saveUserName(userName: String){
        defaults.set(userName, forKey: AppConstant.userDefaultUserNameKey)
        defaults.synchronize()
    }
    
    class func getUserName()->String?{
        let userName:String?
        userName = defaults.object(forKey: AppConstant.userDefaultUserNameKey) as? String
        return userName ?? nil
    }
    
    ///////////////// GET & SAVE UserName //////
    class func saveFcmToken(token: String){
        defaults.set(token, forKey: AppConstant.kFcmToken)
        defaults.synchronize()
    }
    
    class func getFcmToken()->String?{
        let token:String?
        token = defaults.object(forKey: AppConstant.kFcmToken) as? String
        return token ?? nil
    }
    
    class func removeFcmToken(){
        defaults.removeObject(forKey: AppConstant.kFcmToken)
        defaults.synchronize()
    }
    
    ///////////////// GET & SAVE Login Info //////
    class func saveLoginInfo(loginInfo: NSDictionary){
        defaults.set(loginInfo, forKey: AppConstant.userDefaultUserLoginInfoKey)
        defaults.synchronize()
    }
    
    class func getLoginInfo()->NSDictionary?{
        let loginInfo:NSDictionary?
        loginInfo = defaults.object(forKey: AppConstant.userDefaultUserLoginInfoKey) as? NSDictionary
        return loginInfo ?? nil
    }
    
    class func removeLoginInfo(){
        defaults.removeObject(forKey: AppConstant.userDefaultUserLoginInfoKey)
        defaults.synchronize()
    }
    
    ///////////////// GET & SAVE Address Id //////
    class func saveAddressInfo(addressInfo: NSDictionary){
        defaults.set(addressInfo, forKey: AppConstant.kAddressInfo)
        defaults.synchronize()
    }
    
    class func getAddressInfo()->NSDictionary?{
        let addressInfo: NSDictionary?
        addressInfo = defaults.object(forKey: AppConstant.kAddressInfo) as? NSDictionary
        return addressInfo ?? nil
    }
    
    class func removeAddressInfo(){
        defaults.removeObject(forKey: AppConstant.kAddressInfo)
        defaults.synchronize()
    }
}
