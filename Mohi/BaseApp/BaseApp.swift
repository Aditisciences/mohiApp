//
//  BaseApp.swift
//
//

import Foundation
import UIKit
import ReachabilitySwift
import MBProgressHUD
import SideMenu
import NotificationBannerSwift

enum TabIndex:Int{
    case Home
    case Deals
    case MyAccount
    case Cart
    case More
}

enum HamburgerMenuType:Int{
    case Home
    case ShopByCategory
    case DealOfTheDay
    case YourOrder
    case WishList
}

enum LoginCallingScr:Int{
    case Menu
    case MyAccount
    case Cart
    case ProductDetail
}

struct HamburgerMenuItem{
    var title:String?
    var imageIcon:UIImage?
    var controller:BaseViewController?
    var tabIndex:Int = -1
}

struct DeviceInfo{
    var plateform = ""
    var deviceModel = ""
    var osName = ""
    var osVersion = ""
    var locale = ""
    var timeZone = ""
    var advertisingID = ""
    var deviceName = ""
}

class BaseApp : NSObject{
    
    //Variable declaration
    static let sharedInstance = BaseApp()
    internal static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var networkAlert:UIAlertController?
    var jobManager:OperationQueue?
    var isCommonAlertControllerAlreadyPresented = false
//    var loginType = LoginType.NONE
    var hamburgerViewController:HamburgerViewController!
    
    // Reachability instance for Network status monitoring
    fileprivate let reachability = Reachability()!
    var isNetworkConnected = false
    var isInfoLoaded = false
    var deviceInfo:DeviceInfo?
    var loginCallingScr: LoginCallingScr = LoginCallingScr.Menu
    
    fileprivate var dictButtonHolderForMultipleTap:NSMutableDictionary = [:]

    //MARK: - Basic Init setup
    override init () {
        super.init()
        initJobManager()
        
        deviceInfo = getDeviceInfo()
//        CustomLoader.sharedInstance.setupLoader()
    }

    func initJobManager() {
        jobManager = OperationQueue()
        jobManager?.maxConcurrentOperationCount = 50
        jobManager?.qualityOfService = QualityOfService.background
    }
    
    /// Called whenever there is a change in NetworkReachibility Status
    ///
    /// — parameter notification: Notification with the Reachability instance
    func handleNetworkChangeEvent(_ notification: Foundation.Notification!) -> Void {
        let reachability = notification.object as! Reachability
        switch reachability.currentReachabilityStatus {
        case .notReachable:
            debugPrint("Network became unreachable")
            isNetworkConnected = false
            showNetworkNotAvailableAlertController()
        case .reachableViaWiFi:
            debugPrint("Network reachable through WiFi")
            isNetworkConnected = true
            BaseApp.appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
            showScreenInfo()
        case .reachableViaWWAN:
            debugPrint("Network reachable through Cellular Data")
            isNetworkConnected = true
            BaseApp.appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
            
            showScreenInfo()
        }
    }
    
