//
//  GetHomeScreenDetailsRequest.swift
//  Mohi
//
//  Created by Consagous on 24/11/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation
import SwiftEventBus

class GetHomeScreenDetailsRequest: BaseRequest<APIResponseParam.HomeScreenDetail> {
    private var homeScreenDetail:APIRequestParam.HomeScreenDetail?
    private var callBackSuccess:((_ response:APIResponseParam.HomeScreenDetail)->Void)?
    private var callBackError:((_ response:ErrorModel)->Void)?
    
    
    init(homeScreenDetail:APIRequestParam.HomeScreenDetail?, onSuccess:((_ response:APIResponseParam.HomeScreenDetail)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        self.homeScreenDetail = homeScreenDetail
        self.callBackSuccess = onSuccess
        self.callBackError = onError
    }
    
    override func main() {
        
        //Prepare URL String
        let urlParameter = String(format:APIParamConstants.kGetHomeScreenDetail)
        urlString = BaseApi().urlEncodedString(nil, restUrl: urlParameter, baseUrl: APIParamConstants.kSERVER_END_POINT_PRODUCT_API)
        
        // Header Parameters
        header = BaseApi().getDefaultHeaders() as? [String : String]
        
        //Set Method Type
        methodType = .POST
        
        //Conver data to JSON String
        let homeScreenDetailDataStr = homeScreenDetail?.toJSONString()
        
        //Set Post Data
        postData = homeScreenDetailDataStr!.data(using: String.Encoding.utf8)!
        
        super.main()
    }
    
    override func onSuccess(_ responseView:APIResponseParam.HomeScreenDetail?){
        
        AppConstant.kLogString(responseView ?? "")
        
        
        if responseView != nil {
            
            SwiftEventBus.unregister(self)
            SwiftEventBus.post(APIConfigConstants.kRequestOtpSuccess, sender: responseView)
        }else{
            SwiftEventBus.post(APIConfigConstants.kRequestOtpFailure)
        }
        
        /*if(responseView != nil && responseView?.message != nil) {
            
            // MARK:- conver key value pair
            var homeScreenModelArray:[HomeScreenModel] = []
            var isProduct = false
            var type = ""
            if(responseView?.homeScreenDataList != nil){
                for (key,value) in (responseView?.homeScreenDataList)!{
                        if value is NSArray {
                            var listValue:[APIResponseParam.HomeScreenDetail.HomeScreenDetailData] = []
                            for valueInfo in value{
                                let homeScreenDetailData = APIResponseParam.HomeScreenDetail.HomeScreenDetailData().getModelObjectFromServerResponse(jsonResponse: valueInfo as AnyObject)
                                print(valueInfo)
                                
                                if(homeScreenDetailData?.is_product != nil && homeScreenDetailData?.is_product?.caseInsensitiveCompare("1") == ComparisonResult.orderedSame){
                                    isProduct = true
                                } else {
                                    isProduct = false
                                }
                                
                                type = homeScreenDetailData?.type ?? ""
                                listValue.append(homeScreenDetailData!)
                            }
                            
                            let homeScreenModel = HomeScreenModel()
                            homeScreenModel.title = key.replacingOccurrences(of: "_", with: " ")
                            homeScreenModel.title = homeScreenModel.title?.capitalized(with: NSLocale.current)
                            homeScreenModel.isProduct = isProduct
                            homeScreenModel.productList = listValue
                            homeScreenModel.type = type
                            
                            homeScreenModelArray.append(homeScreenModel)
                        }
                    }

                // fetch category from list
                var homeScreenModelSortedArray:[HomeScreenModel] = []
                
                // add categories on top
                for homeScreenDataInfo in homeScreenModelArray {
                    if(!homeScreenDataInfo.isProduct!){
                        homeScreenModelSortedArray.append(homeScreenDataInfo)
                    }
                }
                
                // add product in list
                for homeScreenDataInfo in homeScreenModelArray {
                    if(homeScreenDataInfo.isProduct!){
                        homeScreenModelSortedArray.append(homeScreenDataInfo)
                    }
                }
                
                
                responseView?.homeScreenForScreen = homeScreenModelSortedArray
            }
            
            SwiftEventBus.unregister(self)
            SwiftEventBus.post(APIConfigConstants.kRequestOtpSuccess, sender: responseView)
        }else{
            SwiftEventBus.post(APIConfigConstants.kRequestOtpFailure)
        }*/
        
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
