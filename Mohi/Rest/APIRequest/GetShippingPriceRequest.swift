//
//  GetShippingPriceRequest.swift
//  Mohi
//
//  Created by Apple_iOS on 24/01/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import Foundation

// getShippingPrice

class GetShippingPriceRequest: BaseRequest<APIResponseParam.GetShippingPrice> {
    private var getShippingPriceData:APIRequestParam.GetShippingPrice?
    private var callBackSuccess:((_ response:APIResponseParam.GetShippingPrice)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(getShippingPriceData:APIRequestParam.GetShippingPrice?, onSuccess:((_ response:APIResponseParam.GetShippingPrice)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.getShippingPriceData = getShippingPriceData
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        
        //        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kGetShippingPrice)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT_PRODUCT_API)
        
        print("urlString====>%@",urlString ?? "")
        
        //Get Header Parameters
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Set Method Type
        methodType = .POST
        
        //Conver data to JSON String
        let getShippingPriceDataStr = getShippingPriceData?.toJSONString()
        
        //Set Post Data
        postData = getShippingPriceDataStr!.data(using: String.Encoding.utf8)!
        
        super.main()
    }
    
    override func onSuccess(_ responseView:APIResponseParam.GetShippingPrice?){
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
