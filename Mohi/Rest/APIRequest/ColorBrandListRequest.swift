//
//  ColorBrandListRequest.swift
//  Mohi
//
//  Created by Consagous on 24/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import Foundation
import SwiftEventBus

class ColorBrandListRequest: BaseRequest<APIResponseParam.ColorBrandList> {
    private var callBackSuccess:((_ response:APIResponseParam.ColorBrandList)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(onSuccess:((_ response:APIResponseParam.ColorBrandList)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        
        //        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kColorBrandList)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT_PRODUCT_API)
        
        print("urlString====>%@",urlString ?? "")
        
        //Get Header Parameters
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Set Method Type
        methodType = .POST
        
        super.main()
    }
    
    override func onSuccess(_ responseView:APIResponseParam.ColorBrandList?){
        AppConstant.kLogString(responseView ?? "")
        if(responseView != nil && responseView?.colorBrandDataList != nil) {
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
