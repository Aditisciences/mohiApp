//
//  MyOrderRequest.swift
//  Mohi
//
//  Created by RajeshYadav on 03/12/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

class GetOrderHistoryRequest: BaseRequest<APIResponseParam.GetOrderHistory> {
    private var getOrderHistoryData:APIRequestParam.GetOrderHistory?
    private var callBackSuccess:((_ response:APIResponseParam.GetOrderHistory)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(getOrderHistoryData:APIRequestParam.GetOrderHistory, onSuccess:((_ response:APIResponseParam.GetOrderHistory)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.getOrderHistoryData = getOrderHistoryData
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        //        let authApi = AuthApi()
        //        self.request = authApi.loginUser(loginUser: loginData)
        
        //        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kGetOrderHistory)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT_PRODUCT_API)
        
        //Get Header Parameters
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Set Method Type
        methodType = .POST
        
        //Conver data to JSON String
        let getOrderHistoryDataStr = getOrderHistoryData?.toJSONString()
        
        //Set Post Data
        postData = getOrderHistoryDataStr!.data(using: String.Encoding.utf8)!
        super.main()
    }
    
    override func onSuccess(_ responseView:APIResponseParam.GetOrderHistory?){
        AppConstant.kLogString(responseView ?? "")
//        if(responseView != nil && responseView?.productData != nil) {
//            SwiftEventBus.unregister(self)
//            SwiftEventBus.post(APIConfigConstants.kRequestOtpSuccess, sender: responseView)
//        }else{
//            SwiftEventBus.post(APIConfigConstants.kRequestOtpFailure)
//        }
        
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
