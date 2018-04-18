//
//  BannerRequest.swift
//  Mohi
//
//  Created by Mac on 08/12/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

class BannerRequest: BaseRequest<APIResponseParam.Banner> {
    private var bannerRequestData:APIRequestParam.Banner?
    private var callBackSuccess:((_ response:APIResponseParam.Banner)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    init(bannerRequestData:APIRequestParam.Banner?, onSuccess:((_ response:APIResponseParam.Banner)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.bannerRequestData = bannerRequestData
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        
        //        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kBanner)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT_PRODUCT_API)
        
        print("urlString====>%@",urlString ?? "")
        
        //Get Header Parameters
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Set Method Type
        methodType = .POST
        
        //Conver data to JSON String
        let bannerRequestDataStr = bannerRequestData?.toJSONString()
        
        //Set Post Data
        postData = bannerRequestDataStr!.data(using: String.Encoding.utf8)!
        
        super.main()
    }
    
    override func onSuccess(_ responseView:APIResponseParam.Banner?){
        AppConstant.kLogString(responseView ?? "")
        if(responseView != nil && responseView?.bannerData != nil) {
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
