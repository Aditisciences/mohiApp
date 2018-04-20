//
//  TabBarViewController.swift
//  Mohi
//
//  Created by Sandeep Kumar  on 30/03/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeTabBarClass()
    }
    
    //MARK: - Initalize class -
    private func initializeTabBarClass() {
        self.setUpViewControllers()
        self.setupTabBarView()
        self.updateViewCartCount()
    }
    
    private func setUpViewControllers() {

        let dashboardVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.DashboardStoryboard, viewControllerName: SlideHomeViewController.nameOfClass) as SlideHomeViewController

//        let dashboardVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.DashboardStoryboard, viewControllerName: DashboardViewController.nameOfClass) as DashboardViewController
        let dashboardNavigation: UINavigationController = UINavigationController(rootViewController: dashboardVC)
        dashboardNavigation.isNavigationBarHidden = true
        
        let dealsVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.DealOfTheDayStoryboard, viewControllerName: DealOfTheDayVC.nameOfClass) as DealOfTheDayVC
        let dealsNavigation: UINavigationController = UINavigationController(rootViewController: dealsVC)
        dealsNavigation.isNavigationBarHidden = true

        let cartVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.CartStoryboard, viewControllerName: CartVC.nameOfClass) as CartVC
        let cartNavigation: UINavigationController = UINavigationController(rootViewController: cartVC)
        cartNavigation.isNavigationBarHidden = true
        
        let moreVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.MoreStoryboard, viewControllerName: MoreVC.nameOfClass) as MoreVC
        let moreNavigation: UINavigationController = UINavigationController(rootViewController: moreVC)
        moreNavigation.isNavigationBarHidden = true
        
        let storyBoard = UIStoryboard(name: "MyAccount", bundle: nil)
        let accountVC = storyBoard.instantiateViewController(withIdentifier: "SlideProfileVC") as! SlideProfileVC
        let accountNavigation: UINavigationController = UINavigationController(rootViewController: accountVC)
        accountNavigation.isNavigationBarHidden = true

        self.setViewControllers([dashboardNavigation, dealsNavigation, cartNavigation, moreNavigation, accountNavigation], animated: false)
    }
    
    func setupTabBarView() {
        
        //Default & Selected Background Color
        let defaultTabColor = UIColor.white
        self.tabBar.barTintColor = UIColor.cyan
        self.tabBar.tintColor = UIColor.init(red: 76.0/255.0, green: 223.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        self.tabBar.backgroundColor = defaultTabColor
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()

        //Create Custom Tabs
        self.tabBar.items?[0].selectedImage = UIImage(named: "home_active")
        self.tabBar.items?[0].image = UIImage(named: "home_inactive")

        self.tabBar.items?[1].selectedImage = UIImage(named: "deals-tag-inactive")
        self.tabBar.items?[1].image = UIImage(named: "deals-tag-active")
        
        self.tabBar.items?[4].selectedImage = UIImage(named: "profile_inactive")
        self.tabBar.items?[4].image = UIImage(named: "profile_active")
        
        self.tabBar.items?[3].selectedImage = UIImage(named: "cart_inactive")
        self.tabBar.items?[3].image = UIImage(named: "cart_active")
       
        self.tabBar.items?[2].selectedImage = UIImage(named: "more_inactive")
        self.tabBar.items?[2].image = UIImage(named: "more_active")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TabBarViewController {
    
    func updateViewCartCount() {
        
        APIClient.sharedInstance.serverAPIGetViewCartCount(onSuccess: {
            response in
            
            let viewCount = response.viewCartCountData?.total_product ?? "0"
            self.tabBar.items?[3].badgeValue = viewCount
            
        }, onError: {
            error in
        })
    }
}
