//
//  LogoutViewController.swift
//  Mohi
//
//  Created by Apple_iOS on 15/01/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import Foundation

protocol LogoutViewControllerDelegate {

    func cancelProfileUpdateCustomAlertViewControllerScr()
    func saveProfileInfo()
}

class LogoutViewController: BaseViewController {
    
    @IBOutlet weak var titleHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var buttonError: UIButton!
    
    var delegate:LogoutViewControllerDelegate?
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
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
//        self.view.removeFromSuperview()
        self.dismiss(animated: true, completion: {
            if(self.delegate != nil){
                self.delegate?.cancelProfileUpdateCustomAlertViewControllerScr()
            }
        })
    }
    
    @IBAction func methodCancelAction(_ sender: Any) {
        //        self.view.removeFromSuperview()
        self.dismiss(animated: true, completion: {
            if(self.delegate != nil){
                self.delegate?.cancelProfileUpdateCustomAlertViewControllerScr()
            }
        })
    }
    
    @IBAction func methodOkAction(_ sender: Any) {
        //        self.view.removeFromSuperview()
        self.dismiss(animated: true, completion: {
            if(self.delegate != nil){
                self.delegate?.saveProfileInfo()
            }
        })
    }
}
