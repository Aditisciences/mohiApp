//
//  RegistrationRequest.swift
//


import Foundation
import SwiftEventBus

class RegistrationRequest: BaseRequest<APIResponseParam.Login> {
    private var registrationData:APIRequestParam.Registration?
    private var callBackSuccess:((_ response:APIResponseParam.Login)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(registrationData:APIRequestParam.Registration, onSuccess:((_ response:APIResponseParam.Login)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.registrationData = registrationData
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        //        let authApi = AuthApi()
        //        self.request = authApi.loginUser(loginUser: loginData)
        
        //        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kRegistration)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT)
        
        //Get Header Parameters
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Conver data to JSON String
        let validateOtpReqViewStr = registrationData?.toJSONString()
        
        //Set Method Type
        methodType = .POST
        
        //Set Post Data
        postData = validateOtpReqViewStr!.data(using: String.Encoding.utf8)!
        super.main()
    }
    
    override func onSuccess(_ responseView:APIResponseParam.Login?){
        AppConstant.kLogString(responseView ?? "")
        if(responseView != nil && responseView?.loginData != nil) {
            
            // update prefrence info
            ApplicationPreference.saveAppToken(appToken: responseView?.loginData?.token ?? "")
            ApplicationPreference.saveUserId(appToken: "\(responseView?.loginData?.user_id ?? 0)")
            //TODO: Save Address Id
            let loginInfo: NSDictionary = responseView?.toJSON() as! NSDictionary
            ApplicationPreference.saveLoginInfo(loginInfo: loginInfo)
            
            // add default shipping address
            if(responseView?.loginData?.address != nil && responseView?.loginData?.address?.address_id != nil){
                let addressInfo = responseView?.loginData?.address?.toJSON() as NSDictionary?
                ApplicationPreference.saveAddressInfo(addressInfo:addressInfo!)
            }
            
            // notify message
            SwiftEventBus.post(APIConfigConstants.kRequestOtpSuccess, sender: responseView)
            SwiftEventBus.unregister(self)
        }else{
            SwiftEventBus.post(APIConfigConstants.kRequestOtpFailure)
        }
        
        if(callBackSuccess != nil){
            callBackSuccess!(responseView!)
        }
    }
    
    override func onError(_ response:ErrorModel) {
        AppConstant.kLogString(response)
        SwiftEventBus.post(APIConfigConstants.kRequestOtpFailure, sender: response)
        
        if(callBackError != nil){
            callBackError!(response)
        }
    }
}
