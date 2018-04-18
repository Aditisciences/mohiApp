//
//  ProfileUpdateCustomAlertViewController.swift
//  Ikan
//

import Foundation

protocol ProfileUpdateCustomAlertViewControllerDelegate {
    func removeProfileUpdateCustomAlertViewControllerScr()
    func cancelProfileUpdateCustomAlertViewControllerScr()
    func saveProfileInfo()
}

class ProfileUpdateCustomAlertViewController: BaseViewController {
    
    @IBOutlet weak var titleHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var buttonError: UIButton!
    
    var delegate:ProfileUpdateCustomAlertViewControllerDelegate?
    
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
            delegate?.removeProfileUpdateCustomAlertViewControllerScr()
        }
    }
    
    @IBAction func methodCancelAction(_ sender: Any) {
        self.view.removeFromSuperview()
        if(delegate != nil){
            delegate?.cancelProfileUpdateCustomAlertViewControllerScr()
        }
    }
    
    @IBAction func methodOkAction(_ sender: Any) {
        self.view.removeFromSuperview()
        if(delegate != nil){
            delegate?.saveProfileInfo()
        }
    }
}
