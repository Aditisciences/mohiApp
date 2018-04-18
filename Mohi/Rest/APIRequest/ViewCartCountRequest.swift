//
//  ViewCartCountRequest.swift
//  Mohi
//
//  Created by Mac on 07/12/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

class ViewCartCountRequest: BaseRequest<APIResponseParam.ViewCartCount> {
    private var viewCartCount:APIRequestParam.ViewCartCount?
    private var callBackSuccess:((_ response:APIResponseParam.ViewCartCount)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(viewCartCount:APIRequestParam.ViewCartCount?, onSuccess:((_ response:APIResponseParam.ViewCartCount)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.viewCartCount = viewCartCount
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        
        //        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kViewCartCount)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT_PRODUCT_API)
        
        print("urlString====>%@",urlString ?? "")
        
        //Get Header Parameters
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Set Method Type
        methodType = .POST
        
        //Conver data to JSON String
        let viewCartCountDataStr = viewCartCount?.toJSONString()
        
        //Set Post Data
        postData = viewCartCountDataStr!.data(using: String.Encoding.utf8)!
        
        super.main()
    }
    
    override func onSuccess(_ responseView:APIResponseParam.ViewCartCount?){
        AppConstant.kLogString(responseView ?? "")
        if(responseView != nil && responseView?.viewCartCountData != nil) {
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
