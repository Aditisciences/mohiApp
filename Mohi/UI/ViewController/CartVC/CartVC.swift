//
//  CartVC.swift
//  Mohi
//
//  Created by Consagous on 28/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import SideMenu

class CartVC: BaseViewController {

    @IBOutlet weak var tablView: UITableView!
    @IBOutlet weak var totalAmount: UILabel!
    
    var productDataList:[APIResponseParam.AddToCartList.AddToCartListData]?
    
    fileprivate var buyNowVC:BuyNowVC?
    fileprivate var loginViewController:LoginViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablView.register(UINib(nibName: CartCell.nameOfClass, bundle: nil), forCellReuseIdentifier: CartCell.nameOfClass)
        // Do any additional setup after loading the view.
        calculateTotal()
        
        SwiftEventBus.onMainThread(self, name:AppConstant.kRefreshViewCart,
                                   handler: handleRefreshScrInfo)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginViewController = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        serverAPIGetAddToCartList()
    }
}

// MARK:- Handle notification
extension CartVC{
    func handleRefreshScrInfo(notification: Notification!) -> Void{
        serverAPIGetAddToCartList(isDisplayNotification: false)
        ((UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? TabBarViewController)?.updateViewCartCount()
    }
}

//MARK:- Action method implementation
extension CartVC{
    @IBAction func methodHamburgerAction(_ sender: AnyObject) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func actionONCheckOut(_ sender: Any) {
        
        if(!BaseApp.sharedInstance.isUserAlreadyLoggedInToApplication()){
            if(loginViewController == nil){
                loginViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.onBoardStoryboard, viewControllerName: LoginViewController.nameOfClass)
                BaseApp.sharedInstance.loginCallingScr = LoginCallingScr.Cart
                self.navigationController?.pushViewController(loginViewController!, animated: true)
            }
        } else {
            //TODO: Implement check out process
            if(self.productDataList != nil){
                self.buyNowVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.BuyStoryboard, viewControllerName: BuyNowVC.nameOfClass)
                
                self.buyNowVC?.veiwCartProductDataList = self.productDataList
                self.navigationController?.pushViewController(self.buyNowVC!, animated: true)
            }
        }
    }
}

//MARK:- Fileprivate method implementation
extension CartVC{
    fileprivate func calculateTotal(){
        var grossTotal:Float = 0.00
        var priceFloatValue:Float = 0.00
        var qty:Float = 1.00
        var productPrice = ""
        
        if productDataList != nil {
            for productInfo in productDataList!{
                productPrice = (productInfo.product_price ?? "0.00")
                //qty = Float(productInfo.qty.fl) ?? 1.00
                qty = productInfo.qty.floatValue
                if(productPrice.length > 0){
                    priceFloatValue = Float(productPrice)!
                }
                
                grossTotal += (priceFloatValue*qty)
            }
        }
         print(grossTotal)
        
        totalAmount.text = ""
        if(grossTotal > 0){
            totalAmount.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextTextViewCartCell(normalText: "\(String(format: "%.02f", grossTotal))", textFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(24), textColor: UIColor(hexString: ColorCode.viewCartCellPriceColor) ?? UIColor.red, currency: AppConstant.CURRENCY_SYMBOL, currencyTextFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(10), currencyColor: UIColor(hexString: ColorCode.viewCartCellCurrencyColor) ?? UIColor.black)
        } else {
            totalAmount.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextTextViewCartCell(normalText: "0.00", textFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(24), textColor: UIColor(hexString: ColorCode.viewCartCellPriceColor) ?? UIColor.red, currency: AppConstant.CURRENCY_SYMBOL, currencyTextFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(10), currencyColor: UIColor(hexString: ColorCode.viewCartCellCurrencyColor) ?? UIColor.black)
        }
    }
}

extension CartVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 128.0
    }
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDataList != nil ? (productDataList?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.nameOfClass, for: indexPath) as! CartCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.delegate =  self
        cell.cellIndex = indexPath.row
        cell.btnForImage.sd_setImage(with: URL(string: (productDataList?[indexPath.row].image!)!), for: .normal, completed: nil)
        cell.lblForProductName.text =  (productDataList?[indexPath.row].product_name!)!
        cell.lblForCateName.text =  (productDataList?[indexPath.row].category!)!
        cell.lblForPrice.text = ""
        cell.txtForQty.text = (productDataList?[indexPath.row].qty.stringValue)!
        
        let productPrice = (productDataList?[indexPath.row].product_price ?? "0.00")
        var newPriceFloatValue:Float = 0.00
        if(productPrice.length > 0){
            newPriceFloatValue = Float(productPrice)!
        }
        
        cell.lblForPrice.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextTextViewCartCell(normalText: "\(String(format: "%.02f", newPriceFloatValue))", textFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(14), textColor: UIColor(hexString: ColorCode.viewCartCellPriceColor) ?? UIColor.red, currency: AppConstant.CURRENCY_SYMBOL, currencyTextFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(11), currencyColor: UIColor(hexString: ColorCode.viewCartCellCurrencyColor) ?? UIColor.black)
        
        if productDataList?[indexPath.row].is_wishlist == "1" {
            cell.btnWishList.isSelected = true
            cell.btnWishList.setTitle(BaseApp.sharedInstance.getMessageForCode("removeToWishList", fileName: "Strings"), for: UIControlState.normal)
        }else{
            cell.btnWishList.isSelected = false
            cell.btnWishList.setTitle(BaseApp.sharedInstance.getMessageForCode("addToWishList", fileName: "Strings"), for: UIControlState.normal)
        }
        
          return cell
    }
}

