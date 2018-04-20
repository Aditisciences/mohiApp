//
//  MyAccountVC.swift
//  Mohi
//
//  Created by Consagous on 19/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import SideMenu

class MyAccountVC: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImageView: UIButton!
    @IBOutlet weak var lblForName: UILabel!
//    @IBOutlet weak var viewBgBlurEffect: UIView!
//    @IBOutlet weak var viewBlurEffect: UIView!
    
    var menuList:[MyAccountMenuItem] = []
    fileprivate var logoutViewController:LogoutViewController?
    fileprivate var loginErrorAlertViewController:LoginErrorAlertViewController?
    fileprivate var loginViewController:LoginViewController?
    fileprivate var signUpViewController:SignUpViewController?
    
    struct MyAccountMenuItem{
        var title:String?
        var imageIcon:UIImage?
        var isArrowHidden = false
        var isSwitchHidden = true
        var controller:BaseViewController?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tablView.delegate = self
//        tablView.dataSource = self
//        tablView.register(MyAccountCell.self, forCellReuseIdentifier: "MyAccountCell")

//        tablView.reloadData()
        
//        let loginInfoValue = ApplicationPreference.getLoginInfo()
//        if loginInfoValue != nil {
//            lblForName.text =  (loginInfoValue?.value(forKey: "data") as! NSDictionary).value(forKey: "name") as! String?
//            userImageView.sd_setImage(with: URL(string: ((loginInfoValue?.value(forKey: "data") as! NSDictionary).value(forKey: "user_image") as! String?)!), for: .normal, completed: nil)
//        }else{
//        lblForName.text = ""
//        }
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.layer.borderWidth = 1.0
        userImageView.layer.borderColor =  UIColor.lightGray.cgColor
        userImageView.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        logoutViewController = nil
        loginViewController = nil
        signUpViewController = nil
        
        updateProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        accountMenuList()
        
        if(BaseApp.sharedInstance.isUserAlreadyLoggedInToApplication()){
            if(loginErrorAlertViewController != nil){
                loginErrorAlertViewController?.view.removeFromSuperview()
                loginErrorAlertViewController = nil
                
                removeBlurredBackgroundView()
            }
        }
        
        self.perform(#selector(self.checkNOpenLoginErrorAlert), with: self, afterDelay: 0.2)
        removeBlurredBackgroundView()
        checkNOpenLoginErrorAlert()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Fileprivate method implementation
extension MyAccountVC{
    
    fileprivate func updateProfile(){
        let loginInfo = ApplicationPreference.getLoginInfo()
        let loginServerInfo = APIResponseParam.Login().getModelObjectFromServerResponse(jsonResponse: loginInfo as AnyObject)
        
        if(loginServerInfo != nil){
            let loginData = loginServerInfo?.loginData
            if(loginData != nil){
                self.lblForName.text = (loginData?.firstname)! + (loginData?.lastname)!
                if(loginData?.user_image != nil){
                    self.userImageView.sd_setImage(with: URL(string: ((loginData?.user_image)!)), for: .normal, completed: nil)
                }
            }
        } else {
            self.lblForName.text = "Guest User"
            self.userImageView.setImage(nil, for: UIControlState.normal)
        }
    }
    
    fileprivate func accountMenuList(){
        
        if(menuList.count > 0){
//            for menuItemTemp in menuList{
//                menuItemTemp.controller = nil
//            }
            menuList.removeAll()
        }
        
        var menuItem = MyAccountMenuItem()
        menuItem.title = "Edit Your Account Information"
        menuItem.imageIcon = UIImage(named: "profile_gray")
        menuItem.controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.MyAccountStoryboard, viewControllerName: ProfileViewController.nameOfClass) as ProfileViewController
        menuList.append(menuItem)
        
        menuItem = MyAccountMenuItem()
        menuItem.title = "Change Your Password"
        menuItem.imageIcon = UIImage(named: "key_gray")
        menuItem.controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.MyAccountStoryboard, viewControllerName: ChangePasswordVC.nameOfClass) as ChangePasswordVC
        menuList.append(menuItem)
        
        menuItem = MyAccountMenuItem()
        menuItem.title = "Modify Your Address"
        menuItem.imageIcon = UIImage(named: "location_gray")
        menuItem.controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.MyAccountStoryboard, viewControllerName: ModifyAddressVC.nameOfClass) as ModifyAddressVC
        menuList.append(menuItem)
        
        menuItem = MyAccountMenuItem()
        menuItem.title = "Modify Your Wish List"
        menuItem.imageIcon = UIImage(named: "event-watch")
        menuItem.controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.WishListStoryboard, viewControllerName: WishListVC.nameOfClass) as WishListVC
        menuList.append(menuItem)
        
