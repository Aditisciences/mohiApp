//
//  WishListVC.swift
//  Mohi
//
//  Created by Consagous on 19/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit

class WishListVC: BaseViewController {

    @IBOutlet weak var tablView: UITableView!
    fileprivate var productListViewController:ProductListVC?
    fileprivate var filterVC:FilterVC?
    
    var wishListData:[APIResponseParam.WishList.WishListData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablView.delegate = self
        tablView.dataSource = self
        tablView.register(UINib(nibName: "WishListCell", bundle: nil), forCellReuseIdentifier: "WishListCell")
        
        self.serverAPICallForGetWishList ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        productListViewController = nil
        filterVC = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension WishListVC{
    @IBAction func methodSearchAction(_ sender:Any){
        productListViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ProductVCStoryboard, viewControllerName: ProductListVC.nameOfClass) as! ProductListVC
        productListViewController?.isDisplaySearch = true
        self.view.addSubview((productListViewController?.view)!)
    }
    
    @IBAction func methodFilterAction(_ sender:Any){
        filterVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.FilterVCStoryboard, viewControllerName: FilterVC.nameOfClass)
        BaseApp.appDelegate.navigationController?.pushViewController(filterVC!, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
    }
}

extension WishListVC: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if wishListData ==  nil{
            return 0
        }
        return (wishListData?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishListCell", for: indexPath) as! WishListCell
                cell.cellIndex =  indexPath.row
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.delegate = self
        cell.lblForTag.text = wishListData![indexPath.row].category
        cell.lblForName.text = wishListData![indexPath.row].product_name
        cell.imgForDress.sd_setImage(with: URL(string: (wishListData?[indexPath.row].image!)!), for: .normal, completed: nil)
        
        let productPrice:Float = Float(wishListData![indexPath.row].product_price ?? "0.00")!
        if(productPrice > 0){
            cell.lblForPrice.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextTextViewCartCell(normalText: "\(String(format: "%.02f", productPrice))", textFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(14), textColor: UIColor(hexString: ColorCode.viewCartCellPriceColor) ?? UIColor.red, currency: AppConstant.CURRENCY_SYMBOL, currencyTextFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(11), currencyColor: UIColor(hexString: ColorCode.viewCartCellCurrencyColor) ?? UIColor.black)
        } else {
            cell.lblForPrice.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextTextViewCartCell(normalText: "0.00", textFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(14), textColor: UIColor(hexString: ColorCode.viewCartCellPriceColor) ?? UIColor.red, currency: AppConstant.CURRENCY_SYMBOL, currencyTextFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(11), currencyColor: UIColor(hexString: ColorCode.viewCartCellCurrencyColor) ?? UIColor.black)
        }
        let ratingValue : Double = Double(wishListData![indexPath.row].rating!)!
        cell.viewForRating.rating = ratingValue
        return cell
    }
}

extension WishListVC: WishListCellDelegate{
    func methodCancelProductFromWishList(cellIndex:Int){
        APIClient.sharedInstance.serverAPIRemoveToWishList(productId: wishListData![cellIndex].product_id!)
        wishListData?.remove(at: cellIndex)
        tablView.reloadData()
        
    }
    func methodProductAddToCart(cellIndex:Int){
        APIClient.sharedInstance.serverAPIAddToCart(productId: wishListData![cellIndex].product_id!)
    }
}

extension WishListVC{
    func serverAPICallForGetWishList(){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let wishListRequestParam = APIRequestParam.WishList.init(user_id:ApplicationPreference.getUserId(), token:ApplicationPreference.getAppToken(),width:"400",height:"400")
            
            let featuredProductRequest =  WishListRequest.init(wishListData: wishListRequestParam, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    self.wishListData = response.wishListData
                    BaseApp.sharedInstance.hideProgressHudView()
                    self.tablView.reloadData()
                   
                }
                
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: self)
                }
            })
            BaseApp.sharedInstance.jobManager?.addOperation(featuredProductRequest)
            
            //        // For tesating purpose
            //        ApplicationPreference.saveLoginInfo(loginInfo: "Test info")
            //        BaseApp.sharedInstance.openDashboardViewController()
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
}
