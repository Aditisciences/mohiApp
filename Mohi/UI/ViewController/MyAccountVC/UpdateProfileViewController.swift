//
//  UpdateProfileViewController.swift
//  Mohi
//
//  Created by Apple on 23/04/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController    {
    @IBOutlet weak var textFieldFirstName:CustomTextField!
    @IBOutlet weak var textFieldLastName:CustomTextField!
    @IBOutlet weak var textFieldCountryCode:CustomTextField!
    @IBOutlet weak var textFieldEmail:CustomTextField!
    @IBOutlet weak var textFieldPhone:CustomTextField!
    @IBOutlet weak var imageViewProfilePicture: UIImageView!
    @IBOutlet weak var buttonImageEdit:UIButton!
    @IBOutlet weak var buttonSave:UIButton!
    
    fileprivate var actionSheetControllerIOS8: UIAlertController!
    fileprivate var profileImageData:Data?
    fileprivate var isScreenDisplayFromImageController = true
    fileprivate var isImageUpdate = false
    fileprivate var profileUpdateCustomAlertViewController:ProfileUpdateCustomAlertViewController?
    
    var gradePicker: UIPickerView!
    let gradePickerValues = ["+91", "+971", "+966","+974","+968","+973","+965","+44","+1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradePicker = UIPickerView()
        self.gradePicker = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0
        ))
        
        gradePicker.dataSource = self
        gradePicker.delegate = self
        textFieldCountryCode.inputView = gradePicker
        prepareScreenInfo()
    }
    
    
    @IBAction func methodEditImage(_ sender: Any){
        self.displayPhotoSelectionOption()
    }
    @IBAction func updateProfile(_ sender: Any) {
        var isFound = true
        textFieldFirstName.resignFirstResponder()
        textFieldLastName.resignFirstResponder()
        textFieldPhone.resignFirstResponder()
        
        // checking condition
        if (textFieldFirstName.text?.isEmpty)! {
            let message = BaseApp.sharedInstance.getMessageForCode("firstNameEmpty", fileName: "Strings")!
            BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: message, buttonTitle: "OK", controller: self)
            isFound = false
        } else if (textFieldLastName.text?.isEmpty)! {
            let message = BaseApp.sharedInstance.getMessageForCode("lastNameEmpty", fileName: "Strings")!
            BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: message, buttonTitle: "OK", controller: self)
            isFound = false
        }
        else if (textFieldPhone.text?.isEmpty)! {
            let message = BaseApp.sharedInstance.getMessageForCode("emptyPhoneNumber", fileName: "Strings")!
            BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: message, buttonTitle: "OK", controller: self)
            isFound = false
        }
        
        if isFound {
            self.isScreenDisplayFromImageController = true
            if isFormValueChange(){
                serverAPIUploadProfile()
            } else{
                BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: BaseApp.sharedInstance.getMessageForCode("noprofileupdate", fileName: "Strings")!, buttonTitle: "OK", controller: self)
            }
        }
    }
    @IBAction func methodBackAction(_ sender: AnyObject) {
        textFieldFirstName.resignFirstResponder()
        textFieldLastName.resignFirstResponder()
        textFieldPhone.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func countryCodeAction(_ sender: Any) {
        textFieldCountryCode.becomeFirstResponder()
         textFieldCountryCode.text = gradePickerValues[0]
    }
}

extension UpdateProfileViewController{
    
    fileprivate func prepareScreenInfo(){
        let loginInfo = ApplicationPreference.getLoginInfo()
        let loginServerInfo = APIResponseParam.Login().getModelObjectFromServerResponse(jsonResponse: loginInfo as AnyObject)
        
        if(loginServerInfo != nil){
            let loginData = loginServerInfo?.loginData
            if(loginData != nil){
                self.textFieldFirstName.text = loginData?.firstname
                self.textFieldLastName.text = loginData?.lastname
                self.textFieldEmail.text = loginData?.email
                self.textFieldPhone.text = loginData?.mobile
                self.textFieldCountryCode.text = loginData?.countryCode
                if(loginData?.user_image != nil){
                    self.imageViewProfilePicture.sd_setImage(with: URL(string: (loginData?.user_image)!), placeholderImage: nil)
                }
            }
        }
    }
    