    func showScreenInfo(){
        if(!isInfoLoaded){
            isInfoLoaded = true
            SwiftEventBus.post(AppConstant.kRefreshScreenInfo)
            
            ((UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? TabBarViewController)?.updateViewCartCount()
        }
    }
    
    func showNetworkNotAvailableAlertController(){
        //        if(networkAlert == nil){
        let errorTitle = getMessageForCode("no_internet_title", fileName: "Strings")
        let errorMessage = getMessageForCode("no_internet_message", fileName: "Strings")
        //            networkAlert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        //            let defaultAction = UIAlertAction(title: getMessageForCode("ok", fileName: "Strings")
        //, style: .default, handler: nil)
        //            networkAlert?.addAction(defaultAction)
        //            BaseApp.appDelegate.window?.rootViewController?.present(networkAlert!, animated: true, completion: nil)
        
        // remove all banner queue
        NotificationBannerQueue.default.removeAll()
        
        let banner = NotificationBanner(title: errorTitle!, subtitle: errorMessage, style: .success)
        banner.backgroundColor = UIColor.white
        banner.titleLabel?.textColor = UIColor(hexString: ColorCode.titleTextColor)
        banner.subtitleLabel?.textColor = UIColor(hexString: ColorCode.descTextColor)
        banner.show()
        //}
    }
    
    //MARK:- Preventing button multiple clicks
    fileprivate func isTooEarlyMultipleClicks(_ senderButton:UIButton,delayMillis:String) -> Bool{
        let key = String(format:"%d",senderButton.tag)
        if(dictButtonHolderForMultipleTap.value(forKey: key) as? String != nil){
            //button is already tapped...just check the time stamp
            let lastClickTime = dictButtonHolderForMultipleTap.value(forKey: key) as? String
            let timeStamp = Date().timeIntervalSince1970
            if(lastClickTime! + delayMillis > removeOptionalString(String(describing: timeStamp))){
                return true;
            }
            
        }
        //button tapped first time...just save the time stamp with tag
        let currentTimeMiliSeconds = Date().timeIntervalSince1970
        dictButtonHolderForMultipleTap.setValue(removeOptionalString(String(describing: currentTimeMiliSeconds)), forKey: key)
        return false
    }
    
    func isTooEarlyMultipleClicks(_ senderButton:UIButton) -> Bool {
        print("isTooEarlyMultipleClicks")
        return isTooEarlyMultipleClicks(senderButton, delayMillis: "3000")//default 1 sec
    }
    
    func showVersionUpdateAvailableAlertController(){
        if(networkAlert == nil){
            let errorTitle = getMessageForCode("appUpdateTitle", fileName: "Strings")
            let errorMessage = getMessageForCode("newVersion", fileName: "Strings")
            networkAlert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            BaseApp.appDelegate.window?.rootViewController?.present(networkAlert!, animated: true, completion: nil)
        }
    }
    
    func showTokenExpireAlertController(_ errorView:APIResponseParam.Error?){
        OperationQueue.main.addOperation() {
            self.hideProgressHudView()
            if(self.networkAlert == nil){
                //self.openLoginViewController()
                let errorTitle = self.getMessageForCode("sessionExpireTitle", fileName: "Strings")
                let errorMessage = errorView?.message!
                self.showAlertViewControllerWith(title: errorTitle!, message: errorMessage!, buttonTitle: nil, controller: nil)
            }
        }
    }
    
    //MARK:- Check Network status
    /// Starts monitoring the network availability status
    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handleNetworkChangeEvent),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: ReachabilityChangedNotification,
                                                  object: reachability)
    }
    
    //MARK:- Show common alert view controller
     func showAlertViewControllerWith(title:String?, message:String, buttonTitle:String?, controller:UIViewController?) {
        
        // remove all banner queue
        NotificationBannerQueue.default.removeAll()
        
        let banner = NotificationBanner(title: title!, subtitle: message, style: .success)
        banner.backgroundColor = UIColor.white
        banner.titleLabel?.textColor = UIColor(hexString: ColorCode.titleTextColor)
        banner.subtitleLabel?.textColor = UIColor(hexString: ColorCode.descTextColor)
        banner.show()
    }
    
    /**
     * For showing error dialog if result from an event is false
     * @param title Dialog Title
     * @param error Error message
     */
    func showRestErrorNeutralDialog(title:String, error:ErrorModel?) {
        let errorTitle = title
        let errorMessage = error?.errorMsg
        networkAlert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction = UIAlertAction(title: getMessageForCode("ok", fileName: "Strings")
            , style: .default, handler: nil)
        networkAlert?.addAction(defaultAction)
        BaseApp.appDelegate.window?.rootViewController?.present(networkAlert!, animated: true, completion: nil)
    }
    
    //MARK: - Show/Hide HudView(loader)
    func showProgressHudViewWithTitle(title:String?){
        if( reachability.isReachable){
            hideProgressHudView()
            
//            let loadingNotification = MBProgressHUD.showAdded(to: BaseApp.appDelegate.window!, animated: true)
//            loadingNotification.mode = MBProgressHUDMode.indeterminate
////            loadingNotification.mode = MBProgressHUDMode.customView
//            loadingNotification.label.text =  title!
//            loadingNotification.label.textColor = UIColor.black
//            loadingNotification.alpha = 1.0
//            loadingNotification.color = UIColor.clear
//            loadingNotification.bezelView.color = UIColor.clear
//            loadingNotification.backgroundView.backgroundColor = UIColor.clear
//            loadingNotification.contentColor = UIColor.clear
//            loadingNotification.label.font = FontsConfig.FontHelper.defaultFontUbantuWithSizeL(FontsConfig.FONT_SIZE_14)
            
            CustomLoader.sharedInstance.showLoader()
        }
    }
    
    func hideProgressHudView(){
//        MBProgressHUD.hide(for: BaseApp.appDelegate.window!, animated: true)
        CustomLoader.sharedInstance.removeLoader()
    }

    func removeOptionalString(_ convertText:String) -> String{
        var convertedString = convertText
        convertedString = convertedString.replacingOccurrences(of: "Optional(", with: "")
        convertedString = convertedString.replacingOccurrences(of: ")", with: "")
        return convertedString
    }
    
    func convertDicToStr(_ dict: NSDictionary) -> String{
        do{
            if let data = try JSONSerialization.data(withJSONObject: dict, options: []) as? Data {
                if let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return json as String
                }
            }
        } catch let error as NSError {
            AppConstant.klogString(error.localizedDescription)
        }
        
        return ""
    }

    //MARK:- Load value from string file to show text in diffrent language
    func getMessageForCode(_ constantName:String, fileName:String) -> String? {
        return NSLocalizedString(constantName, tableName: fileName, bundle: Bundle.main, value: "", comment: "")
    }
    
    func getViewController<T: UIViewController>(storyboardName:String, viewControllerName:String) -> T {
        let storyBoard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: viewControllerName) as! T
        return viewController
    }
    
    
    func getHamburgerMenuList() -> [HamburgerMenuItem]{
        
        var menuList:[HamburgerMenuItem] = []
        
        var menuItem = HamburgerMenuItem()
        menuItem.title = "HOME"
        menuItem.imageIcon = UIImage(named: "home-inactive")
        menuItem.tabIndex = HamburgerMenuType.Home.rawValue
        menuList.append(menuItem)
        
        menuItem = HamburgerMenuItem()
        menuItem.title = "HELP"
        menuItem.imageIcon = UIImage(named: "shop-by-category")
        menuItem.controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ShopByCategoryStoryboard, viewControllerName: ShopByCategoryVC.nameOfClass) as ShopByCategoryVC
        menuItem.tabIndex = HamburgerMenuType.ShopByCategory.rawValue
        //MARK:- Remove as per user request on 16-Jan-18
        menuList.append(menuItem)
        
        menuItem = HamburgerMenuItem()
        menuItem.title = "FAQ"
        menuItem.imageIcon = UIImage(named: "deals_tag_white")
        menuItem.tabIndex = HamburgerMenuType.DealOfTheDay.rawValue
        menuList.append(menuItem)
        
        menuItem = HamburgerMenuItem()
        menuItem.title = "ABOUT"
        menuItem.imageIcon = UIImage(named: "deals_tag_white")
        menuItem.tabIndex = HamburgerMenuType.DealOfTheDay.rawValue
        menuList.append(menuItem)
        
        menuItem = HamburgerMenuItem()
        menuItem.title = "RATE THE APP"
        menuItem.imageIcon = UIImage(named: "deals_tag_white")
        menuItem.tabIndex = HamburgerMenuType.DealOfTheDay.rawValue
        menuList.append(menuItem)
        
