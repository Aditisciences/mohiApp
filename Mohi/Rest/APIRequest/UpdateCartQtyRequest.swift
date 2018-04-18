//
//  UpdateCartQtyRequest.swift
//  Mohi
//
//  Created by Mac on 08/12/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation


class UpdateCartQtyRequest: BaseRequest<APIResponseParam.BaseResponse> {
    private var updateCartQty:APIRequestParam.UpdateCartQty?
    private var callBackSuccess:((_ response:APIResponseParam.BaseResponse)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(updateCartQty:APIRequestParam.UpdateCartQty?, onSuccess:((_ response:APIResponseParam.BaseResponse)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.updateCartQty = updateCartQty
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        
        //        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kUpdateCartQty)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT_PRODUCT_API)
        
        print("urlString====>%@",urlString ?? "")
        
        //Get Header Parameters
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Set Method Type
        methodType = .POST
        
        //Conver data to JSON String
        let updateCartQtyDataStr = updateCartQty?.toJSONString()
        
        //Set Post Data
        postData = updateCartQtyDataStr!.data(using: String.Encoding.utf8)!
        
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
