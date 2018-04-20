//
//  AddNewAddressVC.swift
//  Mohi
//
//  Created by RajeshYadav on 29/11/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

class AddNewAddressVC: BaseViewController {
    
    @IBOutlet weak var labelScreenTitle: UILabel!
    
    @IBOutlet weak var textFieldFullName: UITextField!
    @IBOutlet weak var textFieldMobileNumber: CustomTextField!
    @IBOutlet weak var textFieldPincode: CustomTextField!
    @IBOutlet weak var textFieldFlatNumber: UITextField!
    @IBOutlet weak var textFieldStreetAddress: UITextField!
    @IBOutlet weak var textFieldLandmark: UITextField!
    @IBOutlet weak var textFieldCity: CustomTextField!
    @IBOutlet weak var textFieldState: CustomTextField!
    @IBOutlet weak var textFieldCountry: UITextField!
    
    @IBOutlet weak var newAddressStatusView: UIView!
    @IBOutlet weak var newAddressNavigationView: UIView!

    
    var shippingAddressData:APIResponseParam.ShippingAddress.ShippingAddressData?
    var screenTitle = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if screenTitle.length > 0{
            labelScreenTitle.text = screenTitle
        }
        
        if shippingAddressData != nil{
            textFieldFullName.text = shippingAddressData?.name ?? ""
            textFieldMobileNumber.text = shippingAddressData?.mobile ?? ""
            textFieldPincode.text = shippingAddressData?.postcode ?? ""
            textFieldFlatNumber.text = shippingAddressData?.flat_no ?? ""
            textFieldStreetAddress.text = shippingAddressData?.street ?? ""
            textFieldLandmark.text = shippingAddressData?.landmark ?? ""
            textFieldCity.text = shippingAddressData?.city ?? ""
            textFieldState.text = shippingAddressData?.state ?? ""
            textFieldCountry.text = shippingAddressData?.country ?? ""
        }
        
        self.newAddressStatusView.isHidden = true
       // self.newAddressNavigationView.isHidden = true
    }
}

//MARK:- Action method implementation
extension AddNewAddressVC{
    @IBAction func backButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonAction(_ sender:Any){
        if(isFormValid()){
            self.serverAPI()
        }
    }
}


// MARK:- filePrivate method implementation
extension AddNewAddressVC{
    
    fileprivate func isFormValid() -> Bool{
        
        var isFound = true
        //var message = ""
        
        // checking condition
        if (textFieldFullName.text?.isEmpty)! {
//            message = BaseApp.sharedInstance.getMessageForCode("firstNameEmpty", fileName: "Strings")!
            isFound = false
        }else if (textFieldMobileNumber.text?.isEmpty)! {
//            message = BaseApp.sharedInstance.getMessageForCode("emailEmpty", fileName: "Strings")!
            isFound = false
        } else if (textFieldPincode.text?.isEmpty)! {
//            message = BaseApp.sharedInstance.getMessageForCode("passwordEmpty", fileName: "Strings")!
            isFound = false
        } else if (textFieldFlatNumber.text?.isEmpty)!{
//            message = BaseApp.sharedInstance.getMessageForCode("passwordLowerLimit", fileName: "Strings")!
            isFound = false
        } else if (textFieldStreetAddress.text?.isEmpty)! {
//            message = BaseApp.sharedInstance.getMessageForCode("confirmPassworEmpty", fileName: "Strings")!
            isFound = false
        }else if(textFieldCity.text?.isEmpty)!{
            //            message = BaseApp.sharedInstance.getMessageForCode("confirmPasswordLowerLimit", fileName: "Strings")!
            isFound = false
        } else if (textFieldState.text?.isEmpty)! {
            //            message = BaseApp.sharedInstance.getMessageForCode("passwordNotMatch", fileName: "Strings")!
            isFound = false
        } else if (textFieldCountry.text?.isEmpty)! {
            //            message = BaseApp.sharedInstance.getMessageForCode("passwordNotMatch", fileName: "Strings")!
            isFound = false
        }
        
        if !isFound {
            BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: BaseApp.sharedInstance.getMessageForCode("allFieldError", fileName: "Strings")!, buttonTitle: "OK", controller: self)
        }
        
