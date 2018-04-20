//
//  SliderHomeVC.swift
//  Mohi
//
//  Created by Yogesh55 on 3/20/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import UIKit

class GLPresentViewController: UIViewController {
    
    var presentLabel: UILabel = UILabel()
    
    internal var _title : NSString = "Page Zero"
    internal var _setupSubViews:Bool = false
    
    init(title : NSString) {
        _title = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentLabel.text = self._title as String
        self.presentLabel.sizeToFit()
        self.view.addSubview(self.presentLabel)
        self.presentLabel.center = self.view.center
    }
    
    override func viewWillLayoutSubviews() {
        self.presentLabel.center = self.view.center
    }
}


class SlideProfileVC: GLViewPagerViewController,GLViewPagerViewControllerDataSource,GLViewPagerViewControllerDelegate {
    
    var titleLabel = UILabel()
    var btnImageView = UIButton()

    fileprivate var loginErrorAlertViewController:LoginErrorAlertViewController?
    fileprivate var loginViewController:LoginViewController?
    fileprivate var signUpViewController:SignUpViewController?
    // MARK: - cache properties
    var viewControllers: NSArray = NSArray()
    var tabTitles: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.tabContentView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: tabContentView.frame.height)
        
        self.initializeMainProfileView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        updateProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       // accountMenuList()
        
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
    
    fileprivate func updateProfile(){
        let loginInfo = ApplicationPreference.getLoginInfo()
        let loginServerInfo = APIResponseParam.Login().getModelObjectFromServerResponse(jsonResponse: loginInfo as AnyObject)
        
        if(loginServerInfo != nil){
            let loginData = loginServerInfo?.loginData
            if(loginData != nil){
                self.titleLabel.text = (loginData?.firstname)! + " " + (loginData?.lastname)!
                if(loginData?.user_image != nil){
                    self.btnImageView.sd_setImage(with: URL(string: ((loginData?.user_image)!)), for: .normal, completed: nil)
                    //self.backImageView.sd_setImage(with: URL(string: ((loginData?.user_image)!)), placeholderImage: UIImage(), completed: nil)
                }
            }
        } else {
            self.titleLabel.text = "Guest User"
            //self.backImageView.setImage(UIImage(), for: UIControlState.normal)
        }
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
        //self.viewBlurEffect.addSubview((loginErrorAlertViewController?.view)!)
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
    
    
    private func initializeMainProfileView() {
        var backImageView = UIImageView()
        backImageView = UIImageView(image: UIImage(named: "profileSliderBG"))
        backImageView.frame = UIScreen.main.bounds
        self.view.addSubview(backImageView)
        
        var titleLabelRect: CGRect = CGRect.zero
        titleLabelRect.origin = CGPoint(x: 155.0, y: 75.0)
        titleLabelRect.size = CGSize(width: AppConstant.ScreenSize.SCREEN_WIDTH - 175, height: 65)
        
        
        btnImageView.frame = CGRect(x: 20, y: 45, width: 120, height: 120)
        btnImageView.backgroundColor = UIColor.blue
        btnImageView.layer.masksToBounds = true
        btnImageView.layer.cornerRadius = 60
        self.view.addSubview(btnImageView)
        
        
        
        titleLabel.frame = titleLabelRect
        titleLabel.text = "Guest\nuser"
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 27.0)
        titleLabel.tag = 55
        self.view.addSubview(titleLabel)
        
        self.view.bringSubview(toFront: self.tabContentView)
        self.view.bringSubview(toFront: self.pageViewController.view)
        
        self.configureScrollableHeaderView()
    }
    
    private func configureScrollableHeaderView() {
        
        //Add page scroller delegate
        self.setDataSource(newDataSource: self)
        self.setDelegate(newDelegate: self)
        
        //Add page scroller padding
        self.padding = 10
        self.leadingPadding = 20
        self.trailingPadding = 20
        self.defaultDisplayPageIndex = 0
        
        //Customize scroll view
        self.tabAnimationType = GLTabAnimationType.GLTabAnimationType_WhileScrolling
        self.supportArabic = false
        self.fixTabWidth = false
        self.fixIndicatorWidth = true
        self.indicatorWidth = 20.0
        self.indicatorColor = UIColor.cyan
        
        self.tabContentView.frame = CGRect(x: 0, y: 170, width: AppConstant.ScreenSize.SCREEN_WIDTH, height: 45)
        
        self.addProfilePageControllers()
    }
    
    private func addProfilePageControllers() {
        let story = UIStoryboard(name: "MyAccount", bundle: nil)
        
        let timelineController = story.instantiateViewController(withIdentifier: "TimelineViewController") as! TimelineViewController

        let profileViewController = story.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        let modifyAddressVC = story.instantiateViewController(withIdentifier: "ModifyAddressVC") as! ModifyAddressVC
        
        let changePassword = story.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        
        self.viewControllers = [timelineController, profileViewController, modifyAddressVC, changePassword]
        
        self.tabTitles = [ "TIMELINE", "PROFILE", "SHIPPING ADDRESS", "CHANGE PASSWORD"]
    }
    
    // MARK: - Layout subviews -
    override func _layoutSubviews() {
        super._layoutSubviews()
        
        let xAxis: CGFloat = 0.0
        let yAxis: CGFloat = self.tabContentView.frame.origin.y + self.tabContentView.frame.size.height
        let width: CGFloat = AppConstant.ScreenSize.SCREEN_WIDTH
        let height: CGFloat = AppConstant.ScreenSize.SCREEN_HEIGHT - yAxis
        let pageControllerRect: CGRect = CGRect(x: xAxis, y: yAxis, width: width, height: height)
        
        self.pageViewController.view.frame = pageControllerRect
    }

    
    // MARK: - GLViewPagerViewController DataSource -
    func numberOfTabsForViewPager(_ viewPager: GLViewPagerViewController) -> Int {
        return self.viewControllers.count
    }
    
    func viewForTabIndex(_ viewPager: GLViewPagerViewController, index: Int) -> UIView {
        let label:UILabel = UILabel.init()
        label.text = self.tabTitles.object(at: index) as? String
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.center
        label.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        return label
    }
    
    func contentViewControllerForTabAtIndex(_ viewPager: GLViewPagerViewController, index: Int) -> UIViewController {
        return self.viewControllers.object(at: index) as! UIViewController
    }
    
    // MARK: - GLViewPagaerViewControllerDelegate
    func didChangeTabToIndex(_ viewPager: GLViewPagerViewController, index: Int, fromTabIndex: Int) {
        
        let prevLabel:UILabel = viewPager.tabViewAtIndex(index: fromTabIndex) as! UILabel
        let currentLabel:UILabel = viewPager.tabViewAtIndex(index: index) as! UILabel

        prevLabel.textColor = UIColor.lightGray
        currentLabel.textColor = UIColor.cyan
    }
    
    func willChangeTabToIndex(_ viewPager: GLViewPagerViewController, index: Int, fromTabIndex: Int, progress: CGFloat) {
        if fromTabIndex == index {
            return;
        }
    }
    
    func widthForTabIndex(_ viewPager: GLViewPagerViewController, index: Int) -> CGFloat {
        let prototypeLabel:UILabel = UILabel.init()
        prototypeLabel.text = self.tabTitles.object(at: index) as? String
        prototypeLabel.textAlignment = NSTextAlignment.center
        prototypeLabel.font = UIFont.systemFont(ofSize: 16.0)
        return prototypeLabel.intrinsicContentSize.width
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SlideProfileVC: LoginErrorAlertViewControllerDelegate{
    func openLoginView() {
        if(loginViewController == nil){
            loginViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.onBoardStoryboard, viewControllerName: LoginViewController.nameOfClass)
            loginViewController?.isDisplaySignUp = false
            BaseApp.sharedInstance.loginCallingScr = LoginCallingScr.MyAccount
            self.navigationController?.pushViewController(loginViewController!, animated: true)
        }
        else{
            self.navigationController?.pushViewController(loginViewController!, animated: true)
        }
    }
    
    func openSignupView() {
        if(signUpViewController == nil){
            signUpViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.onBoardStoryboard, viewControllerName: SignUpViewController.nameOfClass)
            BaseApp.sharedInstance.loginCallingScr = LoginCallingScr.MyAccount
            self.navigationController?.pushViewController(signUpViewController!, animated: true)
        }
        else{
            self.navigationController?.pushViewController(signUpViewController!, animated: true)
        }
    }
}
