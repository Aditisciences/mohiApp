//
//  LoginViewController.swift
//  Mohi
//
//  Created by Consagous on 18/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit


class LoginViewController: BaseViewController {
    
    @IBOutlet weak var btnForLogin: UIButton!
    @IBOutlet weak var btnForSignUp: UIButton!
    @IBOutlet weak var txtForLogin: UITextField!
    @IBOutlet weak var txtForPassword: UITextField!
    //@IBOutlet weak var constraintLoginBtnHeight:NSLayoutConstraint?
    
    var isDisplaySignUp = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let fontSize:CGFloat = 14
        txtForLogin.attributedPlaceholder = BaseApp.sharedInstance.getAttributeTextWithFont(text: BaseApp.sharedInstance.getMessageForCode("emailPlaceHolder", fileName: "Strings")!, font: FontsConfig.FontHelper.defaultFontGothiWithSizeR(fontSize))
        txtForPassword.attributedPlaceholder = BaseApp.sharedInstance.getAttributeTextWithFont(text: BaseApp.sharedInstance.getMessageForCode("passwordPlaceHolder", fileName: "Strings")!, font: FontsConfig.FontHelper.defaultFontGothiWithSizeR(fontSize))
        
        if(!isDisplaySignUp){
            btnForSignUp.isHidden = true
            //constraintLoginBtnHeight?.constant = 40
        }
        
        // Do any additional setup after loading the view.
        if AppConstant.DeviceType.IS_IPHONE_X{
            self.constraintNavigationHeight?.constant = AppConstant.IPHONE_X_DEFAULT_STATUS_BAR_HEIGHT
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
// MARK:- Action Method
extension LoginViewController{
    
    @IBAction func actionOnLoginButton(_ sender: Any){
        
        self.view.endEditing(true)
        
        if (txtForLogin.text?.isEmpty)! || !(txtForLogin.text?.isEmail())! {
            let message = BaseApp.sharedInstance.getMessageForCode("emailEmpty", fileName: "Strings")
            BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: message!, buttonTitle: "OK", controller: self)
        } else if (txtForPassword.text?.isEmpty)! {
            let message = BaseApp.sharedInstance.getMessageForCode("passwordEmpty", fileName: "Strings")
            BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: message!, buttonTitle: "OK", controller: self)
        } else {
            self.serverAPI()
        }
    }
    
    @IBAction func methodLoginSignup(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func methodForgotPasswordAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func methodLoginSkipAction(_ sender: Any) {
        self.view.endEditing(true)
        BaseApp.sharedInstance.openDashboardViewControllerOnSkip()
    }
    
    @IBAction func methodBack(_ sender: Any) {
        //self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.popViewController(animated: true )
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        var limitLength = 0
        var numCheckStatus:Bool = false
        var lenCheckStatus:Bool = false
        var isNumCheckReq = false
        var isLenCheckReq = false
        
        if textField == txtForLogin {
            limitLength = AppConstant.LIMIT_EMAIL
            isLenCheckReq = true
        } else if textField == txtForPassword {
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

// MARK:- API calling
extension LoginViewController{
    func serverAPI(){
        
        if(BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let loginRequestParam = APIRequestParam.Login(phoneNumber: txtForLogin.text, password: txtForPassword.text) // Change pwd
            let login = LoginRequest(loginData: loginRequestParam, onSuccess: {
                response in
                
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    
                    // MARK:- Change functionality as per skip flow
//                    BaseApp.sharedInstance.openDashboardViewControllerOnSkip()
                    
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
                    
                    // Update cart count
                    ((UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? TabBarViewController)?.updateViewCartCount()
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
            BaseApp.sharedInstance.jobManager?.addOperation(login)
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
}
