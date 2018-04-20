//
//  DeliveryOptionAlertViewController.swift
//  Mohi
//
//  Created by Apple_iOS on 23/01/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import Foundation

protocol DeliveryOptionAlertViewControllerDelegate {
    func closeDeliveryOptionAlertViewControllerScr()
    func savePincodeInfo(pincode:String)
}

class DeliveryOptionAlertViewController: BaseViewController {
    
    @IBOutlet weak var titleHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var buttonError: UIButton!
    @IBOutlet weak var textFieldPincode: UITextField!
    
    var delegate:DeliveryOptionAlertViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setErrorInfo(title:String?, desc:String, buttonText:String?){
        //        if(title == nil){
        //            titleHeightConstraint.constant = 0
        //        }else{
        //            labelErrorTitle.text = title!
        //        }
        //
        //        labelErrorDesc.text = desc
        //
        //        if(buttonText != nil){
        //            buttonError.setTitle(buttonText, for: UIControlState.normal)
        //        }
        
    }
    
    @IBAction func methodCloseAction(_ sender: Any) {
        self.view.removeFromSuperview()
        if(delegate != nil){
            delegate?.closeDeliveryOptionAlertViewControllerScr()
        }
    }
    
    @IBAction func methodOkAction(_ sender: Any) {
        self.view.removeFromSuperview()
        
        if(textFieldPincode.text?.isEmpty)!{
            BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: BaseApp.sharedInstance.getMessageForCode("emptyPinCode", fileName: "Strings.strings")!, buttonTitle: nil, controller: nil)
        } else{
            if(delegate != nil){
                delegate?.savePincodeInfo(pincode: textFieldPincode.text!)
            }
        }
    }
}
