//
//  APIParamConstants.swift
//  MyPanditJi
//

import Foundation
import UIKit

class APIParamConstants: NSObject {
    
    internal static let API_VERSION = "1.0"
    
    // Api enviornment
    enum Env: String {
               case PRODUCTION = ""
//        case DEVELOPMENT = ""
    }
    
    
    //**********DEV***********
    //static let DEFAULT_ENV = Env.DEVELOPMENT.rawValue
//    static let DEFAULT_ENV = Env.DEVELOPMENT.rawValue
    //
    //    #else
    //        //******** PROD *********
            static let DEFAULT_ENV = Env.PRODUCTION.rawValue
    //    #endif
    
    
    internal static let kSERVER_END_POINT = BaseApi.getSelectedHttpEnvironment(DEFAULT_ENV).value(forKey: "SERVER_END_POINT") as! String
    
    
     internal static let kSERVER_END_POINT_PRODUCT_API = BaseApi.getSelectedHttpEnvironmentProduct(DEFAULT_ENV).value(forKey: "SERVER_END_POINT") as! String
    
    
    //REST or SOCKET Headers
    class HEADERS {
        internal static let AUTHORIZATION        = "Authorization"
        internal static let CONTENT_TYPE         = "content-type"
        
        //Common Headers
        internal static let X_TOKEN         = "token"       // token
        internal static let X_VERSION       = "version"     // version
        internal static let X_USER_ID       = "user_id"     // user id
    }
    
    //    class URLParam {
    //        internal static let ID = "id"
    //    }
    
    //MARK:- mark Sandbox Crenditials
    internal static let PAYUMONEY_ENV = 1 // 1 for Sandbox and 0 Production
    internal static let PAYUMONEY_KEY_PAYMENT_SALT = "ShzwoBLFVb";
    internal static let PAYUMONEY_KEY_PAYMENT_MID = "5970481";
    internal static let PAYUMONEY_KEY_PAYMENT_MERCHENT = "w7yOV1c1";

    
    //MARK:- mark Sandbox Crenditials
    class  PayUMoneyParam{
        //internal static let environment = PUMEnvironmentTest
        internal static let environment = 1
        internal static let key = "5970481";
        internal static let merchantid = "w7yOV1c1";
        internal static let payu_salt = "ShzwoBLFVb";
    }
    
    //MARK:- mark Production Crenditials
//    class  PayUMoneyParam{
//        //internal static let environment = PUMEnvironmentProduction
//        internal static let environment = 0
//        internal static let key = "";
//        internal static let merchantid = "";
//        internal static let payu_salt = "";
//    }
    
//    class WebSocket {
//        internal static let URL = "https://doctorappchat.herokuapp.com/" // TODO: Specific socket base url
//        internal static let TOKEN_PARAM = ""
//    }
//

    
    
    class DIR {
        internal static let IMAGE_DIRECTORY_NAME = "textApp_image"
        internal static let PROFILE_IMAGE_FILE_NAME = "profile.tmp"
    }
    
    class MIME {
        internal static let IMAGE_JPEG = "image/jpeg"
        internal static let APP_PDF = "application/pdf"
        internal static let AUDIO_MP4 = "audio/mp4"
    }
    
    class NetworkAPIStatusCode{
        internal static let SUCCESS  = 200
    }
    
    enum PaymentMode{
        case CREDIT
        case DEBIT
        case COD
    }
    
    enum PaymentMethodName:String{
        case checkmo
    }
    
    // Production
    internal static let productDetailUrl = "http://www.mohi.in/api/productDetail.php?product_id="
    internal static let needHelpUrl = "http://www.mohi.in/help.html"
    
    // Development
   // internal static let productDetailUrl = "http://www.mohi.ae/productDetail.php?product_id="
    //internal static let needHelpUrl = "http://www.mohi.ae/help.html"
    
    //internal static let kLogin = "login"
    internal static let kLogin = "login"
    internal static let kForgotPassword = "forgot"
    internal static let kRegistration = "signUp"
    internal static let kGetHomeScreenDetail = "getHomeScreenDetails"
    //internal static let kGetFeaturedProduct = "getFeaturedProduct"
    internal static let kGetCategories = "getCategories"
    internal static let kGetProduct = "getProduct"
    internal static let kGetDeals = "deals"
    internal static let kGetProductDetail = "getProductDetail"
    internal static let kAddToWishList = "addToWishlist"
    internal static let kRemoveFromWishList = "removeItemWishlist"
    internal static let kGETWishList = "wishlist"
    internal static let kADDToCart = "addToCart"
    internal static let kRemoveFromAddToCart = "removeItemFromCart"
    internal static let kGETAllCart = "getCart"
    internal static let kAddReview = "addReview"
    internal static let kPlaceOrder = "placeOrder"
    internal static let kProfile = "getProfile"
    internal static let kUpdateProfile = "updateProfile"
    internal static let kColorBrandList = "getColorBrandList"
    internal static let kAddShippingAddress = "addShippingAddress"
    internal static let kGetShippingAddress = "getShippingAddress"
    internal static let kUpdateShippingAddress = "updateShippingAddress"
    internal static let kDeleteShippingAddress = "deleteShippingAddress"
    internal static let kMobileVerification = "mobile_verification"
    internal static let kGetOrderHistory = "getOrderHistory"
    internal static let kViewCartCount = "viewCartCount"
    internal static let kChangePassword = "changePassword"
    internal static let kUpdateCartQty = "updateCartQty"
    internal static let kBanner = "banner"
    internal static let kGetFilterListItems = "getFilterListItems"
    internal static let kFilterProduct = "filterProduct"
    internal static let kCancelOrder = "cancelOrder"
    internal static let kDevice_id = "device_id"
    internal static let kCheckServiceAvailability = "checkServiceAvailability"
    internal static let kGetShippingPrice = "getShippingPrice"
    
    internal static let kLogout = "logout"
    internal static let kEditProfile = "editprofile"
    
    //internal static let kChangePassword = "password_change"
    internal static let kAds = "ads"
    
    internal static let kOtpVerify = "otp_verify"
    internal static let kClinicInformation = "clinic_infomation"
    internal static let kMyClinicHistory = "my_clinic_history"
    
    
}