    fileprivate func displayPhotoSelectionOption(){
        //Create the AlertController and add Its action like button in Actionsheet
        actionSheetControllerIOS8 = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelActionButton: UIAlertAction = UIAlertAction(title: BaseApp.sharedInstance.getMessageForCode("button_cancel", fileName: "Strings")!, style: .cancel) { action -> Void in
            AppConstant.kLogString("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            let option1ActionButton: UIAlertAction = UIAlertAction(title: BaseApp.sharedInstance.getMessageForCode("settings_dialog_camera_text", fileName: "Strings")!, style: .default){ action -> Void in
                self.isScreenDisplayFromImageController = false
                AppConstant.kLogString(BaseApp.sharedInstance.getMessageForCode("settings_dialog_camera_text", fileName: "Strings")!)
                let cameraCapture:CameraCapture? = CameraCapture.sharedInstance() as? CameraCapture
                
                if(cameraCapture != nil){
                    cameraCapture!.launchCamera(on: self, withDelegate: self, withMediaTypeVideo: false, withMediaLibrary: false, withAllowBothTypeMedia: false, isImageCropRequire:true, withImageSize: CGSize.zero)
                }
            }
            
            actionSheetControllerIOS8.addAction(option1ActionButton)
        }
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)){
            let option2ActionButton: UIAlertAction = UIAlertAction(title: BaseApp.sharedInstance.getMessageForCode("settings_dialog_gallery_text", fileName: "Strings")!, style: .default){ action -> Void in
                self.isScreenDisplayFromImageController = false
                
                AppConstant.kLogString(BaseApp.sharedInstance.getMessageForCode("settings_dialog_gallery_text", fileName: "Strings")!)
                let cameraCapture:CameraCapture? = CameraCapture.sharedInstance() as? CameraCapture
                
                if(cameraCapture != nil){
                    cameraCapture!.launchCamera(on: self, withDelegate: self, withMediaTypeVideo: false, withMediaLibrary: true, withAllowBothTypeMedia: false, isImageCropRequire:true, withImageSize: CGSize.zero)
                }
            }
            actionSheetControllerIOS8.addAction(option2ActionButton)
        }
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    fileprivate func isFormValueChange() -> Bool{
        var isFound = false
        let loginInfo = ApplicationPreference.getLoginInfo()
        let loginResInfo = APIResponseParam.Login().getModelObjectFromServerResponse(jsonResponse: loginInfo as AnyObject)
        var fieldName = ""
        let screenInfo = loginResInfo?.loginData
        if(screenInfo != nil){
            if(screenInfo?.firstname != nil && !(textFieldFirstName.text?.isEmpty)! && screenInfo?.firstname?.caseInsensitiveCompare(textFieldFirstName.text!) != ComparisonResult.orderedSame){
                isFound = true
                fieldName = "First name"
            }else if(screenInfo?.lastname != nil && !(textFieldLastName.text?.isEmpty)! && screenInfo?.lastname?.caseInsensitiveCompare(textFieldLastName.text!) != ComparisonResult.orderedSame){
                isFound = true
                fieldName = "Last name"
            }
                
            else if((screenInfo?.mobile == nil && !(textFieldPhone.text?.isEmpty)!) || (screenInfo?.mobile != nil && !(textFieldPhone.text?.isEmpty)! && screenInfo?.mobile?.caseInsensitiveCompare(textFieldPhone.text!) != ComparisonResult.orderedSame)){
                isFound = true
                fieldName = "Phone"
            }
            
            if(isImageUpdate){
                isFound = true
            }
            
            if(isFound){
                //                BaseApp.sharedInstance.showAlertViewControllerWith(title: "", message: "Profile value change in field " + fieldName, buttonTitle: nil, controller: nil)
            }
        }
        
        return isFound
    }
    
}