//        if(isUserAlreadyLoggedInToApplication()){
//            menuItem = HamburgerMenuItem()
//            menuItem.title = "Your Orders"
//            menuItem.imageIcon = UIImage(named: "order-bag")
//            menuItem.controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.YourOrdersStoryboard, viewControllerName: YourOrdersVC.nameOfClass) as YourOrdersVC
//            menuItem.tabIndex = HamburgerMenuType.YourOrder.rawValue
//            menuList.append(menuItem)
//
//            menuItem = HamburgerMenuItem()
//            menuItem.title = "Wish List"
//            menuItem.imageIcon = UIImage(named: "wishlist-gray")
//            menuItem.controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.WishListStoryboard, viewControllerName: WishListVC.nameOfClass) as WishListVC
//            menuItem.tabIndex = HamburgerMenuType.WishList.rawValue
//            menuList.append(menuItem)
//        }
        
        return menuList
    }
    
    func setupSideMenu(navigationViewController:UINavigationController){
        
        hamburgerViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.HamburgerStoryboard, viewControllerName: HamburgerViewController.nameOfClass) as HamburgerViewController
        
        // Define the menus
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: hamburgerViewController)
        menuLeftNavigationController.leftSide = true
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: navigationViewController.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: navigationViewController.view)
        
        SideMenuManager.menuPresentMode = .menuSlideIn
    }
    
    //MARK:- Customize Navigation bar
    func setUpNavigationBarCustomViews(buttonImage:String,iconImage:String?, title:String, description:String?,navigationItem:UINavigationItem,navigationBarLeftButtonAction:Selector, navigationBarDetailButtonAction:Selector?, navigationBarRightButtonTitle:String?, navigationBarRightButtonAction:Selector?, target:UIViewController, navigationHide: Bool) {
        
        //Left view setup
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.appTheamWhiteColor()
        }
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: (BaseApp.appDelegate.window?.frame.size.width)!, height: 44))
        customView.backgroundColor = UIColor.appTheamWhiteColor()
        target.navigationController?.isNavigationBarHidden = navigationHide
        
        //button-back
        let buttonBack = UIButton(type: UIButtonType.custom)
        buttonBack.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        buttonBack.setImage(UIImage(named:buttonImage), for: .normal)
        buttonBack.addTarget(target, action:Selector(NSStringFromSelector(navigationBarLeftButtonAction)), for: UIControlEvents.touchUpInside)
        buttonBack.backgroundColor = UIColor.clear
        customView.addSubview(buttonBack)
        
        // button- detail
        if(navigationBarDetailButtonAction != nil){
            let recognizer = UITapGestureRecognizer(target: target, action: Selector(NSStringFromSelector(navigationBarDetailButtonAction!)))
            customView.isUserInteractionEnabled = true
            customView.addGestureRecognizer(recognizer)
        }
        
        //icon image
        var marginX:CGFloat?
        if(iconImage != nil){
            let imageViewIcon = UIImageView(frame: CGRect(x: buttonBack.frame.size.width + 3, y: 4, width: 36, height: 36))
            imageViewIcon.backgroundColor = UIColor.gray
            //imageViewIcon.image = UIImage(named: iconImage!)
          //  imageViewIcon.setImageWith(NSURL(string: (iconImage!)) as! URL)
            imageViewIcon.layer.cornerRadius = imageViewIcon.frame.size.width/2
            imageViewIcon.clipsToBounds = true
            customView.addSubview(imageViewIcon)
            marginX = CGFloat(imageViewIcon.frame.origin.x + imageViewIcon.frame.size.width + 8)
        }else{
            marginX = CGFloat(buttonBack.frame.origin.x + buttonBack.frame.size.width + 3)
        }
        
        // add right navigation text button
        var rightButtonWidth:CGFloat = 0
        if(navigationBarRightButtonTitle != nil && navigationBarRightButtonAction != nil){
            let buttonRight = UIButton(type: UIButtonType.custom)
            let stringRect = navigationBarRightButtonTitle?.boundingRect(with: CGSize(width: CGFloat(CGFloat.greatestFiniteMagnitude), height:44), options: ([.usesLineFragmentOrigin, .usesFontLeading]), attributes: [NSAttributedStringKey.font: FontsConfig.FontHelper.defaultFontUbantuWithSizeL(FontsConfig.FONT_SIZE_14)], context: nil)
            rightButtonWidth = ceil(stringRect?.width ?? 0) + 10
            let rectFrame = customView.frame
            buttonRight.frame = CGRect(x: rectFrame.size.width - (rightButtonWidth + 10), y: 0, width: rightButtonWidth, height: 44)
            buttonRight.addTarget(target, action:Selector(NSStringFromSelector(navigationBarRightButtonAction!)), for: UIControlEvents.touchUpInside)
            buttonRight.titleLabel?.font =  FontsConfig.FontHelper.defaultFontUbantuWithSizeL(FontsConfig.FONT_SIZE_14)
            buttonRight.setTitle(navigationBarRightButtonTitle, for: UIControlState.normal)
            buttonRight.setTitleColor(UIColor(hexString: ColorCode.buttonGroupDetailBlueColor), for: UIControlState.normal)
            customView.addSubview(buttonRight)
        }
        
        //lable for title and description
        if(description != nil){
            let labelTitle = UILabel(frame: CGRect(x: marginX!, y: 8, width: (customView.frame.size.width - marginX! - 25) - rightButtonWidth, height: 20))
            labelTitle.text = title
            labelTitle.font = FontsConfig.FontHelper.defaultFontUbantuWithSizeL(FontsConfig.FONT_SIZE_21)
            labelTitle.textColor = UIColor(red: (33.0/255.0), green: (33.0/255.0), blue: (33.0/255.0), alpha: 1.0)
            labelTitle.textAlignment = NSTextAlignment.center
            labelTitle.backgroundColor = UIColor.clear
            customView.addSubview(labelTitle)
            
            let labelDescription = UILabel(frame: CGRect(x: labelTitle.frame.origin.x, y: 24, width: labelTitle.frame.size.width, height: 15))
            labelDescription.text = description
            labelDescription.font = FontsConfig.FontHelper.defaultFontUbantuWithSizeL(FontsConfig.FONT_SIZE_21)
            labelDescription.textColor = UIColor(red: (33.0/255.0), green: (33.0/255.0), blue: (33.0/255.0), alpha: 1.0)
            labelDescription.textAlignment = NSTextAlignment.left
            labelDescription.backgroundColor = UIColor.clear
            customView.addSubview(labelDescription)
        }else{

            // for left-align text only
            //let labelTitle = UILabel(frame: CGRect(x: marginX!, y: 13, width: (customView.frame.size.width - marginX! - 25) - rightButtonWidth, height: 20))
            
            // for center-algin
            let labelTitle = UILabel(frame: CGRect(x: marginX!, y: 13, width: (customView.frame.size.width - (marginX!*2) - rightButtonWidth), height: 20))
            labelTitle.text = title
            labelTitle.font = FontsConfig.FontHelper.defaultFontUbantuWithSizeL(FontsConfig.FONT_SIZE_14)
            labelTitle.textColor = UIColor(red: (33.0/255.0), green: (33.0/255.0), blue: (33.0/255.0), alpha: 1.0)
            labelTitle.textAlignment = NSTextAlignment.center
            labelTitle.backgroundColor = UIColor.clear
            customView.addSubview(labelTitle)
        }
        
        let leftButton = UIBarButtonItem(customView: customView)
        
        //left side blank spave filler
        let leftSidePaddingFiller = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        leftSidePaddingFiller.width = -16
        navigationItem.leftBarButtonItems = [leftSidePaddingFiller,leftButton]
    }
    
    //MARK:- Check if user if already logged in to application
