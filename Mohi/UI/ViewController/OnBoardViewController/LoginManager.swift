//
//  LoginManager.swift
//  Mohi
//
//  Created by Apple on 21/04/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import Foundation
class LoginManager {
    static let shared = LoginManager()
    func serverAPI(email: String, password: String,callback: @escaping ( _ _result:[String:Any]?,  _ _error:String?)->()) {
        
        if(BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let loginRequestParam = APIRequestParam.Login(phoneNumber: email, password: password) // Change pwd
            let login = LoginRequest(loginData: loginRequestParam, onSuccess: {
                response in
                print(response.toJSON())
                callback(response.toJSON(),nil)
             }, onError: {
                error in
                print(error.toString())
                
            callback(nil,error.errorMsg!)
            })
            BaseApp.sharedInstance.jobManager?.addOperation(login)
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
}
