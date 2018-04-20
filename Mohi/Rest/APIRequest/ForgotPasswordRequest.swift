//
//  ForgotPasswordRequest.swift
//

import Foundation
import SwiftEventBus

class ForgotPasswordRequest: BaseRequest<APIResponseParam.BaseResponse> {
    private var forgotPasswordData:APIRequestParam.ForgotPassword?
    private var callBackSuccess:((_ response:APIResponseParam.BaseResponse)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(forgotPasswordData:APIRequestParam.ForgotPassword, onSuccess:((_ response:APIResponseParam.BaseResponse)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.forgotPasswordData = forgotPasswordData
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        
        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kForgotPassword)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT)
        
        //TODO: Change with actual user current token
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Conver data to JSON String
        let validateOtpReqViewStr = forgotPasswordData?.toJSONString()
        
        //Set Method Type
        methodType = .POST
        
        //Set Post Data
        postData = validateOtpReqViewStr!.data(using: String.Encoding.utf8)!
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
