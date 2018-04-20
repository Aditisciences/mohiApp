//
//  FilterProductRequest.swift
//  Mohi
//
//  Created by Mac on 09/12/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

class FilterProductRequest: BaseRequest<APIResponseParam.Product> {
    private var filterProductData:APIRequestParam.FilterProduct?
    private var callBackSuccess:((_ response:APIResponseParam.Product)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(filterProductData:APIRequestParam.FilterProduct?, onSuccess:((_ response:APIResponseParam.Product)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.filterProductData = filterProductData
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        
        //        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kFilterProduct)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT_PRODUCT_API)
        
        print("urlString====>%@",urlString ?? "")
        
        //Get Header Parameters
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Set Method Type
        methodType = .POST
        
        //Conver data to JSON String
        let filterProductDataStr = filterProductData?.toJSONString()
        
        //Set Post Data
        postData = filterProductDataStr!.data(using: String.Encoding.utf8)!
        
        super.main()
    }
    
    override func onSuccess(_ responseView:APIResponseParam.Product?){
        AppConstant.kLogString(responseView ?? "")
        if(responseView != nil && responseView?.productData != nil) {
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
