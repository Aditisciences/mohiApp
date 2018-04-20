//
//  DeleteShippingAddressRequest.swift
//  Mohi
//
//  Created by Mac on 04/12/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

class DeleteShippingAddressRequest: BaseRequest<APIResponseParam.ShippingAddress> {
    private var deleteShippingAddress:APIRequestParam.DeleteShippingAddress?
    private var callBackSuccess:((_ response:APIResponseParam.ShippingAddress)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(deleteShippingAddress:APIRequestParam.DeleteShippingAddress?, onSuccess:((_ response:APIResponseParam.ShippingAddress)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.deleteShippingAddress = deleteShippingAddress
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        
        //        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kDeleteShippingAddress)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT)
        
        print("urlString====>%@",urlString ?? "")
        
        //Get Header Parameters
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Set Method Type
        methodType = .POST
        
        //Conver data to JSON String
        let deleteShippingAddressDataStr = deleteShippingAddress?.toJSONString()
        
        //Set Post Data
        postData = deleteShippingAddressDataStr!.data(using: String.Encoding.utf8)!
        
        super.main()
    }
    
    override func onSuccess(_ responseView:APIResponseParam.ShippingAddress?){
        AppConstant.kLogString(responseView ?? "")
        
        // add default shipping address
        if(responseView?.shippingAddressData != nil){
            // remove previous save shipping address
            ApplicationPreference.removeAddressInfo()
            
            let addressInfo = responseView?.shippingAddressData?.toJSON() as NSDictionary?
            ApplicationPreference.saveAddressInfo(addressInfo:addressInfo!)
        } else {
            // remove previous save shipping address
            ApplicationPreference.removeAddressInfo()
        }
        
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
