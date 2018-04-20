//
//  SignUpViewController.swift
//  Mohi
//
//  Created by Consagous on 18/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
//import ActiveLabel

class SignUpViewController: BaseViewController {

     //@IBOutlet weak var lblForTerms:UILabel!
    @IBOutlet weak var lblForTerms:ActiveLabel!
    @IBOutlet weak var btnForSignUp: UIButton!
    @IBOutlet weak var textFieldName:UITextField!
    @IBOutlet weak var textFieldLastName:UITextField!

    @IBOutlet weak var textFieldEmailId:UITextField!
    @IBOutlet weak var textFieldPassword:UITextField!
    @IBOutlet weak var textFieldConfirmPassword:UITextField!
    @IBOutlet weak var textFieldMobileNumber:UITextField!
    @IBOutlet weak var textFieldCountryCode:UITextField!
    
    var webViewController:WebViewController?
    
//    @IBOutlet weak var lblForTerms = ActiveLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        btnForSignUp.layer.cornerRadius = 10.0
//        btnForSignUp.layer.masksToBounds = true
        
        let customType = ActiveType.custom(pattern: "\\sTerms and conditions\\b") //Regex that looks for "with"
       
        /*
        lblForTerms.enabledTypes = [.mention, .hashtag, .url, customType]
        lblForTerms.customColor[customType] = UIColor.orange
        
        lblForTerms.text = BaseApp.sharedInstance.getMessageForCode("term&Condition", fileName: "Strings")
        
        lblForTerms.handleCustomTap(for: customType) { element in
            print("Custom type tapped: \(element)")
            self.webViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.WebViewStoryboard, viewControllerName: WebViewController.nameOfClass)
            self.webViewController?.screenName = BaseApp.sharedInstance.getMessageForCode("titleTermsCondition", fileName: "Strings")!
            //self.navigationController?.pushViewController(self.webViewController!, animated: true)
        }
        */
        let fontSize:CGFloat = 14
        textFieldName.attributedPlaceholder = BaseApp.sharedInstance.getAttributeTextWithFont(text: BaseApp.sharedInstance.getMessageForCode("First name", fileName: "Strings")!, font: FontsConfig.FontHelper.defaultFontGothiWithSizeR(fontSize))
        textFieldLastName.attributedPlaceholder = BaseApp.sharedInstance.getAttributeTextWithFont(text: BaseApp.sharedInstance.getMessageForCode("Last name", fileName: "Strings")!, font: FontsConfig.FontHelper.defaultFontGothiWithSizeR(fontSize))
        
        textFieldEmailId.attributedPlaceholder = BaseApp.sharedInstance.getAttributeTextWithFont(text: BaseApp.sharedInstance.getMessageForCode("Email", fileName: "Strings")!, font: FontsConfig.FontHelper.defaultFontGothiWithSizeR(fontSize))
        textFieldPassword.attributedPlaceholder = BaseApp.sharedInstance.getAttributeTextWithFont(text: BaseApp.sharedInstance.getMessageForCode("Password", fileName: "Strings")!, font: FontsConfig.FontHelper.defaultFontGothiWithSizeR(fontSize))
        textFieldConfirmPassword.attributedPlaceholder = BaseApp.sharedInstance.getAttributeTextWithFont(text: BaseApp.sharedInstance.getMessageForCode("Confirm Password", fileName: "Strings")!, font: FontsConfig.FontHelper.defaultFontGothiWithSizeR(fontSize))
        textFieldMobileNumber.attributedPlaceholder = BaseApp.sharedInstance.getAttributeTextWithFont(text: BaseApp.sharedInstance.getMessageForCode("Mobile Number", fileName: "Strings")!, font: FontsConfig.FontHelper.defaultFontGothiWithSizeR(fontSize))
        textFieldCountryCode.text = BaseApp.sharedInstance.getDeviceDialCode()
        //textFieldMobileNumber.attributedPlaceholder = BaseApp.sharedInstance.getAttributeTextWithFont(text: BaseApp.sharedInstance.getMessageForCode("passwordPlaceHolder", fileName: "Strings")!, font: FontsConfig.FontHelper.defaultFontGothiWithSizeR(16))
        
