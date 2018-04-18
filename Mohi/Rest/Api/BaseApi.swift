//
//  BaseApi.swift
//  MyPanditJi
//

import Foundation

class BaseApi: NSObject {
    
    func toString(_ object: AnyObject?) -> String?{
        return String(format: "%@", object as! NSString)
    }
    
    func urlEncode(_ object: AnyObject?) -> String?{
        let string: String = toString(object)!
        return string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
    
    func urlEncodedString(_ dict: NSDictionary?, restUrl: String?, baseUrl:String? = nil) -> String{
        
        let parts: NSMutableArray = []
        if(dict != nil)
        {
            for (key,value) in dict!{
                let part = String(format: "%@=%@", urlEncode(key as AnyObject?)!,urlEncode(value as AnyObject?)!)
                parts.add(part)
            }
        }
        
        let queryString: NSString = (parts.componentsJoined(by: "&") as NSString)
        var urlString: NSString = ""
        
        if(baseUrl != nil){
            if(queryString.length > 0){
                urlString = NSString(format: "%@%@?%@",baseUrl!,restUrl!,queryString )
            }
            else{
                urlString = NSString(format: "%@%@",baseUrl!,restUrl! )
            }
        }else{
            if(queryString.length > 0){
                urlString = NSString(format: "%@%@?%@",baseUrl!,restUrl!,queryString )
            }
            else{
                urlString = NSString(format: "%@%@", baseUrl!, restUrl! )
            }
        }
        return  urlString as String
    }
    
    func getDefaultHeaders() -> NSDictionary{
        let headers: NSMutableDictionary = ["Content-Type":"application/json","Accept":"application/json","x-request-os":"ios","Version":"1","Deviceid":"gjhjhg"]
        //        let headers: NSMutableDictionary = [:]
        headers.setValue(APIParamConstants.API_VERSION, forKey: APIConfigConstants.kVersion)
        //headers.setValue(APIParamConstants.kDevice_id, forKey: (BaseApp.sharedInstance.deviceInfo?.advertisingID)!)
         headers.setValue((BaseApp.sharedInstance.deviceInfo?.advertisingID)!, forKey: APIParamConstants.kDevice_id)
        //        if let accessToken: NSString? = NetworkManager.sharedInstance.accessToken as NSString?? {
        //            let value: NSString = NSString(format: "bearer %@",accessToken!)
        //            headers.setValue(value, forKey: NetworkConfigConstants.kAuthorization)
        //        }
        return headers;
    }
    
    func getCustomHeaders(extraParameter:[String:String]) -> NSDictionary {
        let defaultHeaderValue = NSMutableDictionary(dictionary: getDefaultHeaders())
        
        for (key,value) in extraParameter{
            defaultHeaderValue.setValue(value, forKey: key)
        }
        
        return defaultHeaderValue
    }
    
    //MARK:- Get application http environment url dict
    class func getSelectedHttpEnvironment(_ env:String) -> NSDictionary {
        let urlPrefix = env
        
        print(urlPrefix)
        
//        http://www.mohi.ae/userApi.php?action=signUp
//                let BASE_URL = String(format: "http://www.mohi.ae/userApi.php?action=%@",urlPrefix)
        let BASE_URL = String(format: "https://www.mohi.in/api/userApi.php?action=%@",urlPrefix)
//         let BASE_URL = String(format: "http://www.mohi.in/userApi.php?action=%@",urlPrefix)
        
//        let BASE_URL = String(format: "http://111.118.252.147:80%@",urlPrefix)
        
//        let SERVER_API_VERSION_URL = "/doctorapp/api/";
//        
//        let SERVER_END_POINT =  BASE_URL + SERVER_API_VERSION_URL
        
        let dict = ["SERVER_END_POINT":BASE_URL]
        return dict as NSDictionary
    }
    
    
    //MARK:- Get application http environment url dict
    class func getSelectedHttpEnvironmentProduct(_ env:String) -> NSDictionary {
        let urlPrefix = env
        
        print(urlPrefix)
        
        //        http://www.mohi.ae/userApi.php?action=signUp
//        let BASE_URL = String(format: "http://www.mohi.ae/productApi.php?action=%@",urlPrefix)

        let BASE_URL = String(format: "https://www.mohi.in/api/productApi.php?action=%@",urlPrefix)

        //        let BASE_URL = String(format: "http://www.mohi.in/productApi.php?action=%@",urlPrefix)
        
        //        let BASE_URL = String(format: "http://111.118.252.147:80%@",urlPrefix)
        
        //        let SERVER_API_VERSION_URL = "/doctorapp/api/";
        //
        //        let SERVER_END_POINT =  BASE_URL + SERVER_API_VERSION_URL
        
        let dict = ["SERVER_END_POINT":BASE_URL]
        return dict as NSDictionary
    }
    
}
