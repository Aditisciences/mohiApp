//
//  DealOfTheDayVC.swift
//  Mohi
//
//  Created by Consagous on 19/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import SideMenu

class DealOfTheDayVC: BaseViewController {

    //@IBOutlet weak var collectionViewMain: UICollectionView!
    @IBOutlet weak var tablView: UITableView!
    
    var productDataList:[APIResponseParam.Deals.DealsData]?
    var cat_id: String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionViewMain.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        tablView.register(UINib(nibName: CartCell.nameOfClass, bundle: nil), forCellReuseIdentifier: CartCell.nameOfClass)
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.productDataList != nil{
            self.productDataList?.removeAll()
        }
        
        serverAPIGetAllProduct()
    }
    
    func backButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Action method implementation
extension DealOfTheDayVC{
    @IBAction func methodHamburgerAction(_ sender: AnyObject) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
}

extension DealOfTheDayVC: UITableViewDataSource,UITableViewDelegate {
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
        let   cell = tableView.dequeueReusableCell(withIdentifier: CartCell.nameOfClass, for: indexPath) as! CartCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.delegate =  self
        cell.cellIndex = indexPath.row
        cell.btnForImage.sd_setImage(with: URL(string: (productDataList?[indexPath.row].image!)!), for: .normal, completed: nil)
        cell.lblForProductName.text =  (productDataList?[indexPath.row].product_name!)!
        cell.lblForCateName.isHidden = true
        cell.viewQty.isHidden = true
        
        let productPriceNew = (productDataList?[indexPath.row].new_price ?? "0.00")
        let productPriceOld = (productDataList?[indexPath.row].product_price ?? "0.00")
        cell.lblForPrice.text = ""
        
        var newPriceFloatValue:Float = 0.00
        var oldPriceFloatValue:Float = 0.00
        if(productPriceNew.length > 0){
            newPriceFloatValue = Float(productPriceNew)!
        }
        
        if(productPriceOld.length > 0){
            oldPriceFloatValue = Float(productPriceOld)!
        }
        
        cell.lblForPrice.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextTextWithStrikeText(normalText: "\(String(format: "%.02f", newPriceFloatValue))", strikeText: "\(String(format: "%.02f", oldPriceFloatValue))", textFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(14), textColor: UIColor(hexString: ColorCode.viewCartCellPriceColor) ?? UIColor.red, currency: AppConstant.CURRENCY_SYMBOL, currencyTextFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(11), currencyColor: UIColor(hexString: ColorCode.viewCartCellCurrencyColor) ?? UIColor.black)
        
        if productDataList?[indexPath.row].is_wishlist == "1" {
            cell.btnWishList.isSelected = true
            cell.btnWishList.setTitle(BaseApp.sharedInstance.getMessageForCode("removeToWishList", fileName: "Strings"), for: UIControlState.normal)
        }else{
            cell.btnWishList.isSelected = false
            cell.btnWishList.setTitle(BaseApp.sharedInstance.getMessageForCode("addToWishList", fileName: "Strings"), for: UIControlState.normal)
        }
        
        cell.updateRemoveWishListToAddCart()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ProductDetailsVCStoryboard, viewControllerName: ProductDetailsVC.nameOfClass) as! ProductDetailsVC
        controller.product_id =  self.productDataList?[indexPath.row].product_id
        controller.product_name =  self.productDataList?[indexPath.row].product_name
        BaseApp.appDelegate.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK_; CartCellDelegate method implementation
extension DealOfTheDayVC: CartCellDelegate{
    
    func removeFromAddToCart(cellIndex:Int){ // Working as add to cart
        APIClient.sharedInstance.serverAPIAddToCart(productId: (productDataList?[cellIndex].product_id ?? ""))
    }
    
    func moveToWishList(cellIndex:Int){
//        APIClient.sharedInstance.serverAPIAddToWishList(productId: (productDataList?[cellIndex].product_id!)!)
        if productDataList?[cellIndex].is_wishlist == "1" {
            APIClient.sharedInstance.serverAPIRemoveToWishList(productId: (productDataList?[cellIndex].product_id!)!, onSuccess: { response in
                print(response.toJSON())
                OperationQueue.main.addOperation() {
                    self.serverAPIGetAllProduct()
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
                    self.serverAPIGetAllProduct()
                }
            }, onError: { error in
                print(error.toString())
                OperationQueue.main.addOperation() {
                    
                }
            });
        }
    }
    
    func actionOnQty(cellIndex:Int, quantity:String){
        // Do nothing in Deal of the day
    }
    
}

extension DealOfTheDayVC{
    
    func serverAPIGetAllProduct(){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            //let featuredProductRequestParam = APIRequestParam.Deals(width:"400",height:"400")
            let featuredProductRequestParam = APIRequestParam.Deals(user_id:ApplicationPreference.getUserId(), token:ApplicationPreference.getAppToken(),width:"400", height:"400")
            let featuredProductRequest =  DealsRequest.init(productData: featuredProductRequestParam, onSuccess: { response in
                print(response.toJSON())
                OperationQueue.main.addOperation() {
                    self.productDataList = response.productData
                    BaseApp.sharedInstance.hideProgressHudView()
                    //self.collectionViewMain.reloadData()
                    self.tablView.reloadData()
                }
                
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: self)
                    self.productDataList = nil
                    self.tablView.reloadData()
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
