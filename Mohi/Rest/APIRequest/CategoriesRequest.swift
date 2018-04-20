//
//  CategoriesRequest.swift
//  Mohi
//
//  Created by Consagous on 25/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import Foundation
import SwiftEventBus

class CategoriesRequest: BaseRequest<APIResponseParam.Categories> {
    
    private var categoriesData:APIRequestParam.Categories?
    private var callBackSuccess:((_ response:APIResponseParam.Categories)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(categoriesData:APIRequestParam.Categories, onSuccess:((_ response:APIResponseParam.Categories)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.categoriesData = categoriesData
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        //        let authApi = AuthApi()
        //        self.request = authApi.loginUser(loginUser: loginData)
        
        //        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kGetCategories)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT_PRODUCT_API)
        
        //Get Header Parameters
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Conver data to JSON String
        let validateOtpReqViewStr = categoriesData?.toJSONString()
        
        //Set Method Type
        methodType = .POST
        
        //Set Post Data
        postData = validateOtpReqViewStr!.data(using: String.Encoding.utf8)!
        super.main()
    }
    
    override func onSuccess(_ responseView:APIResponseParam.Categories?){
        AppConstant.kLogString(responseView ?? "")
        if(responseView != nil && responseView?.categoriesData != nil) {
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
