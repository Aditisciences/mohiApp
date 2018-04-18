//
//  ChangePasswordVC.swift
//  Mohi
//
//  Created by Mac on 07/12/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

class ChangePasswordVC: BaseViewController {
    @IBOutlet weak var textFieldOldPassword: CustomTextField!
    @IBOutlet weak var textFieldNewPassword: CustomTextField!
    @IBOutlet weak var textFieldConfirmPassword: CustomTextField!
    @IBOutlet weak var buttonSave:UIButton!
    
    @IBOutlet weak var buttonOldShowHide:UIButton!
    @IBOutlet weak var buttonNewShowHide:UIButton!
    @IBOutlet weak var buttonReTypeShowHide:UIButton!
    
    fileprivate var isOldPasswordShow = false
    fileprivate var isNewPasswordShow = false
    fileprivate var isReTypePasswordShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        buttonOldShowHide.isHidden = true
//        buttonNewShowHide.isHidden = true
//        buttonReTypeShowHide.isHidden = true
//        textFieldOldPassword.isSecureTextEntry = true
//        textFieldNewPassword.isSecureTextEntry = true
//        textFieldConfirmPassword.isSecureTextEntry = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
}

// MARK:- Action method implementation
extension ChangePasswordVC{
    @IBAction func methodBackAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func methodSubmitAction(_ sender: Any) {
        var isFound = true
        
        textFieldOldPassword.resignFirstResponder()
        textFieldNewPassword.resignFirstResponder()
        textFieldConfirmPassword.resignFirstResponder()
        
        // checking condition
        var message = ""
        if (textFieldOldPassword.text?.isEmpty)! {
            message = BaseApp.sharedInstance.getMessageForCode("passwordOldEmpty", fileName: "Strings")!
//            BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: message, buttonTitle: "OK", controller: self)
            isFound = false
        } else if (textFieldNewPassword.text?.isEmpty)! {
            message = BaseApp.sharedInstance.getMessageForCode("passwordNewEmpty", fileName: "Strings")!
            isFound = false
        } else if((textFieldNewPassword.text?.length)! < AppConstant.LIMIT_LOWER_PASSWORD){
            message = BaseApp.sharedInstance.getMessageForCode("passwordLowerLimit", fileName: "Strings")!
            isFound = false
        } else if (textFieldConfirmPassword.text?.isEmpty)! {
            message = BaseApp.sharedInstance.getMessageForCode("confirmPassworEmpty", fileName: "Strings")!
            isFound = false
        }else if((textFieldConfirmPassword.text?.length)! < AppConstant.LIMIT_LOWER_PASSWORD){
            message = BaseApp.sharedInstance.getMessageForCode("confirmPasswordLowerLimit", fileName: "Strings")!
            isFound = false
        } else if (textFieldNewPassword.text?.compare(textFieldConfirmPassword.text!) != ComparisonResult.orderedSame) {
            message = BaseApp.sharedInstance.getMessageForCode("passwordNotMatch", fileName: "Strings")!
            isFound = false
        }
        
        if !isFound {
            BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: message, buttonTitle: "OK", controller: self)
        }
        
        if isFound {
            serverAPI()
        }
    }
    
    @IBAction func methodOdShowAction(_ sender: Any) {
        textFieldOldPassword.isSecureTextEntry = isOldPasswordShow
        isOldPasswordShow = !isOldPasswordShow
        buttonOldShowHide.isSelected = isOldPasswordShow
    }
    
    @IBAction func methodNewShowAction(_ sender: Any) {
        textFieldNewPassword.isSecureTextEntry = isNewPasswordShow
        isNewPasswordShow = !isNewPasswordShow
        buttonNewShowHide.isSelected = isNewPasswordShow
    }
    
    @IBAction func methodReTypeShowAction(_ sender: Any) {
        textFieldConfirmPassword.isSecureTextEntry = isReTypePasswordShow
        isReTypePasswordShow = !isReTypePasswordShow
        buttonReTypeShowHide.isSelected = isReTypePasswordShow
    }
}

extension ChangePasswordVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        var limitLength = 0
        let numCheckStatus:Bool = false
        var lenCheckStatus:Bool = false
        let isNumCheckReq = false
        var isLenCheckReq = false
        
        if textField == textFieldOldPassword || textField == textFieldNewPassword || textField == textFieldConfirmPassword {
            limitLength = AppConstant.LIMIT_UPPER_PASSWORD
            isLenCheckReq = true
        }
        
        if (isBackSpace == -92) {
            return true
        }
        
        let newLength = text.characters.count + string.characters.count - range.length
        if limitLength > 0 && newLength > limitLength{
            return false
        }
        
        lenCheckStatus = true
        
        if(isNumCheckReq == true && isLenCheckReq == true){
            return numCheckStatus && lenCheckStatus
        }else if(isNumCheckReq == true){
            return numCheckStatus
        }else if(lenCheckStatus == true){
            return lenCheckStatus
        }
        
        return true
    }
}

extension ChangePasswordVC{
    fileprivate func prepareScreenInfo(){
        textFieldOldPassword.text = ""
        textFieldNewPassword.text = ""
        textFieldConfirmPassword.text = ""
    }
}

extension ChangePasswordVC{
    func serverAPI(){
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            let changePasswordRequestParam = APIRequestParam.ChangePassword(user_id: ApplicationPreference.getUserId(), token: ApplicationPreference.getAppToken(), new_password: textFieldNewPassword.text, old_password: textFieldOldPassword.text)
            
            let uploadProfileRequest = ChangePasswordRequest(changePassword: changePasswordRequestParam, onSuccess: {
                responseView in
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Success", message: responseView.message!, buttonTitle: nil, controller: nil)
                    // Update change password info on screen
                    self.prepareScreenInfo()
                }
            }, onError: {
                error in
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: self)
                }
            })
            BaseApp.sharedInstance.jobManager?.addOperation(uploadProfileRequest)
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
}
