//
//  HomeVC.swift
//  Mohi
//
//  Created by Consagous on 09/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import ImageSlideshow
import SideMenu
import CarbonKit

class HomeVC: BaseViewController,CarbonTabSwipeNavigationDelegate {

    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    @IBOutlet var targetView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*let items = [UIImage.init(named: ""), UIImage.init(named: ""), UIImage.init(named: ""), UIImage.init(named: ""), UIImage.init(named: "")]
         */
        
//        let items = ["Home", "Deals", "My Account", "Cart", "More"]
//        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
//        carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: targetView)
        //        carbonTabSwipeNavigation.pagesScrollView?.isScrollEnabled =  false
        //setUpStyle()
        
        // Do any additional setup after loading the view.
        
       //  BaseApp.appDelegate.setupCustomTabBar()
        
//        setUpTabBar()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.findHamburguerViewController()?.menuDirection = .left
        
    }

    func setUpStyle(){
        
              let width = targetView.frame.width/5
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
//        carbonTabSwipeNavigation.setIndicatorColor(ColorCode.appthemeColorGreenLight)
        //carbonTabSwipeNavigation.setTabExtraWidth(46.0)
                carbonTabSwipeNavigation.setTabBarHeight(46.0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(width, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(width, forSegmentAt: 1)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(width, forSegmentAt: 2)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(width, forSegmentAt: 3)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(width, forSegmentAt: 4)
        carbonTabSwipeNavigation.pagesScrollView?.isScrollEnabled = false
        carbonTabSwipeNavigation.setNormalColor(UIColor.white, font: UIFont.boldSystemFont(ofSize: 14))
        carbonTabSwipeNavigation.setSelectedColor(UIColor.orange
            , font:  UIFont.boldSystemFont(ofSize: 14))
        
    }

    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        // return viewController at index
        
        var controller = UIViewController()
        
        switch index {
        case 0:
            controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.DashboardStoryboard, viewControllerName: DashboardViewController.nameOfClass)
        case 1:
            controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.DealOfTheDayStoryboard, viewControllerName: DealOfTheDayVC.nameOfClass)
        case 2:
            controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.MyAccountStoryboard, viewControllerName: MyAccountVC.nameOfClass)
        case 3:
            controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.CartStoryboard, viewControllerName: CartVC.nameOfClass)
        case 4:
            controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.MoreStoryboard, viewControllerName: MoreVC.nameOfClass)
        default:
            break
        }
        
        return controller
    }
    
    
    func barPosition(for carbonTabSwipeNavigation: CarbonTabSwipeNavigation) -> UIBarPosition
    {
        return UIBarPosition.bottom
    }
    
}
// MARK:- Action method implementation
extension HomeVC{
    @IBAction func methodHamburgerAction(_ sender: AnyObject) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    // SMSegment selector for .ValueChanged
    
    
}
