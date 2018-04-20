//
//  GetFilterListItemsRequest.swift
//  Mohi
//
//  Created by Mac on 08/12/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

class GetFilterListItemsRequest: BaseRequest<APIResponseParam.GetFilterListItems> {
    private var callBackSuccess:((_ response:APIResponseParam.GetFilterListItems)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(onSuccess:((_ response:APIResponseParam.GetFilterListItems)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        
        //        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kGetFilterListItems)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT_PRODUCT_API)
        
        print("urlString====>%@",urlString ?? "")
        
        //Get Header Parameters
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Set Method Type
        methodType = .GET
        
        super.main()
    }
    
    override func onSuccess(_ responseView:APIResponseParam.GetFilterListItems?){
        AppConstant.kLogString(responseView ?? "")
        if(responseView != nil && responseView?.getFilterListItemsData != nil) {
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
