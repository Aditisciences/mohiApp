//
//  DashboardViewController.swift
//  Mohi
//
//  Created by Consagous on 18/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import ImageSlideshow
import SideMenu
//import SwiftEventBus

class DashboardViewController: BaseViewController{
    
    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightHorizontalSpaceConstraint:NSLayoutConstraint?
    
    fileprivate var productListViewController:ProductListVC?
    fileprivate var filterVC:FilterVC?
//    fileprivate var bannerImageList:[APIResponseParam.Banner.BannerData]?
    
//     var localSource = [ImageSource(imageString: "img1")!, ImageSource(imageString: "img2")!, ImageSource(imageString: "img3")!, ImageSource(imageString: "img4")!]
    
    var loadedVeiwCategory = FeaturedCell()
    var loadedVeiwProduct  = ProductCell()
    
    var menus : [HamburgerMenuItem] = []
    
    var homeScreenDetailList:[HomeScreenModel]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  setUpTabBar()
        
        loadedVeiwCategory =  UINib(nibName: "FeaturedCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FeaturedCell
        loadedVeiwProduct =  UINib(nibName: "ProductCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ProductCell
        
        //Set delegate for tableview
        tableView.delegate = self
        tableView.dataSource = self
        // tableView.register(UINib(nibName: "CategoryRow", bundle: nil), forCellReuseIdentifier: "CategoryRow")
        
        menus = BaseApp.sharedInstance.getHamburgerMenuList()
        //          NotificationCenter.default.addObserver(self, selector: #selector(DashboardViewController.pushViewAfterDelay), name: NSNotification.Name(rawValue: "MenuSelected"), object: nil)
        SwiftEventBus.onMainThread(self, name:"MenuSelected", handler: pushViewAfterDelay)
        
        SwiftEventBus.onMainThread(self, name:AppConstant.kRefreshScreenInfo,
                                   handler: handleRefreshScrInfo)
        
        ////////////////////////////////////////////////////////////////////////////////
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 3.0
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.appTheamRedColor()
        slideshow.pageControl.pageIndicatorTintColor = UIColor.appTheamWhiteColor()
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
            // print("current page:", page)
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
//        slideshow.setImageInputs(localSource)
        
        // TODO: uncomment when Ads url comming
//        var sdWebImageSource:[SDWebImageSource] = []
//        for tempImageUrl in localSource {
//            sdWebImageSource.append(SDWebImageSource(urlString: tempImageUrl)!)
//        }
//        slideshow.setImageInputs(sdWebImageSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        slideshow.addGestureRecognizer(recognizer)
        ////////////////////////////////////////////////////////////////////////////////
    }
    
    func backButtonAction(_ sender:UIBarButtonItem){
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (BaseApp.sharedInstance.isNetworkConnected){
            refreshScrInfo()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.findHamburguerViewController()?.menuDirection = .left
        if(productListViewController != nil && (productListViewController?.isDisplaySearch)!){
            productListViewController?.view.removeFromSuperview()
        }
        
        productListViewController = nil
        filterVC = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if(self.tableView.contentSize.height > 0){
            self.tableViewHeightHorizontalSpaceConstraint?.constant = self.tableView.contentSize.height
        }
    }
}

// MARK:- Tap gesture detect on slideshow
extension DashboardViewController{
    func didTap() {
        //print("SlideShow current page: \(slideshow.currentPage)")
    }
}

//MARK:- fileprivate method implementation
extension DashboardViewController{
    fileprivate func refreshScrInfo(){
        //serverHomeScreenDetail()
        serverBanner()
    }
}

// MARK:- Action method implementation
extension DashboardViewController{
    @IBAction func methodSearchAction(_ sender:Any){
        productListViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ProductVCStoryboard, viewControllerName: ProductListVC.nameOfClass) as! ProductListVC
        productListViewController?.isDisplaySearch = true
        self.view.addSubview((productListViewController?.view)!)
    }
    
    @IBAction func methodFilterAction(_ sender:Any){
        filterVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.FilterVCStoryboard, viewControllerName: FilterVC.nameOfClass)
        BaseApp.appDelegate.navigationController?.pushViewController(filterVC!, animated: true)
    }
    
