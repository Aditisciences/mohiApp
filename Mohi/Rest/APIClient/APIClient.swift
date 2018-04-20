//
//  APIClient.swift
//  MyPanditJi
//
//

import Foundation

//MARK:- Common Server API call
class APIClient {
    static let sharedInstance = APIClient()
    
    func serverAPIAddToWishList(productId:String, onSuccess:((_ response:APIResponseParam.BaseResponse)->Void)? = nil, onError:((_ response:ErrorModel)->Void)? = nil){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let addToWishRequestParam = APIRequestParam.AddToWish(user_id:ApplicationPreference.getUserId(), token:ApplicationPreference.getAppToken(),product_id:productId)
            let addToWishRequest =  AddToWishRequest(productData: addToWishRequestParam, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Success", message: response.message!, buttonTitle: nil, controller: nil)
                    
                    if(onSuccess != nil){
                        onSuccess!(response)
                    }
                }
                
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: nil, controller: nil)
                    
                    if(onError != nil){
                        onError!(error)
                    }
                }
            })
            BaseApp.sharedInstance.jobManager?.addOperation(addToWishRequest)
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
    
    func serverAPIRemoveToWishList(productId:String, onSuccess:((_ response:APIResponseParam.BaseResponse)->Void)? = nil, onError:((_ response:ErrorModel)->Void)? = nil){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let removeFromWishRequestParam = APIRequestParam.RemoveFromWish(user_id:ApplicationPreference.getUserId(), token:ApplicationPreference.getAppToken(),product_id:productId)
            let removeFromWishRequest =  RemoveFromWishRequest(productData: removeFromWishRequestParam, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Success", message: response.message!, buttonTitle: nil, controller: nil)
                    
                    if(onSuccess != nil){
                        onSuccess!(response)
                    }
                }
                
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: nil, controller: nil)
                }
            })
            BaseApp.sharedInstance.jobManager?.addOperation(removeFromWishRequest)
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
    
    
    func serverAPIAddToCart(productId:String, displayNotification:Bool = true, buyNowAction:Bool = false, onSuccess:((_ response:APIResponseParam.AddToCart)->Void)? = nil, onError:((_ response:ErrorModel)->Void)? = nil){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let status = buyNowAction == true ? "1" : "0"
            
            let addToCartRequestParam = APIRequestParam.AddToCart(user_id:ApplicationPreference.getUserId(), token:ApplicationPreference.getAppToken(),product_id:productId,qty:"1",quote_id:"", buy_status:status)
            
            let addToCartRequest =  AddToCartRequest(productData: addToCartRequestParam, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    BaseApp.sharedInstance.hideProgressHudView()
                    if(displayNotification){
                        BaseApp.sharedInstance.showAlertViewControllerWith(title: "Success", message: response.message!, buttonTitle: nil, controller: nil)
                    }
                    
                    ((UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? TabBarViewController)?.updateViewCartCount()

                    
                    if(onSuccess != nil){
                        onSuccess!(response)
                    }
                }
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    if(displayNotification){
                        BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: nil, controller: nil)
                    }
                }
            })
            BaseApp.sharedInstance.jobManager?.addOperation(addToCartRequest)
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
    
    
    func serverAPIRemoveToAddToCart(productId:String, quoteId:String, onSuccess:((_ response:APIResponseParam.BaseResponse)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let removeFromAddToCartRequestParam = APIRequestParam.RemoveFromAddToCart(user_id:ApplicationPreference.getUserId(), token:ApplicationPreference.getAppToken(),product_id:productId,quote_id: quoteId)
            let removeFromAddToCartRequest =  RemoveFromAddToCartRequest(productData: removeFromAddToCartRequestParam, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Success", message: response.message!, buttonTitle: nil, controller: nil)
                    
                    ((UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? TabBarViewController)?.updateViewCartCount()

                    if(onSuccess != nil){
                        onSuccess!(response)
                    }
                }
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: nil, controller: nil)
                }
            })
            BaseApp.sharedInstance.jobManager?.addOperation(removeFromAddToCartRequest)
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
    
    func serverAPIRemoveAddress(addressId:String, onSuccess:((_ response:APIResponseParam.BaseResponse)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
//            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let removeShippingAddressParma = APIRequestParam.DeleteShippingAddress(user_id:ApplicationPreference.getUserId(), token:ApplicationPreference.getAppToken(), address_id: addressId)
            let removeFromAddToCartRequest =  DeleteShippingAddressRequest(deleteShippingAddress: removeShippingAddressParma, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
//                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Success", message: response.message!, buttonTitle: nil, controller: nil)
                    
                    if(onSuccess != nil){
                        onSuccess!(response)
                    }
                }
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: nil, controller: nil)
                }
            })
            BaseApp.sharedInstance.jobManager?.addOperation(removeFromAddToCartRequest)
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
    
    func serverAPIGetViewCartCount(onSuccess:((_ response:APIResponseParam.ViewCartCount)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            //BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let viewCartCountParma = APIRequestParam.ViewCartCount(user_id:ApplicationPreference.getUserId(), token:ApplicationPreference.getAppToken())
            let removeFromAddToCartRequest =  ViewCartCountRequest(viewCartCount: viewCartCountParma, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    //BaseApp.sharedInstance.hideProgressHudView()
                    
                    if(onSuccess != nil){
                        onSuccess!(response)
                    }
                }
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    //BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: nil, controller: nil)
                }
            })
            BaseApp.sharedInstance.jobManager?.addOperation(removeFromAddToCartRequest)
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
    
    func serverAPICancelOrder(orderId:String?, onSuccess:((_ response:APIResponseParam.BaseResponse)->Void)?, onError:((_ response:ErrorModel)->Void)?){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            //BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let cancelOrder = APIRequestParam.CancelOrder(user_id: ApplicationPreference.getUserId(), token:ApplicationPreference.getAppToken(), order_id: orderId)
            let cancelOrderRequest =  CancelOrderRequest(cancelOrderData: cancelOrder, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    //BaseApp.sharedInstance.hideProgressHudView()
                    
                    if(onSuccess != nil){
                        onSuccess!(response)
                    }
                }
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    //BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: nil, controller: nil)
                }
            })
            BaseApp.sharedInstance.jobManager?.addOperation(cancelOrderRequest)
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
}
