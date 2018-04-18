//
//  ProfileRequest.swift
//  DrApp
//
//  Created by Apple on 29/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation
import SwiftEventBus

class ProfileRequest: BaseRequest<APIResponseParam.Login> {
    private var profile:APIRequestParam.Profile?
    private var callBackSuccess:((_ response:APIResponseParam.Login)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(profile:APIRequestParam.Profile?, onSuccess:((_ response:APIResponseParam.Login)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.profile = profile
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        
        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kProfile)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT)
        
        //Change with actual user current token
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Set Method Type
        methodType = .POST
        
        //Conver data to JSON String
        let profileStr = profile?.toJSONString()
        
        //Set Post Data
        postData = profileStr!.data(using: String.Encoding.utf8)!
        
        super.main()
    }
    
    override func onSuccess(_ responseView:APIResponseParam.Login?){
        AppConstant.kLogString(responseView ?? "")
        if(responseView != nil && responseView?.message != nil) {
            SwiftEventBus.unregister(self)
            SwiftEventBus.post(APIConfigConstants.kRequestOtpSuccess, sender: responseView)
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