        // Do any additional setup after loading the view.
        if AppConstant.DeviceType.IS_IPHONE_X{
            self.constraintNavigationHeight?.constant = AppConstant.IPHONE_X_DEFAULT_STATUS_BAR_HEIGHT
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webViewController = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK:- Action method implementation
extension SignUpViewController{
    @IBAction func methodRegisterAction(_ sender: Any) {
        
        if(isFormValid()){
            self.serverAPI()
        }
        
        //        // For tesating purpose
        //        ApplicationPreference.saveLoginInfo(loginInfo: "Test info")
        //        BaseApp.sharedInstance.openDashboardViewController()
        
    }
    
    @IBAction func methodBackAction(_ sender: Any) {
       _ = self.navigationController?.popViewController(animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate{
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if(textField == textFieldCountryCode){
            var limitLength = AppConstant.LIMIT_COUNTRY_CODE
            var newLength = text.characters.count + string.characters.count - range.length
            if (isBackSpace == -92) {
                newLength = (textField.text?.characters.count)!
            }
            
            if newLength < 2 {
                 return false
            } else if newLength > limitLength {
                return false
            }
            return true
        }
        
        var limitLength = 0
        var numCheckStatus:Bool = false
        var lenCheckStatus:Bool = false
        var isNumCheckReq = false
        var isLenCheckReq = false
        
        if textField == textFieldName || textField == textFieldLastName {
            //limitLength = AppConstant.LIMIT_NAME
            //isLenCheckReq = true
        } else if textField == textFieldEmailId {
            limitLength = AppConstant.LIMIT_EMAIL
            isLenCheckReq = true
        } else if textField == textFieldPassword || textField == textFieldConfirmPassword{
            limitLength = AppConstant.LIMIT_UPPER_PASSWORD
            isLenCheckReq = true
        } else if textField == textFieldMobileNumber{
            limitLength = AppConstant.LIMIT_PHONE_NUMBER
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

// MARK:- filePrivate method implementation
extension SignUpViewController{

    fileprivate func isFormValid() -> Bool{
        
        var isFound = true
        var message = ""
        
        // checking condition
        if (textFieldName.text?.isEmpty)! {
            message = BaseApp.sharedInstance.getMessageForCode("firstNameEmpty", fileName: "Strings")!
            isFound = false
        }
        else if (textFieldLastName.text?.isEmpty)! {
            message = BaseApp.sharedInstance.getMessageForCode("LastNameEmpty", fileName: "Strings")!
            isFound = false
        }
        else if (textFieldEmailId.text?.isEmpty)! || !(textFieldEmailId.text?.isEmail())! {
            message = BaseApp.sharedInstance.getMessageForCode("emailEmpty", fileName: "Strings")!
            isFound = false
        } else if (textFieldPassword.text?.isEmpty)! {
            message = BaseApp.sharedInstance.getMessageForCode("passwordEmpty", fileName: "Strings")!
            isFound = false
        } else if((textFieldPassword.text?.length)! < AppConstant.LIMIT_LOWER_PASSWORD){
            message = BaseApp.sharedInstance.getMessageForCode("passwordLowerLimit", fileName: "Strings")!
            isFound = false
        } else if (textFieldConfirmPassword.text?.isEmpty)! {
            message = BaseApp.sharedInstance.getMessageForCode("confirmPassworEmpty", fileName: "Strings")!
            isFound = false
        } else if (textFieldPassword.text?.compare(textFieldConfirmPassword.text!) != ComparisonResult.orderedSame) {
            message = BaseApp.sharedInstance.getMessageForCode("passwordNotMatch", fileName: "Strings")!
            isFound = false
        } else if((textFieldCountryCode.text?.length)! < AppConstant.LIMIT_COUNTRY_CODE_LOWER_LIMIT){
            message = BaseApp.sharedInstance.getMessageForCode("emptyCountryCode", fileName: "Strings")!
            isFound = false
        } else if(textFieldMobileNumber.text?.isEmpty)! {
            message = BaseApp.sharedInstance.getMessageForCode("emptyPhoneNumber", fileName: "Strings")!
            isFound = false
        }
        
        if !isFound {
            BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: message, buttonTitle: "OK", controller: self)
        }
        
        return isFound
    }
}

extension SignUpViewController{
    func serverAPI(){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
//            let registrationRequestParam = APIRequestParam.Registration(name: textFieldName.text, mobile_number: "\(textFieldCountryCode.text!)\(textFieldMobileNumber.text!)", email: textFieldEmailId.text, password: textFieldPassword.text, deviceToken: "SDFSDF45353")
            
            
            let registrationRequestParam = APIRequestParam.Registration(firstname: textFieldName.text, lastname: textFieldLastName.text, email: textFieldEmailId.text, password: textFieldPassword.text, cntry_code: textFieldCountryCode.text, mob_number: textFieldMobileNumber.text)
            
            let registrationRequest = RegistrationRequest(registrationData: registrationRequestParam, onSuccess: {
                response in
                
                print(response.toJSON())
                
                if response.toJSON()["status"] as! String == "error"{
                    
                    let message = response.toJSON()["msg"] as! String
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error" , message: message, buttonTitle: "OK", controller: self)
                    BaseApp.sharedInstance.hideProgressHudView()
                    return
                }
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    //BaseApp.sharedInstance.openDashboardViewControllerOnSkip()
                    
                    // MARK:- Manage screen flow functionality as per skip flow
                    switch(BaseApp.sharedInstance.loginCallingScr){
                    case .Menu:
                        self.navigationController?.popToRootViewController(animated: true)
                        break
                    case .MyAccount:
                        self.navigationController?.popToRootViewController(animated: true)
                        break
                    case .Cart:
                        self.navigationController?.popToRootViewController(animated: true)
                        break
                    case .ProductDetail:
                        for controller in (BaseApp.appDelegate.navigationController?.viewControllers)! {
                            if (controller.nameOfClass.compare((ProductDetailsVC.nameOfClass)) == ComparisonResult.orderedSame ){
                                BaseApp.appDelegate.navigationController?.popToViewController(controller, animated: true)
                                break
                            }
                        }
                        break
                    }
                }
                
            }, onError: {
                error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: self)
                }
            })
            //
            BaseApp.sharedInstance.jobManager?.addOperation(registrationRequest)
            
            //        // For tesating purpose
            //        ApplicationPreference.saveLoginInfo(loginInfo: "Test info")
            //        BaseApp.sharedInstance.openDashboardViewController()
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
}
