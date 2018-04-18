//
//  AppConstant.swift
//

import Foundation
import UIKit

class AppConstant: NSObject {
    internal let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    internal static let IPHONE_X_DEFAULT_NAVIGATION_BAR_HEIGHT:CGFloat = 88
    internal static let IPHONE_X_DEFAULT_STATUS_BAR_HEIGHT:CGFloat = 44
    
    enum UIUserInterfaceIdiom : Int
    {
        case Unspecified
        case Phone
        case Pad
    }
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 1136.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 1136.0
        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 1334.0
        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 2208.0
        static let IS_IPHONE_X  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 2436.0
    }
    
    struct Platform {
        static let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
                isSim = true
            #endif
            return isSim
        }()
    }
    
    class func klogString(_ message: String,
                          function: String = #function,
                          file: String = #file,
                          line: Int = #line) {
        if(APIParamConstants.DEFAULT_ENV != APIParamConstants.Env.PRODUCTION.rawValue){
            print("Message \"\(message)\" (File: \(file), Function: \(function), Line: \(line))")
        }
    }
    
    class func kLogString(_ items: Any...){
        if(APIParamConstants.DEFAULT_ENV != APIParamConstants.Env.PRODUCTION.rawValue){
            print(items)
        }
    }
    
    class func klogInteger(_ logMessage: NSInteger, functionName: String = #function) {
        if(APIParamConstants.DEFAULT_ENV != APIParamConstants.Env.PRODUCTION.rawValue){
            print("\(functionName): \(logMessage)")
        }
    }
    class func klogNumber(_ logMessage: NSNumber, functionName: String = #function) {
        if(APIParamConstants.DEFAULT_ENV != APIParamConstants.Env.PRODUCTION.rawValue){
            print("\(functionName): \(logMessage)")
        }
    }
    
    class func getDeviceCurrentTimeMilliSeconds()-> CLong{
        return (CLong)(Date().timeIntervalSince1970*1000)
    }
    
    class func getDeviceCurrentTimeMilliSecondsForHttpRequest()-> CLong{
        return (CLong)(Date().timeIntervalSince1970)
    }
    
    //Default REST Error Code and Message
    internal static let DEFAULT_REST_ERROR_CODE = "default_rest_error_code"
    internal static let DEFAULT_REST_ERROR_MESSAGE = "Unable to process your request.\nPlease try again later."
    
    //USER DEFAULT KEY'S
    internal static let userDefaultAppTokenKey = "appToken"
    internal static let userDefaultUserId = "userId"
    internal static let userDefaultUserNameKey = "userName"
    internal static let kFcmToken = "fcm_token"
    internal static let kRefreshViewCart = "RefreshViewCart"
    
    internal static let userDefaultUserLoginInfoKey = "userLoginInfo"
    internal static let kAddressInfo = "AddressInfo"
    internal static let kDeviceType = "Apple"
    internal static let kRefreshScreenInfo = "RefreshScreenInfo"
    internal static let kRefreshProfileImage = "ProfileImage"
    
    internal static let LOCAL_NOTIFICATION_IDENTIFIER = "localNotification"
    
    //LOCALITY VALUES
    internal static let localCountryName = "name"
    internal static let localCountryDialCode = "dial_code"
    internal static let localCountryCode = "code"
    
    // Storyboard Name
    internal static let onBoardStoryboard = "OnBoardViewController"
    internal static let HamburgerStoryboard = "HamburgerViewController"
    
    // Side bar Storyboard Name
    internal static let CustomAlertStoryboard = "CustomAlert"
    internal static let DashboardStoryboard = "Dashboard"
    internal static let ShopByCategoryStoryboard = "ShopByCategory"
    internal static let DealOfTheDayStoryboard = "DealOfTheDay"
    internal static let YourOrdersStoryboard = "YourOrders"
    internal static let FilterVCStoryboard = "FilterVC"
    internal static let WishListStoryboard = "WishList"
    internal static let MyAccountStoryboard = "MyAccount"
    internal static let ProductVCStoryboard = "ProductVC"
    internal static let ProductDetailsVCStoryboard = "ProductDetailsVC"
    internal static let CartStoryboard = "Cart"
    internal static let MoreStoryboard = "More"
    internal static let SearchStoryboard = "Search"
    internal static let WebViewStoryboard = "WebView"
    internal static let BuyStoryboard = "Buy"
    internal static let kRefreshTableView = "RefreshTableView"
    
//    internal static let SettingStoryboard = "Setting"
//    internal static let SettingStoryboard = "Setting"
    
    internal static let ChatStoryboard = "Chat"
    internal static let NotificationStoryboard = "Notification"
    
    internal static let NUMBERS_ONLY = "1234567890"
    internal static let ALPHA_ONLY = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    internal static let ALPHA_NUMERIC_ONLY = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    internal static let  NUMBER_DECEIMAL_SYMBOLS = "1234567890$."
    internal static let  NUMBER_DECEIMAL = "1234567890."
    internal static let  EMAIL_ONLY = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.@"
    
    internal static let LIMIT_COUNTRY_CODE = 5
    internal static let LIMIT_LOWER_PASSWORD = 6
    internal static let LIMIT_UPPER_PASSWORD = 20
    internal static let LIMIT_NAME = 30
    internal static let LIMIT_ADDRESS = 180
    internal static let LIMIT_POSTCODE = 12
    internal static let LIMIT_EMAIL = 50
    internal static let LIMIT_PHONE_NUMBER = 18
    internal static let LIMIT_COUNTRY_CODE_LOWER_LIMIT = 2
    
    // Change after discussion
    //internal static let CURRENCY_SYMBOL = "AED"
    internal static let CURRENCY_SYMBOL = "INR"
    
    internal static let quantityArray = ["1", "2", "3", "4", "5"]
    
    internal static let WidthWithoutButton:CGFloat = 0
    internal static let WidthWithSearch:CGFloat = 44
}
