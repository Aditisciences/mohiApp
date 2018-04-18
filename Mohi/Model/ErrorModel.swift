//
//  ErrorModel.swift
//  MyPanditJi
//

import Foundation

class ErrorModel {
    
    static var genericErrorModel:ErrorModel?
    
    var errorCode: String?
    var errorMsg: String?
    
    var data: JSONSerialization? //Optional
    
    init(errorCode:String, errorMsg:String) {
        self.errorCode = errorCode
        self.errorMsg = errorMsg
    }
    
    init(errorCode:String, errorMsg:String, data: JSONSerialization) {
        self.errorCode = errorCode
        self.errorMsg = errorMsg
        self.data = data
    }
    
    //@Override
    func toString() -> String{
        return "Error {code='\(String(describing: errorCode))', msg='\(String(describing: errorMsg))'}";
    }
    
    class func defaultUnknownError() -> ErrorModel {
        if(ErrorModel.genericErrorModel == nil) {
            ErrorModel.genericErrorModel = ErrorModel(errorCode: AppConstant.DEFAULT_REST_ERROR_CODE, errorMsg: AppConstant.DEFAULT_REST_ERROR_MESSAGE)
        }
        return ErrorModel.genericErrorModel!
    }
}
