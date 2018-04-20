//
//  ChangePasswordRequest.swift
//  Mohi
//
//  Created by Mac on 08/12/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

class ChangePasswordRequest: BaseRequest<APIResponseParam.BaseResponse> {
    private var changePassword:APIRequestParam.ChangePassword?
    private var callBackSuccess:((_ response:APIResponseParam.BaseResponse)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(changePassword:APIRequestParam.ChangePassword?, onSuccess:((_ response:APIResponseParam.BaseResponse)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.changePassword = changePassword
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        
        //        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kChangePassword)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT)
        
        print("urlString====>%@",urlString ?? "")
        
        //Get Header Parameters
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Set Method Type
        methodType = .POST
        
        //Conver data to JSON String
        let changePasswordDataStr = changePassword?.toJSONString()
        
        //Set Post Data
        postData = changePasswordDataStr!.data(using: String.Encoding.utf8)!
        
        super.main()
    }
    
    override func onSuccess(_ responseView:APIResponseParam.BaseResponse?){
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
