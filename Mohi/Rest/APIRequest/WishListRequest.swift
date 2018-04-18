//
//  WishListRequest.swift
//  Mohi
//
//  Created by Consagous on 30/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import Foundation
import SwiftEventBus

class WishListRequest: BaseRequest<APIResponseParam.WishList> {
    private var productData:APIRequestParam.WishList?
    private var callBackSuccess:((_ response:APIResponseParam.WishList)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(wishListData:APIRequestParam.WishList, onSuccess:((_ response:APIResponseParam.WishList)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.productData = wishListData
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        //        let authApi = AuthApi()
        //        self.request = authApi.loginUser(loginUser: loginData)
        
        //        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kGETWishList)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT_PRODUCT_API)
        print("urlString====>%@",urlString ?? "")
        print("RequestParaMeter====>%@",self.productData ?? "")
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
    
    override func onSuccess(_ responseView:APIResponseParam.WishList?){
        AppConstant.kLogString(responseView ?? "")
        if(responseView != nil && responseView?.wishListData != nil) {
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
