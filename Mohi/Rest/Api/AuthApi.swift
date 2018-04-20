//
//  AuthApi.swift
//  MyPanditJi
//

import Foundation
import Alamofire

class AuthApi: BaseApi {
    
    func loginUser(loginUser:APIRequestParam.Login?) -> DataRequest{
        let loginUserStr = loginUser!.toJSONString()
        // convert String to NSData
        let data = loginUserStr!.data(using: String.Encoding.utf8)!
        var request:DataRequest?
        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                AppConstant.kLogString("server Request: ")
                AppConstant.kLogString(jsonResult)
                
                let urlString = String(format:APIParamConstants.kLogin)
                request = Alamofire.request(urlEncodedString(nil, restUrl: urlString, baseUrl: APIParamConstants.kSERVER_END_POINT), method: .post, parameters: jsonResult as? Parameters, encoding: URLEncoding.default, headers: getDefaultHeaders() as? HTTPHeaders)
            }
        } catch let error as NSError {
            AppConstant.klogString(error.localizedDescription)
        }
        
        return request!
    }
    
//    func registerUser(registerUserReqView:RequestBody.RegisterUser? ,isOpenHttpCall:Bool) -> DataRequest{
//        let validateOtpReqViewStr = registerUserReqView!.toJSONString()
//        // convert String to NSData
//        let data = validateOtpReqViewStr!.data(using: String.Encoding.utf8)!
//        var request:DataRequest?
//        do {
//            if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
//                AppConstant.kLogString("server Request: ")
//                AppConstant.kLogString(jsonResult)
//                
//                let urlString = String(format:NetworkConfigConstants.kRegisterUser)
//                request = RestEngine.request(urlEncodedString(dict: nil, restUrl:urlString, isOpenHttpCall: isOpenHttpCall), method: .post, parameters: jsonResult as? Parameters, encoding: URLEncoding.default, headers: getDefaultHeaders() as? HTTPHeaders)
//            }
//        } catch let error as NSError {
//            AppConstant.klogString(error.localizedDescription)
//        }
//        
//        return request!
//    }
}
