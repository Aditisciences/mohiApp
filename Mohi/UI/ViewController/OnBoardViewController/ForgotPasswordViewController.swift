//
//  ForgotPasswordViewController.swift
//  Mohi
//
//  Created by Consagous on 18/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var txtForForgotEmail: UITextField!
    @IBOutlet weak var btnForForgot: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        btnForForgot.layer.cornerRadius = 10.0
//        btnForForgot.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        if AppConstant.DeviceType.IS_IPHONE_X{
            self.constraintNavigationHeight?.constant = AppConstant.IPHONE_X_DEFAULT_STATUS_BAR_HEIGHT
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK:- Action Method
extension ForgotPasswordViewController{
    
    @IBAction func actionONback(_ sender: Any){
        self.view.endEditing(true)
      _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func methodForgotPasswordAction(_ sender: Any) {
        self.view.endEditing(true)
        if (txtForForgotEmail.text?.isEmpty)! {
            let message = BaseApp.sharedInstance.getMessageForCode("MobileOrEmailEmpty", fileName: "Strings")
            //            viewBgEmail.layer.borderWidth = 1
            BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: message!, buttonTitle: "OK", controller: self)
        }  else {
            self.serverAPIForgotPassword(text: txtForForgotEmail.text!)
        }
    }
}

// MARK:- API calling
extension ForgotPasswordViewController{
    func serverAPIForgotPassword(text:String){
        
        if(BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let forgotPasswordRequestParam = APIRequestParam.ForgotPassword(email: txtForForgotEmail.text)
            let forgotPasswordRequest = ForgotPasswordRequest(forgotPasswordData: forgotPasswordRequestParam, onSuccess: {
                response in
                
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "", message: response.message!, buttonTitle: "OK", controller: self)
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
            
            BaseApp.sharedInstance.jobManager?.addOperation(forgotPasswordRequest)
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
    
}