extension UpdateProfileViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        var limitLength = 0
        let numCheckStatus:Bool = false
        var lenCheckStatus:Bool = false
        let isNumCheckReq = false
        var isLenCheckReq = false
        
        if textField == textFieldFirstName {
            limitLength = AppConstant.LIMIT_NAME
            isLenCheckReq = true
        }else if textField == textFieldLastName {
            limitLength = AppConstant.LIMIT_NAME
            isLenCheckReq = true
        } else if textField ==  textFieldPhone {
            limitLength = AppConstant.LIMIT_PHONE_NUMBER
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
    }
}

// MARK:- Action method implementation
extension UpdateProfileViewController{
    
}

extension UpdateProfileViewController: ProfileUpdateCustomAlertViewControllerDelegate{
    func removeProfileUpdateCustomAlertViewControllerScr() {
        self.profileUpdateCustomAlertViewController = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    func cancelProfileUpdateCustomAlertViewControllerScr() {
        self.profileUpdateCustomAlertViewController = nil
    }
    
    func saveProfileInfo() {
        self.profileUpdateCustomAlertViewController = nil
        self.updateProfile("save")
    }
}

extension UpdateProfileViewController: CameraCaptureDelegate{
    //MARK:- CameraCaptureDelegate protocol method implementation
    func mediaCaptureInfo(withMediaName fileName: String!, withMediaType mediaType: String!, withMediaData mediaData: Data!) {
        if(mediaData != nil){
            let image = UIImage(data:mediaData,scale:1.0)
            self.imageViewProfilePicture.image = image
            self.profileImageData = mediaData
            self.isImageUpdate = true
        }else{
            let alert = UIAlertController(title:nil, message:BaseApp.sharedInstance.getMessageForCode("settings_dialog_unable_to_pick_file", fileName: "Strings"), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title:BaseApp.sharedInstance.getMessageForCode("ok", fileName: "Strings"), style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func cancelMediaCapture() {
}
}

extension UpdateProfileViewController{
    
    func serverAPIUploadProfile(){
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            if(self.profileImageData == nil){
                self.profileImageData = self.imageViewProfilePicture.image?.sd_imageData()
            }
            
            var uploadImageList:[UploadImageData] = []
            var uploadImageData = UploadImageData()
            if(profileImageData != nil){
                uploadImageData.imageName = "ProfileImage.png"
                uploadImageData.imageKeyName = APIConfigConstants.kProfileImageKey
                uploadImageData.imageData = profileImageData
                uploadImageList.append(uploadImageData)
            } else{
                uploadImageData = UploadImageData()
            }
            
            let loginInfo = ApplicationPreference.getLoginInfo()
            let loginServerInfo = APIResponseParam.Login().getModelObjectFromServerResponse(jsonResponse: loginInfo as AnyObject)
            var userId = ""
            var token = ""
            if(loginServerInfo != nil){
                let loginData = loginServerInfo?.loginData
                if(loginData != nil){
                    userId = (loginData?.user_id)!
                    token = (loginData?.token)!
                }}
            let uploadProfileRequestParam = APIRequestParam.UploadProfile(user_id: userId, token: token, firstname: textFieldFirstName.text, lastname: textFieldLastName.text, phone: textFieldPhone.text, countryCode: textFieldCountryCode.text, email: textFieldEmail.text,userProfile : uploadImageData.imageData)
            let uploadProfileRequest = UploadProfileRequest(uploadProfileData: uploadProfileRequestParam, onSuccess: {
                response in
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    print(response.toJSON())
                    // Update profile info on screen
                    self.dismiss(animated: true, completion: nil)
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Success", message: response.message!, buttonTitle: nil, controller: nil)
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

extension UpdateProfileViewController : UIPickerViewDelegate,UIPickerViewDataSource{
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
        textFieldCountryCode.text = gradePickerValues[row]
        self.view.endEditing(true)
    }
}
