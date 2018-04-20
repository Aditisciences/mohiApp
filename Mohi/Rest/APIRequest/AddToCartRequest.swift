//
//  AddToCartRequest.swift
//  Mohi
//
//  Created by Consagous on 30/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import Foundation
import SwiftEventBus

class AddToCartRequest: BaseRequest<APIResponseParam.AddToCart> {
    private var productData:APIRequestParam.AddToCart?
    private var callBackSuccess:((_ response:APIResponseParam.AddToCart)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(productData:APIRequestParam.AddToCart, onSuccess:((_ response:APIResponseParam.AddToCart)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.productData = productData
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        //        let authApi = AuthApi()
        //        self.request = authApi.loginUser(loginUser: loginData)
        
        //        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kADDToCart)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT_PRODUCT_API)
        
        //Get Header Parameters
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Conver data to JSON String
        let validateOtpReqViewStr = productData?.toJSONString()
        
        //Set Method Type
        methodType = .POST
        
        //Set Post Data
        postData = validateOtpReqViewStr!.data(using: String.Encoding.utf8)!
        super.main()
    }
    
    override func onSuccess(_ responseView:APIResponseParam.AddToCart?){
        AppConstant.kLogString(responseView ?? "")
        if(responseView != nil && responseView != nil) {
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