//    func isUserAlreadyLoggedInToApplication() -> Bool{
//        let userName = ApplicationPreference.getUserName()
//        if(userName != nil){
//            return true
//        }
//        return false
//    }
    
    //MARK:- Get Device info
    func getDeviceInfo() -> DeviceInfo{
        // common device parameters
        let device = UIDevice.current
        var model = DeviceInfo()
        
        model.plateform = device.systemName
        model.deviceModel = device.model
        model.osName = device.systemName
        model.osVersion = device.systemVersion
        model.locale = Locale.current.regionCode!
        model.timeZone = TimeZone.current.abbreviation()!
        model.advertisingID = device.identifierForVendor!.uuidString
        model.deviceName = device.name
        
        return model
    }
    
    // customize label to show green icon on it, instead of using uiimageview control
    func convertSimpleTextToAttributedTextIcon(_ textStr:String, isIconLeftSide:Bool, isIconAdd:Bool, iconName:String? = nil, iconOffset:CGPoint? = CGPoint.zero, iconFixedSize:CGSize? = CGSize.zero) -> NSMutableAttributedString?{
        let attachment = NSTextAttachment()
        let attributeStr = NSMutableAttributedString(string:textStr)
        var attachmentString:NSMutableAttributedString? = nil
        var myImage:UIImage? = nil
        var myImageSize:CGSize = CGSize.zero
        
        if(iconName != nil){
            myImage = UIImage(named: iconName!)
        }
        
        if(myImage != nil){
            attachment.image = myImage
            
            if(iconFixedSize != nil && (iconFixedSize?.width)! > CGFloat(0) || (iconFixedSize?.height)! > CGFloat(0)){
                myImageSize = iconFixedSize!
            }else{
                myImageSize = myImage!.size
            }
            attachment.bounds = CGRect(origin: iconOffset!, size: myImageSize)
        }
        
        if(isIconAdd){
            if(isIconLeftSide){
                attachmentString = NSMutableAttributedString(attributedString: NSMutableAttributedString(string: "    "))
                attachmentString?.append(NSAttributedString(attachment: attachment))
                attachmentString!.append(attributeStr)
            }else{
                attachmentString = NSMutableAttributedString(attributedString: attributeStr)
                attachmentString!.append(NSMutableAttributedString(string: "  "))
                attachmentString?.append(NSAttributedString(attachment: attachment))
            }
            
        }else{
            attachmentString = NSMutableAttributedString(attributedString: attributeStr)
        }
        
        return attachmentString ?? nil
    }
    
    func convertSimpleTextToAttributedTextHiddenHeader(_ placeholder:String, _ pincode:String) -> NSMutableAttributedString?{
        
        let placeholderStr = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.font: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(14)])
        let pincodeStr = NSAttributedString(string: pincode, attributes: [NSAttributedStringKey.font: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(14), NSAttributedStringKey.foregroundColor: UIColor(hexString: ColorCode.primaryColor) ?? UIColor.white])
        
        var attachmentString:NSMutableAttributedString? = nil
        
        attachmentString = NSMutableAttributedString(attributedString: placeholderStr)
        attachmentString!.append(pincodeStr)
        
        
        return attachmentString ?? nil
    }
    
    //View Controller
    func openDashboardViewControllerOnSkip(){
        BaseApp.appDelegate.isAllowSkip = true
        BaseApp.appDelegate.setUpApplicationRootView()
    }
    
    //MARK:- Remove Optional from string
    func removeOptionalWordFromString(_ convertText:String) -> String{
        var convertedString = convertText
        convertedString = convertedString.replacingOccurrences(of: "Optional(", with: "")
        convertedString = convertedString.replacingOccurrences(of: ")", with: "")
        return convertedString
    }
    
