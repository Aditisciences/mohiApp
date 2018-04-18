//
//  AppDelegate.swift
//  Mohi
//
//  Created by Consagous on 18/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isAllowSkip = false
    var navigationController:UINavigationController?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         IQKeyboardManager.sharedManager().enable = true
        _ = BaseApp.sharedInstance
        
        // TODO: Implementation not discuss
        // Push notification registration
//        self.registerDeviceToReceivePushNotification(application)
        self.moveToOnboardingController()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
         BaseApp.sharedInstance.stopMonitoring()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
         BaseApp.sharedInstance.startMonitoring()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

// FCM & Push Notification implementation
extension AppDelegate{
    //MARK:- Push notification delegate iOS9 and less
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let chars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var token = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", arguments: [chars[i]])
        }
        AppConstant.kLogString(deviceToken)
//        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.unknown)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        AppConstant.kLogString(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AppConstant.kLogString(userInfo)
    }
    
    func fbmTokenReceivedNotificationHandler(_ notification: Notification) {
//        if let refreshedToken = FIRInstanceID.instanceID().token() {
//            print("InstanceID token: \(refreshedToken)")
//            FCMInstanceIdService.onTokenRefresh(token: refreshedToken)
//        }
        // Connect to FCM since connection may have failed when attempted before having a token.
       
    }
    
    
    func registerDeviceToReceivePushNotification(_ application:UIApplication){
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {(granted, error) in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
//        NotificationCenter.default.addObserver(self,selector: #selector(self.fbmTokenReceivedNotificationHandler),name: .firInstanceIDTokenRefresh,object: nil)
    }
}

//MARK:- Push notification delegate iOS10
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        AppConstant.kLogString(userInfo)
    }
    
    @available(iOS 10, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        AppConstant.kLogString(response.notification.request.content.userInfo)
        if(response.notification.request.content.categoryIdentifier.caseInsensitiveCompare(AppConstant.LOCAL_NOTIFICATION_IDENTIFIER) == ComparisonResult.orderedSame){
            //BaseApp.sharedInstance.openMessageLineWithUserInfo(userInfo: response.notification.request.content.userInfo)
            // TODO: Add Code
        }
    }
}

//MARK:- Applicaiton initial setup
extension AppDelegate{
    
    func setupCustomTabBar() {
        let tabbBarController: TabBarViewController = TabBarViewController()
        self.window?.rootViewController = tabbBarController
        self.window?.makeKeyAndVisible()
    }
    
    func setUpApplicationRootView() {
//        if(BaseApp.sharedInstance.isUserAlreadyLoggedInToApplication() == true) || (BaseApp.appDelegate.isAllowSkip == true){
          //  let storyBoard = UIStoryboard(name: AppConstant.DashboardStoryboard, bundle: nil)
          //  let viewController = storyBoard.instantiateViewController(withIdentifier: HomeVC.nameOfClass)
        
        let tabbBarController: TabBarViewController = TabBarViewController()

            self.navigationController  = UINavigationController(rootViewController: tabbBarController)
            
            BaseApp.sharedInstance.setupSideMenu(navigationViewController: self.navigationController!)
            
            self.window?.rootViewController = self.navigationController
            self.navigationController?.isNavigationBarHidden = true
            self.window?.makeKeyAndVisible()
//        }else{
//            let storyBoard = UIStoryboard(name: AppConstant.onBoardStoryboard, bundle: nil)
//            let viewController = storyBoard.instantiateViewController(withIdentifier: LoginViewController.nameOfClass)
//            self.navigationController  = UINavigationController(rootViewController: viewController)
//            self.navigationController?.isNavigationBarHidden = true
//            self.window?.rootViewController = self.navigationController
//            self.window?.makeKeyAndVisible()
//        }
        
    }
    
    func openScreenWithTabIndex(index:Int){
        
        let tabController: TabBarViewController? = self.window?.rootViewController as? TabBarViewController
        tabController?.selectedIndex = index
        
        if index == TabIndex.Home.rawValue {
            let navController: UINavigationController? = tabController?.viewControllers?[index]as? UINavigationController
            navController?.popToRootViewController(animated: true)
        }
    }
    
    func moveToOnboardingController() {
        let tutorial: TutorialViewController = TutorialViewController.instanceObject()
        self.window?.rootViewController = tutorial
        self.window?.makeKeyAndVisible()
    }
}
