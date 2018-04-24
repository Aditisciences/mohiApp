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
    
    @IBOutlet weak var textFieldFirst: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    
    @IBOutlet weak var defaultBillingSwitch: UISwitch!
    @IBOutlet weak var defaultAddressSwitch: UISwitch!
    
     @IBOutlet weak var textFieldStreetAddress: UITextField!
    @IBOutlet weak var textFieldStreetAddress2: UITextField!
    @IBOutlet weak var textFieldCity: CustomTextField!
    @IBOutlet weak var textFieldState: CustomTextField!
    
    @IBOutlet weak var textFieldMobileNumber: CustomTextField!
    @IBOutlet weak var textFieldPincode: CustomTextField!
   
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var newAddressStatusView: UIView!
    
    var shippingAddressData:APIResponseParam.ShippingAddress.ShippingAddressData?
    var screenTitle = ""
    var defaultAddress = true
    var defaultBilling = true
    var gradePicker: UIPickerView!
    var addressId = 0
    let gradePickerValues = ["BH(Bahrain)", "CA(Canada)", "IN(India)","KW(Kuwait)","OM(Oman)","QA(Qatar)","SA(Saudi Arabia)","AE(United Arab Emirates)","GB(United Kingdom)","UN(United States)"]
    override func viewDidLoad() {
        super.viewDidLoad()
        gradePicker = UIPickerView()
        self.gradePicker = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0
        ))
        
        gradePicker.dataSource = self
        gradePicker.delegate = self
countryCodeTextField.inputView = gradePicker
        
        
        if screenTitle.length > 0{
            labelScreenTitle.text = screenTitle
        }
        
        if shippingAddressData != nil{
            textFieldFirst.text = shippingAddressData?.firstname ?? ""
            textFieldLastName.text = shippingAddressData?.lastname ?? ""
            
            textFieldMobileNumber.text = shippingAddressData?.mobile ?? ""
            textFieldPincode.text = shippingAddressData?.postcode ?? ""
            textFieldStreetAddress.text = shippingAddressData?.street1 ?? ""
           textFieldStreetAddress2.text = shippingAddressData?.street2 ?? ""
            
            textFieldCity.text = shippingAddressData?.city ?? ""
            textFieldState.text = shippingAddressData?.state ?? ""
            countryCodeTextField.text = shippingAddressData?.country ?? ""
            if shippingAddressData?.default_billing == true {
                defaultBilling = true
                defaultBillingSwitch.isOn = true
            } else {
                defaultBilling = false
                defaultBillingSwitch.isOn = false
            }
            if shippingAddressData?.default_shipping == true {
                defaultAddress = true
                defaultAddressSwitch.isOn = true
            } else {
                defaultAddress = false
                defaultAddressSwitch.isOn = false
            }
            addressId = shippingAddressData?.address_id ?? 0
        }
        
        self.newAddressStatusView.isHidden = false
      
    }
    @IBAction func backButtonAction(_ sender:Any){
    
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonAction(_ sender:Any){
        if(isFormValid()){
            self.serverAPI()
        }
    }
    @IBAction func defaultAddressAction(_ sender: Any) {
        if defaultAddress {
            defaultAddress = false
        } else {
            defaultAddress = true
        }
    }
    
    @IBAction func defaultBillingAction(_ sender: Any) {
        if defaultBilling {
            defaultBilling = false
        } else {
            defaultBilling = true
        }
    }
    
    @IBAction func countryCodeAction(_ sender: Any) {
        countryCodeTextField.becomeFirstResponder()
        countryCodeTextField.text = gradePickerValues[0]
    }
    
}

//MARK:- Action method implementation
extension AddNewAddressVC{
   
}


// MARK:- filePrivate method implementation
extension AddNewAddressVC{
    