//    func parsePhoneString(phone:String) -> Int64{
//        //        try {
//        //        String validDigits = OTHER_THAN_DIGIT_PATTERN.matcher(phone.trim()).replaceAll("");
//        //        return Long.parseLong(validDigits);
//        //        } catch (Exception ignore) {
//        //        log.warn("parsePhoneString failed: " + phone, ignore);
//        //        }
//        //        return -1L;
//        
//        let result = String(phone.characters.filter { DIGIT_PATTERN.characters.contains($0) })
//        return Int64(result) ?? 0
//    }
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
//    func showShortToast(_ message:String, onView:UIView){
//        // default percentage
//        ToastManager.shared.style.maxWidthPercentage = 1.0
//        ToastManager.shared.style.messageFont = FontsConfig.FontHelper.defaultLightFontWithSize(FontsConfig.FONT_SIZE_NORMAL)
//        onView.makeToast(message, duration: 0.9, position: CGPoint(x:onView.center.x, y: 90))
//        BaseApp.appDelegate.window?.rootViewController?.navigationController?.view.makeToast(message, duration: 0.9, position: .top)
//    }
    
    
    //MARK:- Check if user if already logged in to application
    func isUserAlreadyLoggedInToApplication() -> Bool{
        let loginInfo = ApplicationPreference.getLoginInfo()
        if(loginInfo != nil){
            return true
        }
        return false
    }
    
    func getAttributeTextWithFont(text:String, font:UIFont) -> NSAttributedString?{
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.lightGray,
            NSAttributedStringKey.font : font // Note the !
        ]
        return NSAttributedString(string: text, attributes:attributes)
    }
    
    func getDeviceCountryISO() -> String?{
        
        //fetch the device locality info and get the Country code detailed info
        let countryDetails = getDeviceLocality()
        
        //set fetched country info as by default to UI
        let countryName = countryDetails.object(forKey: AppConstant.localCountryCode) as? String
        
        return countryName
    }
    
    func getDeviceDialCode() -> String?{
        //fetch the device locality info and get the Country code detailed info
        let countryDetails = getDeviceLocality()
        
        //set fetched country info as by default to UI
        let dialCode = countryDetails.object(forKey: AppConstant.localCountryDialCode) as? String
        
        return dialCode
    }
    
    
    //MARK:- Country Code Fetching methods
    func getDeviceLocality() -> NSDictionary{
        let locale = Locale.current
        var countryShortCode = "IN"
        if(locale.regionCode != nil){
            countryShortCode = locale.regionCode!
        }
        let countryDetails = BaseApp.sharedInstance.getCountryLocalityDetailsFor(countryCode: countryShortCode)
        return countryDetails
    }
    
    func getCountryLocalityDetailsFor(countryCode:String) -> NSDictionary{
        let countties  = self.getCountryListWithCountryCode()
        var defaultCountry = ["name":"India","dial_code":"+91","code":"IN"]
        for country in countties{
            if((country as! NSDictionary).value(forKey: "code") as! String == countryCode){
                defaultCountry = country as! [String : String]
            }
        }
        AppConstant.kLogString(defaultCountry)
        return defaultCountry as NSDictionary
    }
    
    //TODO:- Put the json in json file ...remove from controller after implemntation
    func getCountryListWithCountryCode() -> NSMutableArray{
        let arrayCountires:NSMutableArray = [["name":"Afghanistan","dial_code":"+93","code":"AF"],["name":"Antarctica","dial_code":"+672","code":"AQ"],["name":"Albania","dial_code":"+355","code":"AL"],["name":"Algeria","dial_code":"+213","code":"DZ"],["name":"AmericanSamoa","dial_code":"+1 684","code":"AS"],["name":"Andorra","dial_code":"+376","code":"AD"],["name":"Angola","dial_code":"+244","code":"AO"],["name":"Anguilla","dial_code":"+1 264","code":"AI"],["name":"Antigua and Barbuda","dial_code":"+1268","code":"AG"],["name":"Argentina","dial_code":"+54","code":"AR"],["name":"Armenia","dial_code":"+374","code":"AM"],["name":"Aruba","dial_code":"+297","code":"AW"],["name":"Australia","dial_code":"+61","code":"AU"],["name":"Austria","dial_code":"+43","code":"AT"],["name":"Azerbaijan","dial_code":"+994","code":"AZ"],["name":"Bahamas","dial_code":"+1 242","code":"BS"],["name":"Bahrain","dial_code":"+973","code":"BH"],["name":"Bangladesh","dial_code":"+880","code":"BD"],["name":"Barbados","dial_code":"+1 246","code":"BB"],["name":"Belarus","dial_code":"+375","code":"BY"],["name":"Belgium","dial_code":"+32","code":"BE"],["name":"Belize","dial_code":"+501","code":"BZ"],["name":"Benin","dial_code":"+229","code":"BJ"],["name":"Bermuda","dial_code":"+1 441","code":"BM"],["name":"Bhutan","dial_code":"+975","code":"BT"],["name":"Bosnia and Herzegovina","dial_code":"+387","code":"BA"],["name":"Botswana","dial_code":"+267","code":"BW"],["name":"Brazil","dial_code":"+55","code":"BR"],["name":"British Indian Ocean Territory","dial_code":"+246","code":"IO"],["name":"Bulgaria","dial_code":"+359","code":"BG"],["name":"Burkina Faso","dial_code":"+226","code":"BF"],["name":"Burundi","dial_code":"+257","code":"BI"],["name":"Cambodia","dial_code":"+855","code":"KH"],["name":"Cameroon","dial_code":"+237","code":"CM"],["name":"Canada","dial_code":"+1","code":"CA"],["name":"Cape Verde","dial_code":"+238","code":"CV"],["name":"Cayman Islands","dial_code":"+ 345","code":"KY"],["name":"Central African Republic","dial_code":"+236","code":"CF"],["name":"Chad","dial_code":"+235","code":"TD"],["name":"Chile","dial_code":"+56","code":"CL"],["name":"China","dial_code":"+86","code":"CN"],["name":"Christmas Island","dial_code":"+61","code":"CX"],["name":"Colombia","dial_code":"+57","code":"CO"],["name":"Comoros","dial_code":"+269","code":"KM"],["name":"Congo","dial_code":"+242","code":"CG"],["name":"Cook Islands","dial_code":"+682","code":"CK"],["name":"Costa Rica","dial_code":"+506","code":"CR"],["name":"Croatia","dial_code":"+385","code":"HR"],["name":"Cuba","dial_code":"+53","code":"CU"],["name":"Cyprus","dial_code":"+537","code":"CY"],["name":"Czech Republic","dial_code":"+420","code":"CZ"],["name":"Denmark","dial_code":"+45","code":"DK"],["name":"Djibouti","dial_code":"+253","code":"DJ"],["name":"Dominica","dial_code":"+1 767","code":"DM"],["name":"Dominican Republic","dial_code":"+1 849","code":"DO"],["name":"Ecuador","dial_code":"+593","code":"EC"],["name":"Egypt","dial_code":"+20","code":"EG"],["name":"El Salvador","dial_code":"+503","code":"SV"],["name":"Equatorial Guinea","dial_code":"+240","code":"GQ"],["name":"Eritrea","dial_code":"+291","code":"ER"],["name":"Estonia","dial_code":"+372","code":"EE"],["name":"Ethiopia","dial_code":"+251","code":"ET"],["name":"Faroe Islands","dial_code":"+298","code":"FO"],["name":"Fiji","dial_code":"+679","code":"FJ"],["name":"Finland","dial_code":"+358","code":"FI"],["name":"France","dial_code":"+33","code":"FR"],["name":"French Guiana","dial_code":"+594","code":"GF"],["name":"French Polynesia","dial_code":"+689","code":"PF"],["name":"Gabon","dial_code":"+241","code":"GA"],["name":"Gambia","dial_code":"+220","code":"GM"],["name":"Georgia","dial_code":"+995","code":"GE"],["name":"Germany","dial_code":"+49","code":"DE"],["name":"Ghana","dial_code":"+233","code":"GH"],["name":"Gibraltar","dial_code":"+350","code":"GI"],["name":"Greece","dial_code":"+30","code":"GR"],["name":"Greenland","dial_code":"+299","code":"GL"],["name":"Grenada","dial_code":"+1 473","code":"GD"],["name":"Guadeloupe","dial_code":"+590","code":"GP"],["name":"Guam","dial_code":"+1 671","code":"GU"],["name":"Guatemala","dial_code":"+502","code":"GT"],["name":"Guinea","dial_code":"+224","code":"GN"],["name":"Guinea-Bissau","dial_code":"+245","code":"GW"],["name":"Guyana","dial_code":"+595","code":"GY"],["name":"Haiti","dial_code":"+509","code":"HT"],["name":"Honduras","dial_code":"+504","code":"HN"],["name":"Hungary","dial_code":"+36","code":"HU"],["name":"Iceland","dial_code":"+354","code":"IS"],["name":"India","dial_code":"+91","code":"IN"],["name":"Indonesia","dial_code":"+62","code":"ID"],["name":"Iraq","dial_code":"+964","code":"IQ"],["name":"Ireland","dial_code":"+353","code":"IE"],["name":"Israel","dial_code":"+972","code":"IL"],["name":"Italy","dial_code":"+39","code":"IT"],["name":"Jamaica","dial_code":"+1 876","code":"JM"],["name":"Japan","dial_code":"+81","code":"JP"],["name":"Jordan","dial_code":"+962","code":"JO"],["name":"Kazakhstan","dial_code":"+7 7","code":"KZ"],["name":"Kenya","dial_code":"+254","code":"KE"],["name":"Kiribati","dial_code":"+686","code":"KI"],["name":"Kuwait","dial_code":"+965","code":"KW"],["name":"Kyrgyzstan","dial_code":"+996","code":"KG"],["name":"Latvia","dial_code":"+371","code":"LV"],["name":"Lebanon","dial_code":"+961","code":"LB"],["name":"Lesotho","dial_code":"+266","code":"LS"],["name":"Liberia","dial_code":"+231","code":"LR"],["name":"Liechtenstein","dial_code":"+423","code":"LI"],["name":"Lithuania","dial_code":"+370","code":"LT"],["name":"Luxembourg","dial_code":"+352","code":"LU"],["name":"Madagascar","dial_code":"+261","code":"MG"],["name":"Malawi","dial_code":"+265","code":"MW"],["name":"Malaysia","dial_code":"+60","code":"MY"],["name":"Maldives","dial_code":"+960","code":"MV"],["name":"Mali","dial_code":"+223","code":"ML"],["name":"Malta","dial_code":"+356","code":"MT"],["name":"Marshall Islands","dial_code":"+692","code":"MH"],["name":"Martinique","dial_code":"+596","code":"MQ"],["name":"Mauritania","dial_code":"+222","code":"MR"],["name":"Mauritius","dial_code":"+230","code":"MU"],["name":"Mayotte","dial_code":"+262","code":"YT"],["name":"Mexico","dial_code":"+52","code":"MX"],["name":"Monaco","dial_code":"+377","code":"MC"],["name":"Mongolia","dial_code":"+976","code":"MN"],["name":"Montenegro","dial_code":"+382","code":"ME"],["name":"Montserrat","dial_code":"+1664","code":"MS"],["name":"Morocco","dial_code":"+212","code":"MA"],["name":"Myanmar","dial_code":"+95","code":"MM"],["name":"Namibia","dial_code":"+264","code":"NA"],["name":"Nauru","dial_code":"+674","code":"NR"],["name":"Nepal","dial_code":"+977","code":"NP"],["name":"Netherlands","dial_code":"+31","code":"NL"],["name":"Netherlands Antilles","dial_code":"+599","code":"AN"],["name":"New Caledonia","dial_code":"+687","code":"NC"],["name":"New Zealand","dial_code":"+64","code":"NZ"],["name":"Nicaragua","dial_code":"+505","code":"NI"],["name":"Niger","dial_code":"+227","code":"NE"],["name":"Nigeria","dial_code":"+234","code":"NG"],["name":"Niue","dial_code":"+683","code":"NU"],["name":"Norfolk Island","dial_code":"+672","code":"NF"],["name":"Northern Mariana Islands","dial_code":"+1 670","code":"MP"],["name":"Norway","dial_code":"+47","code":"NO"],["name":"Oman","dial_code":"+968","code":"OM"],["name":"Pakistan","dial_code":"+92","code":"PK"],["name":"Palau","dial_code":"+680","code":"PW"],["name":"Panama","dial_code":"+507","code":"PA"],["name":"Papua New Guinea","dial_code":"+675","code":"PG"],["name":"Paraguay","dial_code":"+595","code":"PY"],["name":"Peru","dial_code":"+51","code":"PE"],["name":"Philippines","dial_code":"+63","code":"PH"],["name":"Poland","dial_code":"+48","code":"PL"],["name":"Portugal","dial_code":"+351","code":"PT"],["name":"Puerto Rico","dial_code":"+1 939","code":"PR"],["name":"Qatar","dial_code":"+974","code":"QA"],["name":"Romania","dial_code":"+40","code":"RO"],["name":"Rwanda","dial_code":"+250","code":"RW"],["name":"Samoa","dial_code":"+685","code":"WS"],["name":"San Marino","dial_code":"+378","code":"SM"],["name":"Saudi Arabia","dial_code":"+966","code":"SA"],["name":"Senegal","dial_code":"+221","code":"SN"],["name":"Serbia","dial_code":"+381","code":"RS"],["name":"Seychelles","dial_code":"+248","code":"SC"],["name":"Sierra Leone","dial_code":"+232","code":"SL"],["name":"Singapore","dial_code":"+65","code":"SG"],["name":"Slovakia","dial_code":"+421","code":"SK"],["name":"Slovenia","dial_code":"+386","code":"SI"],["name":"Solomon Islands","dial_code":"+677","code":"SB"],["name":"South Africa","dial_code":"+27","code":"ZA"],["name":"South Georgia and the South Sandwich Islands","dial_code":"+500","code":"GS"],["name":"Spain","dial_code":"+34","code":"ES"],["name":"Sri Lanka","dial_code":"+94","code":"LK"],["name":"Sudan","dial_code":"+249","code":"SD"],["name":"Suriname","dial_code":"+597","code":"SR"],["name":"Swaziland","dial_code":"+268","code":"SZ"],["name":"Sweden","dial_code":"+46","code":"SE"],["name":"Switzerland","dial_code":"+41","code":"CH"],["name":"Tajikistan","dial_code":"+992","code":"TJ"],["name":"Thailand","dial_code":"+66","code":"TH"],["name":"Togo","dial_code":"+228","code":"TG"],["name":"Tokelau","dial_code":"+690","code":"TK"],["name":"Tonga","dial_code":"+676","code":"TO"],["name":"Trinidad and Tobago","dial_code":"+1 868","code":"TT"],["name":"Tunisia","dial_code":"+216","code":"TN"],["name":"Turkey","dial_code":"+90","code":"TR"],["name":"Turkmenistan","dial_code":"+993","code":"TM"],["name":"Turks and Caicos Islands","dial_code":"+1 649","code":"TC"],["name":"Tuvalu","dial_code":"+688","code":"TV"],["name":"Uganda","dial_code":"+256","code":"UG"],["name":"Ukraine","dial_code":"+380","code":"UA"],["name":"United Arab Emirates","dial_code":"+971","code":"AE"],["name":"United Kingdom","dial_code":"+44","code":"GB"],["name":"United States","dial_code":"+1","code":"US"],["name":"Uruguay","dial_code":"+598","code":"UY"],["name":"Uzbekistan","dial_code":"+998","code":"UZ"],["name":"Vanuatu","dial_code":"+678","code":"VU"],["name":"Wallis and Futuna","dial_code":"+681","code":"WF"],["name":"Yemen","dial_code":"+967","code":"YE"],["name":"Zambia","dial_code":"+260","code":"ZM"],["name":"Zimbabwe","dial_code":"+263","code":"ZW"],["name":"Aland Islands","dial_code":"+358","code":"AX"],["name":"Bolivia, Plurinational State of","dial_code":"+591","code":"BO"],["name":"Brunei Darussalam","dial_code":"+673","code":"BN"],["name":"Cocos (Keeling) Islands","dial_code":"+61","code":"CC"],["name":"Congo, The Democratic Republic of the","dial_code":"+243","code":"CD"],["name":"Cote d'Ivoire","dial_code":"+225","code":"CI"],["name":"Falkland Islands (Malvinas)","dial_code":"+500","code":"FK"],["name":"Guernsey","dial_code":"+44","code":"GG"],["name":"Holy See (Vatican City State)","dial_code":"+379","code":"VA"],["name":"Hong Kong","dial_code":"+852","code":"HK"],["name":"Iran, Islamic Republic of","dial_code":"+98","code":"IR"],["name":"Isle of Man","dial_code":"+44","code":"IM"],["name":"Jersey","dial_code":"+44","code":"JE"],["name":"Korea, Democratic People's Republic of","dial_code":"+850","code":"KP"],["name":"Korea, Republic of","dial_code":"+82","code":"KR"],["name":"Lao People's Democratic Republic","dial_code":"+856","code":"LA"],["name":"Libyan Arab Jamahiriya","dial_code":"+218","code":"LY"],["name":"Macao","dial_code":"+853","code":"MO"],["name":"Macedonia, The Former Yugoslav Republic of","dial_code":"+389","code":"MK"],["name":"Micronesia, Federated States of","dial_code":"+691","code":"FM"],["name":"Moldova, Republic of","dial_code":"+373","code":"MD"],["name":"Mozambique","dial_code":"+258","code":"MZ"],["name":"Palestinian Territory, Occupied","dial_code":"+970","code":"PS"],["name":"Pitcairn","dial_code":"+872","code":"PN"],["name":"Reunion","dial_code":"+262","code":"RE"],["name":"Russia","dial_code":"+7","code":"RU"],["name":"Saint Barthelemy","dial_code":"+590","code":"BL"],["name":"Saint Helena, Ascension and Tristan Da Cunha","dial_code":"+290","code":"SH"],["name":"Saint Kitts and Nevis","dial_code":"+1 869","code":"KN"],["name":"Saint Lucia","dial_code":"+1 758","code":"LC"],["name":"Saint Martin","dial_code":"+590","code":"MF"],["name":"Saint Pierre and Miquelon","dial_code":"+508","code":"PM"],["name":"Saint Vincent and the Grenadines","dial_code":"+1 784","code":"VC"],["name":"Sao Tome and Principe","dial_code":"+239","code":"ST"],["name":"Somalia","dial_code":"+252","code":"SO"],["name":"Svalbard and Jan Mayen","dial_code":"+47","code":"SJ"],["name":"Syrian Arab Republic","dial_code":"+963","code":"SY"],["name":"Taiwan, Province of China","dial_code":"+886","code":"TW"],["name":"Tanzania, United Republic of","dial_code":"+255","code":"TZ"],["name":"Timor-Leste","dial_code":"+670","code":"TL"],["name":"Venezuela, Bolivarian Republic of","dial_code":"+58","code":"VE"],["name":"Viet Nam","dial_code":"+84","code":"VN"],["name":"Virgin Islands, British","dial_code":"+1 284","code":"VG"],["name":"Virgin Islands, U.S.","dial_code":"+1 340","code":"VI"]]
        
        return arrayCountires
    }
    
    func convertSimpleTextToAttributedTextTextWithStrikeText(normalText:String, strikeText:String, textFont:UIFont, textColor:UIColor, currency:String, currencyTextFont:UIFont, currencyColor:UIColor) -> NSMutableAttributedString?{
        let attributeNormalText = NSAttributedString(string: normalText, attributes: [NSAttributedStringKey.font:textFont, NSAttributedStringKey.foregroundColor:textColor])
        let attributeCurrencyText = NSAttributedString(string: currency, attributes: [NSAttributedStringKey.font:currencyTextFont, NSAttributedStringKey.foregroundColor: currencyColor])

        // Strike text
        let attributeStrikeText = NSMutableAttributedString(string: strikeText, attributes: [NSAttributedStringKey.font:textFont, NSAttributedStringKey.foregroundColor:textColor, NSAttributedStringKey.strikethroughColor:currencyColor])
//        attributeStrikeText.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeStrikeText.length))
        
        let attributeStrikeCurrencyText = NSMutableAttributedString(string: currency, attributes: [NSAttributedStringKey.font:currencyTextFont, NSAttributedStringKey.foregroundColor:currencyColor])
//        attributeStrikeCurrencyText.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeStrikeCurrencyText.length))
        
        var attachmentStrikeString:NSMutableAttributedString = NSMutableAttributedString(attributedString: attributeStrikeText)
        attachmentStrikeString.append(NSMutableAttributedString(string: " "))
        attachmentStrikeString.append(attributeStrikeCurrencyText)
        attachmentStrikeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attachmentStrikeString.length))
        
        