    @IBAction func methodHamburgerAction(_ sender: AnyObject) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
}

//MARK:- Notiofication method implementation
extension DashboardViewController {
    
    func handleRefreshScrInfo(notification: Notification!) -> Void{
        refreshScrInfo()
    }
    
    //func pushViewAfterDelay(notification : NSNotification){
    func pushViewAfterDelay(notification: Notification!) -> Void{
        
        dismiss(animated: true, completion: nil)
        
        print(notification)
        
        let temp = notification.object as! String
        
        let intTag = Int(temp)!
        
        var controller = UIViewController()
        
        switch intTag {
        case 0:
            dismiss(animated: true, completion: nil)
            break
        case 1:
            controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ShopByCategoryStoryboard, viewControllerName: ShopByCategoryVC.nameOfClass)
            //           HHTabBarView.shared.referenceUITabBarController.navigationController?.pushViewController(controller, animated: true)
            BaseApp.appDelegate.navigationController?.pushViewController(controller, animated: true)
            break
        case 2:
            controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.DealOfTheDayStoryboard, viewControllerName: DealOfTheDayVC.nameOfClass)
            BaseApp.appDelegate.navigationController?.pushViewController(controller, animated: true)
            break
        case 3:
            controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.YourOrdersStoryboard, viewControllerName: YourOrdersVC.nameOfClass)
            BaseApp.appDelegate.navigationController?.pushViewController(controller, animated: true)
            break
        case 4:
            controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.WishListStoryboard, viewControllerName: WishListVC.nameOfClass)
            BaseApp.appDelegate.navigationController?.pushViewController(controller, animated: true)
            break
        default:
            break
        }
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0) {
            return 165
        } else {
            return 235
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeScreenDetailList != nil ? (homeScreenDetailList?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryRow") as! CategoryRow
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.registerCustomCells()
        //cell.collectionViewMain.tag =  indexPath.row
        cell.rowIndex = indexPath.row
        cell.delegate = self
        cell.labelRow.text = homeScreenDetailList![indexPath.row].title
        cell.is_product = homeScreenDetailList![indexPath.row].isProduct!
        cell.productList = homeScreenDetailList![indexPath.row].productList
        if(indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.init(red: 253.0/255.0, green: 246.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        }
        
        cell.updateCellInfo()
        return cell
    }
}

// MARK:- CatgeoryRowDelegate method implementation
extension DashboardViewController: CategoryRowDelegate {
    func methodSeeCategoriesProduct(cellIndex:Int, rowIndex:Int){
        let productInfo = homeScreenDetailList![rowIndex].productList![cellIndex]
        let storyBoard = UIStoryboard(name: AppConstant.ProductVCStoryboard, bundle: nil)
        productListViewController = storyBoard.instantiateViewController(withIdentifier: ProductListVC.nameOfClass) as! ProductListVC
        //viewController.cat_id =  self.categoriesList?[cellIndex].cat_id
        productListViewController?.cat_id = productInfo.product_id ?? ""
        productListViewController?.screenTitle = productInfo.product_name ?? ""
        BaseApp.appDelegate.navigationController?.pushViewController(productListViewController!, animated: true)
    }
    
    func addToCart(cellIndex:Int, rowIndex:Int){
        let productInfo = homeScreenDetailList![rowIndex].productList![cellIndex]
        APIClient.sharedInstance.serverAPIAddToCart(productId: productInfo.product_id!)
    }
    
    func addToWishList(cellIndex:Int, rowIndex:Int){
        let productInfo = homeScreenDetailList![rowIndex].productList![cellIndex]
        APIClient.sharedInstance.serverAPIAddToWishList(productId: productInfo.product_id!, onSuccess: {response in
            OperationQueue.main.addOperation() {
                self.refreshScrInfo()
            }
        })
    }
    
    func methodShowProductDetails(cellIndex:Int, rowIndex:Int){
        let productInfo = homeScreenDetailList![rowIndex].productList![cellIndex]
        let controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ProductDetailsVCStoryboard, viewControllerName: ProductDetailsVC.nameOfClass) as! ProductDetailsVC
        controller.product_id = productInfo.product_id
        controller.product_name = productInfo.product_name
        BaseApp.appDelegate.navigationController?.pushViewController(controller, animated: true)
    }
    
    func removeFromWishList(cellIndex:Int, rowIndex:Int){
        let productInfo = homeScreenDetailList![rowIndex].productList![cellIndex]
        APIClient.sharedInstance.serverAPIRemoveToWishList(productId: productInfo.product_id!, onSuccess: {response in
            OperationQueue.main.addOperation() {
                self.refreshScrInfo()
            }
        })
    }
    
    func methodSeeAll(rowIndex: Int) {
//        var controller = UIViewController()
        
        if rowIndex == 0{
            let controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ShopByCategoryStoryboard, viewControllerName: ShopByCategoryVC.nameOfClass)
            BaseApp.appDelegate.navigationController?.pushViewController(controller, animated: true)
        } else {
            let catInfo = homeScreenDetailList![rowIndex]
            let controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ProductVCStoryboard, viewControllerName: ProductListVC.nameOfClass) as! ProductListVC
            controller.type = catInfo.type ?? ""
            controller.screenTitle = catInfo.title ?? ""
            BaseApp.appDelegate.navigationController?.pushViewController(controller, animated: true)
        }
    }
}