    fileprivate func isFormValid() -> Bool{
        
        var isFound = true
        var message = ""
        
        // checking condition
        if (textFieldFirst.text?.isEmpty)! {
           message = BaseApp.sharedInstance.getMessageForCode("firstNameEmpty", fileName: "Strings")!
            isFound = false
        } else if (textFieldLastName.text?.isEmpty)! {
            message = BaseApp.sharedInstance.getMessageForCode("firstNameEmpty", fileName: "Strings")!
            isFound = false
        }else if (textFieldStreetAddress.text?.isEmpty)! {
            //            message = BaseApp.sharedInstance.getMessageForCode("confirmPassworEmpty", fileName: "Strings")!
            isFound = false
        } else if (textFieldStreetAddress2.text?.isEmpty)! {
           // message = BaseApp.sharedInstance.getMessageForCode("firstNameEmpty", fileName: "Strings")!
            isFound = false
        } else if (textFieldMobileNumber.text?.isEmpty)! {
//            message = BaseApp.sharedInstance.getMessageForCode("emailEmpty", fileName: "Strings")!
            isFound = false
        } else if (textFieldPincode.text?.isEmpty)! {
//            message = BaseApp.sharedInstance.getMessageForCode("passwordEmpty", fileName: "Strings")!
            isFound = false
        } else if(textFieldCity.text?.isEmpty)!{
            //            message = BaseApp.sharedInstance.getMessageForCode("confirmPasswordLowerLimit", fileName: "Strings")!
            isFound = false
        } else if (textFieldState.text?.isEmpty)! {
            //            message = BaseApp.sharedInstance.getMessageForCode("passwordNotMatch", fileName: "Strings")!
            isFound = false
        } else if (countryCodeTextField.text?.isEmpty)! {
            //            message = BaseApp.sharedInstance.getMessageForCode("passwordNotMatch", fileName: "Strings")!
            isFound = false
        }else if (countryCodeTextField.text?.isEmpty)! {
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
        
        if textField == textFieldFirst {
            limitLength = AppConstant.LIMIT_NAME
            isLenCheckReq = true
        } else if textField == textFieldLastName {
            limitLength = AppConstant.LIMIT_NAME
            isLenCheckReq = true
        } else if textField == textFieldStreetAddress || textField == textFieldStreetAddress2 || textField == textFieldCity || textField == countryCodeTextField || textField == textFieldState {
            limitLength = AppConstant.LIMIT_ADDRESS
            isLenCheckReq = true
        } else if textField == textFieldMobileNumber {
            limitLength = AppConstant.LIMIT_PHONE_NUMBER
            isLenCheckReq = true
        } else if textField == textFieldPincode{
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
    
                 let addShippingAddress = APIRequestParam.AddShippingAddress(user_id: ApplicationPreference.getUserId(), token: ApplicationPreference.getAppToken(), firstname: textFieldFirst.text!, lastname: textFieldLastName.text!, street1: textFieldStreetAddress.text!, street2: textFieldStreetAddress2.text!, country: countryCodeTextField.text, city: textFieldCity.text!, postcode: textFieldPincode.text!, mobile: textFieldMobileNumber.text!, state: textFieldState.text!, defaultShipping: defaultAddress, defaultBilling: defaultBilling)
                let addShippingAddressRequest = AddShippingAddressRequest( addShippingAddress:addShippingAddress, onSuccess: {
                    response in
                    
                    print(response.toJSON())
                    
                    OperationQueue.main.addOperation() {
                        // when done, update your UI and/or model on the main queue
                        BaseApp.sharedInstance.hideProgressHudView()
                        BaseApp.sharedInstance.showAlertViewControllerWith(title: "Success", message: response.message!, buttonTitle: nil, controller: nil)
                        
                        // Save Last new address is default of screen in Request
                        // Check and save address id; if address is empty
                         self.dismiss(animated: true, completion: nil)
                      //  self.navigationController?.popViewController(animated: true)
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
                
                let addShippingAddress = APIRequestParam.UpdateShippingAddress(address_id: addressId,user_id: ApplicationPreference.getUserId(), token: ApplicationPreference.getAppToken(), firstname: textFieldFirst.text!, lastname: textFieldLastName.text!, street1: textFieldStreetAddress.text!, street2: textFieldStreetAddress2.text!, country: countryCodeTextField.text, city: textFieldCity.text!, postcode: textFieldPincode.text!, mobile: textFieldMobileNumber.text!, state: textFieldState.text!, defaultShipping: defaultAddress, defaultBilling: defaultBilling)
                let addShippingAddressRequest = UpdateShippingAddressRequest( updateShippingAddress:addShippingAddress, onSuccess: {
                    response in
                    
                    print(response.toJSON())
                    
                    OperationQueue.main.addOperation() {
                        // when done, update your UI and/or model on the main queue
                        BaseApp.sharedInstance.hideProgressHudView()
                        BaseApp.sharedInstance.showAlertViewControllerWith(title: "Success", message: response.message!, buttonTitle: nil, controller: nil)
                          self.dismiss(animated: true, completion: nil)
                        
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

extension AddNewAddressVC : UIPickerViewDelegate,UIPickerViewDataSource{
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