//MARK_; CartCellDelegate method implementation
extension CartVC: CartCellDelegate{
    
    func removeFromAddToCart(cellIndex:Int){
        APIClient.sharedInstance.serverAPIRemoveToAddToCart(productId: (productDataList?[cellIndex].product_id!)!,quoteId: (productDataList?[cellIndex].quote_id!)!, onSuccess: { response in
            //let newIndexPath = IndexPath.init(row: cellIndex, section: 0)
            //self.tablView.deleteRows(at: [newIndexPath], with: .right)
            self.productDataList?.remove(at: cellIndex)
            
            if(self.productDataList?.count == 0){
                self.productDataList = nil
                self.calculateTotal()
            }
            
            self.tablView.reloadData()
            
            
        }, onError: {
            error in
        })
    }
    
    func moveToWishList(cellIndex:Int){
        if productDataList?[cellIndex].is_wishlist == "1" {
            APIClient.sharedInstance.serverAPIRemoveToWishList(productId: (productDataList?[cellIndex].product_id!)!, onSuccess: { response in
                print(response.toJSON())
                OperationQueue.main.addOperation() {
                    self.serverAPIGetAddToCartList()
                }
            }, onError: { error in
                print(error.toString())
                OperationQueue.main.addOperation() {
                    
                }
            })
        } else {
            APIClient.sharedInstance.serverAPIAddToWishList(productId: (productDataList?[cellIndex].product_id!)!, onSuccess:{ response in
                print(response.toJSON())
                OperationQueue.main.addOperation() {
                    self.serverAPIGetAddToCartList()
                }
            }, onError: { error in
                print(error.toString())
                OperationQueue.main.addOperation() {
                    
                }
            });
        }
    }
    
    func actionOnQty(cellIndex:Int, quantity:String){
        let productInfo = productDataList?[cellIndex]
        if(productInfo != nil){
            //productInfo?.qty = Int(quantity) as! NSNumber
            productInfo?.qty = NSNumber(integerLiteral: Int(quantity) ?? 0)
            productDataList![cellIndex] = productInfo!
            
            calculateTotal()
            
            serverAPIUpdateCartQuantityCount(product_id: productInfo?.product_id ?? "", qty: quantity, quote_id: productInfo?.quote_id ?? "")
        }
    }
}

//MARK:- Server API
extension CartVC {
    
    func serverAPIGetAddToCartList(isDisplayNotification:Bool = true){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let featuredProductRequestParam = APIRequestParam.AddToCartList.init(user_id:ApplicationPreference.getUserId(), token:ApplicationPreference.getAppToken(),width:"400",height:"400")
            let featuredProductRequest =  AddToCartListRequest.init(wishListData: featuredProductRequestParam, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    self.productDataList = response.productData
                    BaseApp.sharedInstance.hideProgressHudView()
                    self.calculateTotal()
                    self.tablView.reloadData()
                }
                
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    if(isDisplayNotification){
                        BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: self)
                    }
                    
                    self.productDataList = nil
                    self.calculateTotal()
                    self.tablView.reloadData()
                }
            })
            BaseApp.sharedInstance.jobManager?.addOperation(featuredProductRequest)
         
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
    
    func serverAPIUpdateCartQuantityCount(product_id:String, qty:String, quote_id:String){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let updateCartQtyRequestParam = APIRequestParam.UpdateCartQty(user_id: ApplicationPreference.getUserId(), token: ApplicationPreference.getAppToken(), product_id: product_id, qty: qty, quote_id: quote_id)
            
            let updateCartQtyRequest =  UpdateCartQtyRequest(updateCartQty: updateCartQtyRequestParam, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    BaseApp.sharedInstance.hideProgressHudView()
                    self.tablView.reloadData()
                    ((UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? TabBarViewController)?.updateViewCartCount()
                }
                
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: self)
                }
                //Resolved issue of Out of Stock.
                self.serverAPIGetAddToCartList()

            }); BaseApp.sharedInstance.jobManager?.addOperation(updateCartQtyRequest)
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
}
