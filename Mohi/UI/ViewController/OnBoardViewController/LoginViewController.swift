//
//  LoginViewController.swift
//  Mohi
//
//  Created by Consagous on 18/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class LoginViewController: BaseViewController {
    
    
    @IBOutlet weak var phoneNoTextField: UITextField!
    @IBOutlet weak var btnForLogin: UIButton!
    @IBOutlet weak var btnForSignUp: UIButton!
    @IBOutlet weak var txtForLogin: UITextField!
    @IBOutlet weak var txtForPassword: UITextField!
    
    @IBOutlet weak var countryCodeTextField: UITextField!
    //@IBOutlet weak var constraintLoginBtnHeight:NSLayoutConstraint?
    
    var isDisplaySignUp = true
    var gradePicker: UIPickerView!
    let gradePickerValues = ["+91", "+971", "+966","+974","+968","+973","+965","+44","+1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradePicker = UIPickerView()
        self.gradePicker = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0
        ))
        
        gradePicker.dataSource = self
        gradePicker.delegate = self
        countryCodeTextField.inputView = gradePicker
        // Do any additional setup after loading the view.
        let fontSize:CGFloat = 14
        txtForLogin.attributedPlaceholder = BaseApp.sharedInstance.getAttributeTextWithFont(text: BaseApp.sharedInstance.getMessageForCode("emailPlaceHolder", fileName: "Strings")!, font: FontsConfig.FontHelper.defaultFontGothiWithSizeR(fontSize))
        phoneNoTextField.attributedPlaceholder = BaseApp.sharedInstance.getAttributeTextWithFont(text: BaseApp.sharedInstance.getMessageForCode("phonePlaceHolder", fileName: "Strings")!, font: FontsConfig.FontHelper.defaultFontGothiWithSizeR(fontSize))
        txtForPassword.attributedPlaceholder = BaseApp.sharedInstance.getAttributeTextWithFont(text: BaseApp.sharedInstance.getMessageForCode("passwordPlaceHolder", fileName: "Strings")!, font: FontsConfig.FontHelper.defaultFontGothiWithSizeR(fontSize))
        if(!isDisplaySignUp){
            btnForSignUp.isHidden = true
            //constraintLoginBtnHeight?.constant = 40
        }
    
        if AppConstant.DeviceType.IS_IPHONE_X{
            self.constraintNavigationHeight?.constant = AppConstant.IPHONE_X_DEFAULT_STATUS_BAR_HEIGHT
        }
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
    // MARK:- IBActions
    @IBAction func countryCodeSelection(_ sender: Any) {
        countryCodeTextField.becomeFirstResponder()
       
        countryCodeTextField.text = gradePickerValues[0]
    }
    @IBAction func loginByOtp(_ sender: Any) {
        let alert = UIAlertController(title: "Login By Otp", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter email id"
            textField.text = ""
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter otp"
            textField.isSecureTextEntry = true
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let emailTextField = alert?.textFields![0]
            let otpTextField = alert?.textFields![1]
            self.validateLoginFields(emailTextView: emailTextField! ,passwordOtpTextView: otpTextField!)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func actionOnLoginButton(_ sender: Any){
        self.view.endEditing(true)
        if (txtForLogin.text?.isEmpty)! == false {
            validateLoginFields(emailTextView: txtForLogin, passwordOtpTextView: txtForPassword)
        } else {
            validateLoginFields(emailTextView: phoneNoTextField , passwordOtpTextView: txtForPassword)
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
    
    // MARK:- Custom Methods
    func validateLoginFields(emailTextView: UITextField?, passwordOtpTextView: UITextField?) {
        if (emailTextView?.text?.isEmpty)! || !(emailTextView?.text?.isEmail())! {
            let message = BaseApp.sharedInstance.getMessageForCode("emailEmpty", fileName: "Strings")
            BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: message!, buttonTitle: "OK", controller: self)
        } else if (passwordOtpTextView?.text?.isEmpty)! {
            let message = BaseApp.sharedInstance.getMessageForCode("passwordEmpty", fileName: "Strings")
            BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: message!, buttonTitle: "OK", controller: self)
        } else {
            
            LoginManager.shared.serverAPI(email: (emailTextView?.text!)!,password: (passwordOtpTextView?.text!)!) {(result,error) in
                
                if result != nil {
                    if result!["status"] as! String == "error"{
                        let message =  result!["msg"] as! String
                        BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error" , message: message, buttonTitle: "OK", controller: self)
                        BaseApp.sharedInstance.hideProgressHudView()
                        return
                    } else {
                        NotificationBannerQueue.default.removeAll()
                    }
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
                    
                } else {
                    OperationQueue.main.addOperation() {
                        // when done, update your UI and/or model on the main queue
                        BaseApp.sharedInstance.hideProgressHudView()
                        BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error!, buttonTitle: "OK", controller: self)
                    }
                }
            }
            
        }
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
        
        let newLength = text.count + string.count - range.length
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

extension LoginViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gradePickerValues.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gradePickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryCodeTextField.text = gradePickerValues[row]
        self.view.endEditing(true)
    }
}