        return isFound
    }
    
}

extension AddNewAddressVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
       
        
        var limitLength = 0
        var numCheckStatus:Bool = false
        var lenCheckStatus:Bool = false
        var isNumCheckReq = false
        var isLenCheckReq = false
        
        if textField == textFieldFullName {
            limitLength = AppConstant.LIMIT_NAME
            isLenCheckReq = true
        } else if textField == textFieldStreetAddress || textField == textFieldLandmark || textField == textFieldCity || textField == textFieldCountry || textField == textFieldState {
            limitLength = AppConstant.LIMIT_ADDRESS
            isLenCheckReq = true
        } else if textField == textFieldMobileNumber {
            limitLength = AppConstant.LIMIT_PHONE_NUMBER
            isLenCheckReq = true
        } else if textField == textFieldPincode || textField == textFieldFlatNumber{
            limitLength = AppConstant.LIMIT_POSTCODE
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


extension AddNewAddressVC{
    func serverAPI(){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            if(shippingAddressData == nil){
                BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
                let addShippingAddress = APIRequestParam.AddShippingAddress(user_id: ApplicationPreference.getUserId(), token: ApplicationPreference.getAppToken(), name: textFieldFullName.text!, country: textFieldCountry.text!, city: textFieldCity.text!, postcode: textFieldPincode.text!, mobile: textFieldMobileNumber.text!, state: textFieldState.text!, street: textFieldStreetAddress.text!, landmark:textFieldLandmark.text ?? "", flat_no:textFieldFlatNumber.text!, address_id:"")
                let addShippingAddressRequest = AddShippingAddressRequest( addShippingAddress:addShippingAddress, onSuccess: {
                    response in
                    
                    print(response.toJSON())
                    
                    OperationQueue.main.addOperation() {
                        // when done, update your UI and/or model on the main queue
                        BaseApp.sharedInstance.hideProgressHudView()
                        BaseApp.sharedInstance.showAlertViewControllerWith(title: "Success", message: response.message!, buttonTitle: nil, controller: nil)
                        
                        // Save Last new address is default of screen in Request
                        // Check and save address id; if address is empty
                        
                        self.navigationController?.popViewController(animated: true)
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
                BaseApp.sharedInstance.jobManager?.addOperation(addShippingAddressRequest)
            } else { // modify  address
                BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
                
                let addShippingAddress = APIRequestParam.AddShippingAddress(user_id: ApplicationPreference.getUserId(), token: ApplicationPreference.getAppToken(), name: textFieldFullName.text!, country: textFieldCountry.text!, city: textFieldCity.text!, postcode: textFieldPincode.text!, mobile: textFieldMobileNumber.text!, state: textFieldState.text!, street: textFieldStreetAddress.text!, landmark:textFieldLandmark.text ?? "", flat_no:textFieldFlatNumber.text!, address_id:shippingAddressData?.address_id!)
                let addShippingAddressRequest = UpdateShippingAddressRequest( updateShippingAddress:addShippingAddress, onSuccess: {
                    response in
                    
                    print(response.toJSON())
                    
                    OperationQueue.main.addOperation() {
                        // when done, update your UI and/or model on the main queue
                        BaseApp.sharedInstance.hideProgressHudView()
                        BaseApp.sharedInstance.showAlertViewControllerWith(title: "Success", message: response.message!, buttonTitle: nil, controller: nil)
                        self.navigationController?.popViewController(animated: true)
                        
                        // TODO: Check and save address id; if address is empty
                        var addressInfo = ApplicationPreference.getAddressInfo()
                        if(addressInfo == nil || addressInfo?.count == 0){
                            addressInfo = response.shippingAddressData?.toJSON() as NSDictionary?
                            ApplicationPreference.saveAddressInfo(addressInfo:addressInfo!)
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
                BaseApp.sharedInstance.jobManager?.addOperation(addShippingAddressRequest)
            }
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
}