//        let attributeStrikeText = NSAttributedString(string: "Your Text")
//        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
        
        var attachmentString:NSMutableAttributedString? = nil
        
        attachmentString = NSMutableAttributedString(attributedString: attributeNormalText)
        attachmentString!.append(NSMutableAttributedString(string: " "))
        attachmentString!.append(attributeCurrencyText)
        attachmentString!.append(NSMutableAttributedString(string: "  "))
//        attachmentString!.append(attributeStrikeText)
//        attachmentString!.append(NSMutableAttributedString(string: " "))
//        attachmentString!.append(attributeStrikeCurrencyText)
        attachmentString?.append(attachmentStrikeString)
        
        return attachmentString ?? nil
    }
    
    func convertSimpleTextToAttributedTextTextViewCartCell(normalText:String, textFont:UIFont, textColor:UIColor, currency:String, currencyTextFont:UIFont, currencyColor:UIColor) -> NSMutableAttributedString?{
        let attributeNormalText = NSAttributedString(string: normalText, attributes: [NSAttributedStringKey.font:textFont, NSAttributedStringKey.foregroundColor:textColor])
        let attributeCurrencyText = NSAttributedString(string: currency, attributes: [NSAttributedStringKey.font:currencyTextFont, NSAttributedStringKey.foregroundColor: currencyColor])
        
        var attachmentString:NSMutableAttributedString? = nil
        attachmentString = NSMutableAttributedString(attributedString: attributeNormalText)
        attachmentString!.append(NSMutableAttributedString(string: " "))
        attachmentString!.append(attributeCurrencyText)
        
        return attachmentString ?? nil
    }
}