// MARK:- Server API calling
extension DashboardViewController{
    func serverHomeScreenDetail(){
        if (BaseApp.sharedInstance.isNetworkConnected){
//            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            let homeScreenDetail = APIRequestParam.HomeScreenDetail(user_id: ApplicationPreference.getUserId()!, token: ApplicationPreference.getAppToken(), width: String(describing: loadedVeiwCategory.frame.size.width * UIScreen.main.scale), height: String(describing: loadedVeiwCategory.frame.size.height * UIScreen.main.scale))
            
            let homeScreenDetailRequest = GetHomeScreenDetailsRequest(homeScreenDetail: homeScreenDetail, onSuccess:{ response in
                
                print(response.toJSON())
                OperationQueue.main.addOperation() {
                    self.homeScreenDetailList = response.homeScreenForScreen
                    BaseApp.sharedInstance.hideProgressHudView()
                    self.tableView.reloadData()
                    self.view.setNeedsUpdateConstraints()
                }
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: self)
                }
            })
            BaseApp.sharedInstance.jobManager?.addOperation(homeScreenDetailRequest)
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
    
    func serverBanner(){
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            let bannerRequestParam = APIRequestParam.Banner(height: "\(loadedVeiwCategory.frame.size.height * UIScreen.main.scale)", width: "\(loadedVeiwCategory.frame.size.width * UIScreen.main.scale)")
            
            let bannerRequest = BannerRequest(bannerRequestData: bannerRequestParam, onSuccess:{ response in
                
                print(response.toJSON())
                OperationQueue.main.addOperation() {
                    let bannerList = response.bannerData?.imageList
                    
                    // prepare banner screen with image object
                    
                    
                    if bannerList != nil {
                        //self.localSource = bannerList!
                        
                        // TODO: uncomment when Ads url comming
                        var sdWebImageSource:[SDWebImageSource] = []
                        for tempImageUrl in bannerList! {
                            sdWebImageSource.append(SDWebImageSource(urlString: tempImageUrl)!)
                        }
                        self.slideshow.setImageInputs(sdWebImageSource)
                    }
                    
                    self.serverHomeScreenDetail()
                }
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: self)
                    
                    self.serverHomeScreenDetail()
                }
            });
            BaseApp.sharedInstance.jobManager?.addOperation(bannerRequest)
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
}


