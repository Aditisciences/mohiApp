//
//  APIConfigConstants.swift
//  MyPanditJi
//

import Foundation

class APIConfigConstants: NSObject {
    
    internal static let kResponseStatus: String = "status"
    internal static let kResponseStatusOK:Int = 1
    internal static let kResponseData: String = "data"
    internal static let kVersion: String = "version"
    internal static let kLat: String = "Lat"
    internal static let kLong: String = "Long"
    internal static let kToken: String = "token"
    internal static let kUserId: String = "user_id"
    internal static let kFullName: String = "full_name"
    internal static let kEmail: String = "email_address"
    internal static let kImage:String = "image"
    internal static let kPassword:String = "password"
    internal static let kProfileImageKey = "user_profile"
    
    
    internal static let kID:String = "id"
    
    //EventBus constant
    internal static let kRequestOtpSuccess: String = "requestOtpSuccess"
    internal static let kRequestOtpFailure: String = "requestOtpFailure"
}