extension BaseApp {
    
    //View Controller
    func openDashboardViewController(){
        BaseApp.appDelegate.setUpApplicationRootView()
    }
    
    func openLoginViewController(){
        ApplicationPreference.clearAllData()
        BaseApp.appDelegate.isAllowSkip = false
        BaseApp.appDelegate.setUpApplicationRootView()
    }
    
    func userLogout(){
        
      //  var logoutParam:APIRequestParam.Logout?
      //  BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
        
//        self.openLoginViewController()
        
        // TODO: Login API pending
//        let loginUserJsonString = ApplicationPreference.getLoginInfo()
//        let loginInfo = APIResponseParam.Login().getModelObjectFromServerResponse(jsonResponse: loginUserJsonString as AnyObject)
//        
//        if(loginInfo != nil){
//            
//            logoutParam = APIRequestParam.Logout(user_id: loginInfo?.loginData?.user_id!)
//            
//            let logout = LogoutRequest(logoutData: logoutParam!, onSuccess: {
//                response in
//                
//                print(response.toJSON())
//                
//                OperationQueue.main.addOperation() {
//                    // when done, update your UI and/or model on the main queue
//                    BaseApp.sharedInstance.hideProgressHudView()
//                    self.openLoginViewController()
//                }
//            }, onError: {
//                error in
//                print(error.toString())
//                
//                OperationQueue.main.addOperation() {
//                    // when done, update your UI and/or model on the main queue
//                    self.hideProgressHudView()
//                    self.showRestErrorNeutralDialog(title: "", error: error)
//                }
//            })
//            
//            BaseApp.sharedInstance.jobManager?.addOperation(logout)
//        }
    }
    
    func openTabScreenWithIndex(index:Int){
        BaseApp.appDelegate.openScreenWithTabIndex(index: index)
    }
}
