//
//  SlideHomeViewController.swift
//  Mohi
//
//  Created by Sandeep Kumar  on 04/04/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import UIKit
import SideMenu

class SlideHomeViewController: GLViewPagerViewController, GLViewPagerViewControllerDataSource, GLViewPagerViewControllerDelegate {
    
    //MARK: - IBOutlet -
    @IBOutlet weak var navigationView: UIView!
    
    //MARK: - Variables -
    var viewControllers: NSArray = NSArray()
    var tabTitles: NSArray = NSArray()
    
    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        self.initializeHomeSlideView()
        self.configureScrollableHeaderView()
        
        HomeManager.shared.fetchAllHomeData { [weak self] (status) in
            self?.initializeHomeSlideView()
            self?.configureScrollableHeaderView()
            
        }
    }
    
    //MARK: - Initalize class -
    private func initializeHomeSlideView() {
        
        let buttonToggle: UIButton = UIButton(type: UIButtonType.custom)
        buttonToggle.setImage(UIImage(named: "toggle-menu"), for: UIControlState.normal)
        buttonToggle.addTarget(self, action: #selector(self.methodHamburgerAction(_:)), for: UIControlEvents.touchUpInside)
        buttonToggle.frame = CGRect(x: 0.0, y: 20.0, width: 44.0, height: 44.0)
        self.view.addSubview(buttonToggle)
        
        var titleLabelRect: CGRect = CGRect.zero
        titleLabelRect.origin = CGPoint(x: (AppConstant.ScreenSize.SCREEN_WIDTH/2) - 100, y: 22.0)
        titleLabelRect.size = CGSize(width: 200, height: 40)
        
        let titleLabel: UILabel = UILabel()
        titleLabel.frame = titleLabelRect
        titleLabel.text = "SIMPLY"
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 20.0)
        self.view.addSubview(titleLabel)
        
        let buttonFilter: UIButton = UIButton(type: UIButtonType.custom)
        buttonFilter.setImage(UIImage(named: "filter"), for: UIControlState.normal)
        buttonFilter.addTarget(self, action: #selector(self.methodFilterAction(_:)), for: UIControlEvents.touchUpInside)
        buttonFilter.frame = CGRect(x: AppConstant.ScreenSize.SCREEN_WIDTH - 44.0, y: 20.0, width: 44.0, height: 44.0)
        self.view.addSubview(buttonFilter)
        
        self.view.bringSubview(toFront: self.tabContentView)
        self.view.bringSubview(toFront: self.pageViewController.view)
    }
    
    private func configureScrollableHeaderView() {
        
        //Add page scroller delegate
        self.setDataSource(newDataSource: self)
        self.setDelegate(newDelegate: self)
        
        //Add page scroller padding
        self.leadingPadding = 10
        self.trailingPadding = 10
        self.padding = 10
        self.defaultDisplayPageIndex = 0
        
        //Customize scroll view
        self.tabAnimationType = GLTabAnimationType.GLTabAnimationType_WhileScrolling
        self.supportArabic = false
        self.fixIndicatorWidth = true
        self.indicatorWidth = 20.0
        self.indicatorColor = UIColor.cyan
        
        self.tabContentView.frame = CGRect(x: 0, y: 64, width: AppConstant.ScreenSize.SCREEN_WIDTH, height: 45)
        
        self.addProfilePageControllers()
    }
    
    private func addProfilePageControllers() {
        
        let names: [String] = HomeManager.shared.homeCategories.map({ $0.name ?? "" })
        
        var viewControllers: [UIViewController] = [UIViewController]()
        
        for i in 0...(names.count - 1) {
            
            if i == 0 {
                
                let homeController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.DashboardStoryboard, viewControllerName: HomeViewController.nameOfClass) as HomeViewController
                viewControllers.append(homeController)
                
            }else {

                let controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ProductVCStoryboard, viewControllerName: ProductListVC.nameOfClass) as! ProductListVC
                controller.cat_id = "\(HomeManager.shared.homeCategories[i].catId ?? "0")"
                controller.screenTitle = "\(HomeManager.shared.homeCategories[i].name ?? "")"
                
//                let dashboardVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.DashboardStoryboard, viewControllerName: DashboardViewController.nameOfClass) as DashboardViewController
                viewControllers.append(controller)
            }
            
        }
        
        self.viewControllers = NSArray(array: viewControllers)
        self.tabTitles = NSArray(array: names)
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
    
    //MARK: - IBActions -
    @IBAction func methodFilterAction(_ sender:Any){
        //        filterVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.FilterVCStoryboard, viewControllerName: FilterVC.nameOfClass)
        //        BaseApp.appDelegate.navigationController?.pushViewController(filterVC!, animated: true)
    }
    
    @IBAction func methodHamburgerAction(_ sender: AnyObject) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SlideHomeViewController {
    
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
}