//        menuItem = MyAccountMenuItem()
//        menuItem.title = "Push Notifications"
//        menuItem.imageIcon = UIImage(named: "ring-gray")
//        menuItem.isArrowHidden = true
//        menuItem.isSwitchHidden = false
//        menuList.append(menuItem)
        
        menuItem = MyAccountMenuItem()
        menuItem.title = "Sign out"
        menuItem.imageIcon = UIImage(named: "logout")
        menuItem.isArrowHidden = true
        menuItem.isSwitchHidden = true
        menuList.append(menuItem)
        
        tableView.reloadData()
    }
    
    @objc fileprivate func checkNOpenLoginErrorAlert(){
        if(!BaseApp.sharedInstance.isUserAlreadyLoggedInToApplication()){
            overlayBlurredBackgroundView()
            
            if(loginErrorAlertViewController == nil){
                loginErrorAlertViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.CustomAlertStoryboard, viewControllerName: LoginErrorAlertViewController.nameOfClass)
            }
            
            loginErrorAlertViewController?.view.frame = self.view.frame
            loginErrorAlertViewController?.delegate = self
            self.view.addSubview((loginErrorAlertViewController?.view)!)
//            self.viewBlurEffect.addSubview((loginErrorAlertViewController?.view)!)
        }
    }
    
    fileprivate func overlayBlurredBackgroundView() {
        
        let blurredBackgroundView = UIVisualEffectView()

        blurredBackgroundView.frame = view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: .dark)

        view.addSubview(blurredBackgroundView)
        
    }
    
    fileprivate func removeBlurredBackgroundView() {
        
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
}

extension MyAccountVC: LoginErrorAlertViewControllerDelegate{
    func openLoginView() {
        if(loginViewController == nil){
            loginViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.onBoardStoryboard, viewControllerName: LoginViewController.nameOfClass)
            loginViewController?.isDisplaySignUp = false
            BaseApp.sharedInstance.loginCallingScr = LoginCallingScr.MyAccount
            self.navigationController?.pushViewController(loginViewController!, animated: true)
        }
    }
    
    func openSignupView() {
        if(signUpViewController == nil){
            signUpViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.onBoardStoryboard, viewControllerName: SignUpViewController.nameOfClass)
            BaseApp.sharedInstance.loginCallingScr = LoginCallingScr.MyAccount
            self.navigationController?.pushViewController(signUpViewController!, animated: true)
        }
    }
}


// MARK:- Action method implementation
extension MyAccountVC {
    func backButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func methodHamburgerAction(_ sender: AnyObject) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
}

extension MyAccountVC: UITableViewDelegate,UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyAccountCell.nameOfClass, for: indexPath) as! MyAccountCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.btnTextNImage.setTitle(menuList[indexPath.row].title, for: .normal)
        cell.btnTextNImage.setImage(menuList[indexPath.row].imageIcon ?? nil, for: UIControlState.normal)
        cell.arrow.isHidden = menuList[indexPath.row].isArrowHidden
        cell.switchNotification.isHidden = menuList[indexPath.row].isSwitchHidden
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myAccountMenuItem = menuList[indexPath.row]
        
        if(myAccountMenuItem.controller != nil){
            self.navigationController?.pushViewController(myAccountMenuItem.controller!, animated: true)
        } else if indexPath.row == menuList.count - 1{
           //BaseApp.sharedInstance.userLogout()
            logoutViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.CustomAlertStoryboard, viewControllerName: LogoutViewController.nameOfClass)
            logoutViewController?.delegate = self
//            self.logoutViewController?.view.frame = self.view.frame
//            self.view.addSubview((logoutViewController?.view)!)
            self.logoutViewController?.modalPresentationStyle = .overFullScreen
            self.present(logoutViewController!, animated: true, completion: nil)
        }
    }
}

extension MyAccountVC:LogoutViewControllerDelegate {
    
    func cancelProfileUpdateCustomAlertViewControllerScr(){
        if(logoutViewController != nil){
//            logoutViewController?.view.removeFromSuperview()
            logoutViewController = nil
        }
    }
    
    func saveProfileInfo(){
        if(logoutViewController != nil){
            logoutViewController?.view.removeFromSuperview()
            logoutViewController = nil
        }
        // remove login screen
        ApplicationPreference.clearAllData()
        BaseApp.sharedInstance.userLogout()
        
        checkNOpenLoginErrorAlert()
        
        updateProfile()
    }
}
