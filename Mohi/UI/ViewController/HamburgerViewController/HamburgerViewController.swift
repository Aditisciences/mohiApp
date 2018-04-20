//
//  HamburgerViewController.swift
//  Mohi
//
//  Created by Consagous on 18/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit

class HamburgerViewController: BaseViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblForName: UILabel!
    @IBOutlet weak var btnForUserImage: UIButton!
    
    
    var menus : [HamburgerMenuItem] = []
    
    var dashViewController: UIViewController!
    var searchPanditgViewController: UIViewController!
    var myFavouriteViewController: UIViewController!
    var articlesViewController: UIViewController!
    var myAccountViewController: UIViewController!
    
    fileprivate var loginViewController:LoginViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        SwiftEventBus.onMainThread(self, name:AppConstant.kRefreshProfileImage,
                                   handler: handleRefreshProfileImage)
        
        tableView.register(UINib(nibName: "SideViewCell", bundle: nil), forCellReuseIdentifier: "SideViewCell")
        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menus = BaseApp.sharedInstance.getHamburgerMenuList()
        tableView.reloadData()
        updateProfileImageInfo()
        
        self.navigationController?.isNavigationBarHidden = true
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProfileImageInfo()
        btnForUserImage.layer.cornerRadius = btnForUserImage.frame.size.width/2
        btnForUserImage.layer.borderWidth = 1.0
        btnForUserImage.layer.borderColor =  UIColor.lightGray.cgColor
        btnForUserImage.clipsToBounds = true
    }
}

// MARK:- Handle notification
extension HamburgerViewController{
    func handleRefreshProfileImage(notification: Notification!) -> Void{
        updateProfileImageInfo()
    }
}

extension HamburgerViewController{
    fileprivate func updateProfileImageInfo(){
        let loginInfo = ApplicationPreference.getLoginInfo()
        let loginServerInfo = APIResponseParam.Login().getModelObjectFromServerResponse(jsonResponse: loginInfo as AnyObject)
        
        if(loginServerInfo != nil){
            let loginData = loginServerInfo?.loginData
            if(loginData != nil){
                self.lblForName.text = (loginData?.firstname)! + (loginData?.lastname)!
                if(loginData?.user_image != nil){
                    self.btnForUserImage.sd_setImage(with: URL(string: ((loginData?.user_image)!)), for: .normal, completed: nil)
                }
            }
        } else {
            self.lblForName.text = "Guest User"
            self.btnForUserImage.setImage(nil, for: UIControlState.normal)
        }
    }
}

extension HamburgerViewController{
    @IBAction func methodUserNameAction(_ sender: AnyObject) {
        if(!BaseApp.sharedInstance.isUserAlreadyLoggedInToApplication()){
            if(loginViewController == nil){
                loginViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.onBoardStoryboard, viewControllerName: LoginViewController.nameOfClass)
                BaseApp.sharedInstance.loginCallingScr = LoginCallingScr.Menu
                self.navigationController?.pushViewController(loginViewController!, animated: true)
            }
        } else {
            BaseApp.sharedInstance.openTabScreenWithIndex(index: TabIndex.MyAccount.rawValue)
        }
    }
}

extension HamburgerViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let myString = String(indexPath.row)
//        // Define identifier
//        let notificationName = Notification.Name("MenuSelected")
//        // Post notification
//        NotificationCenter.default.post(name: notificationName, object: myString)
        
        dismiss(animated: true, completion: nil)
        
//        let temp = notification.object as! String
        
        let intTag:Int = indexPath.row
        
        var controller = UIViewController()
        
        switch intTag {
        case HamburgerMenuType.Home.rawValue:
            //dismiss(animated: true, completion: nil)
            BaseApp.sharedInstance.openTabScreenWithIndex(index: intTag)
            break
            
        case HamburgerMenuType.ShopByCategory.rawValue:
            controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ShopByCategoryStoryboard, viewControllerName: ShopByCategoryVC.nameOfClass)
            self.navigationController?.pushViewController(controller, animated: true)
            break
            
        case HamburgerMenuType.DealOfTheDay.rawValue:
            BaseApp.sharedInstance.openTabScreenWithIndex(index: 1)
            break
            
        case HamburgerMenuType.YourOrder.rawValue:
//            controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.YourOrdersStoryboard, viewControllerName: YourOrdersVC.nameOfClass)
//             self.navigationController?.pushViewController(controller, animated: true)
            
           controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.YourOrdersStoryboard, viewControllerName: YourOrderHistoryVC.nameOfClass)
           self.navigationController?.pushViewController(controller, animated: true)
            break
        case HamburgerMenuType.WishList.rawValue:
           controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.WishListStoryboard, viewControllerName: WishListVC.nameOfClass)
            BaseApp.appDelegate.navigationController?.pushViewController(controller, animated: true)
            break
      
        default:
            break
            
        }
    }
}

extension HamburgerViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideViewCell", for: indexPath) as! SideViewCell
        cell.selectionStyle =  .none
        cell.lblForName.text = menus[indexPath.row].title ?? ""
        //cell.btnForImage.setImage(menus[indexPath.row].imageIcon ?? nil, for: UIControlState.normal)
        
        return cell
    }
    
}

