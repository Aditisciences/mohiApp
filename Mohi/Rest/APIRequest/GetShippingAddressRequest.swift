//
//  GetShippingAddressRequest.swift
//  Mohi
//
//  Created by RajeshYadav on 29/11/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation
import SwiftEventBus

class GetShippingAddressRequest: BaseRequest<APIResponseParam.ShippingAddressList> {
    private var getShippingAddress:APIRequestParam.GetShippingAddress?
    private var callBackSuccess:((_ response:APIResponseParam.ShippingAddressList)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(getShippingAddress:APIRequestParam.GetShippingAddress?, onSuccess:((_ response:APIResponseParam.ShippingAddressList)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.getShippingAddress = getShippingAddress
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        
        //        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kGetShippingAddress)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT)
        
        print("urlString====>%@",urlString ?? "")
        
        //Get Header Parameters
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Set Method Type
        methodType = .POST
        
        //Conver data to JSON String
        let getShippingAddressDataStr = getShippingAddress?.toJSONString()
        
        //Set Post Data
        postData = getShippingAddressDataStr!.data(using: String.Encoding.utf8)!
        
        super.main()
    }
    
    override func onSuccess(_ responseView:APIResponseParam.ShippingAddressList?){
        AppConstant.kLogString(responseView ?? "")
        if(responseView != nil && responseView?.shippingAddressDataList != nil) {
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
