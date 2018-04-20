//
//  ProductListVC.swift
//  Mohi
//
//  Created by Consagous on 13/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit

class ProductListVC: BaseViewController {
 @IBOutlet weak var collectionViewMain: UICollectionView!
    @IBOutlet weak var labelScreenTitle: UILabel!
    
    @IBOutlet weak var navBarSearch:UIView!
    @IBOutlet weak var textFieldSearchInput:UITextField!
    @IBOutlet weak var navBarDefault:UIView!
    @IBOutlet weak var buttonSearch:UIButton!
    @IBOutlet weak var buttonFilter:UIButton!
    @IBOutlet weak var constraintSearchOptionViewWidth:NSLayoutConstraint!
    @IBOutlet weak var viewSortFilterOption:UIView!
    
    fileprivate var loadedVeiwProduct = ProductCell()
    var productDataList:[APIResponseParam.Product.ProductData]?
    var filterProductOption:APIRequestParam.FilterProduct?
    
    // for display search on same page
    var productListViewController:ProductListVC?
    fileprivate var filterVC:FilterVC?
    fileprivate var backButtonPressed = false
    fileprivate var actionSheetSortOption:UIAlertAction?
    fileprivate var isSortAscending:Bool?
    fileprivate var currentPageIndex = 1
    fileprivate var pageLimit = 10
    fileprivate var isDisplayLoader = true
    fileprivate let refreshView = KRPullLoadView()
    fileprivate let loadMoreView = KRPullLoadView()
    
    var type = ""
    var screenTitle = ""
    var cat_id = ""
    
    var isDisplaySearch = false
    var isDisplayFromFilter = false
    var isAllowFilter = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(screenTitle.length > 0){
            self.labelScreenTitle.text = screenTitle
        }
        loadedVeiwProduct =  UINib(nibName: "ProductCell", bundle: nil).instantiate(withOwner: nil,
                                                                                    options: nil)[0] as! ProductCell
        collectionViewMain.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        
        // Add refresh loader for pulling and refresh
        refreshView.delegate = self
        collectionViewMain.addPullLoadableView(refreshView, type: .refresh)
        loadMoreView.delegate = self
        collectionViewMain.addPullLoadableView(loadMoreView, type: .loadMore)
        
        navBarSearch.isHidden = true
        viewSortFilterOption.isHidden = false
        // Do any additional setup after loading the view.
        if(isDisplaySearch){
            // Add keyboard Notification
            // check keyboard show
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
            
            // check keyboard hide
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
            
            navBarSearch.isHidden = false
            viewSortFilterOption.isHidden = true
            textFieldSearchInput.becomeFirstResponder()
        } else if isDisplayFromFilter{
            serverFilterOptionSearchList()
        } else {
            serverAPIGetAllProduct(searchText: "")
        }
        
        
        
        
        productListViewController = nil
        filterVC = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ProductListVC: KRPullLoadViewDelegate{
    
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .loadMore {
            switch state {
                case let .pulling(offset, threshould):
                    print("Pulling")
                break
            case let .loading(completionHandler):
//                }
                self.isDisplayLoader = false
                self.currentPageIndex += 1
                if(self.isDisplayFromFilter){
                    self.serverFilterOptionSearchList(completion: {
                        completionHandler()
                    })
                }
                else{
                    self.serverAPIGetAllProduct(searchText: self.textFieldSearchInput.text ?? "", completion: {
                        completionHandler()
                    })
                }
                break
            default: break
            }
            return
        }
        
        switch state {
        case .none:
            pullLoadView.messageLabel.text = ""
            
        case let .pulling(offset, threshould):
            if offset.y > threshould {
                pullLoadView.messageLabel.text = "Pull more. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
            } else {
               // pullLoadView.messageLabel.text = "Release to refresh. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
               // self.currentPageIndex = 1
            }
            self.isDisplayLoader = false
            
            break
            
        case let .loading(completionHandler):
            pullLoadView.messageLabel.text = "Updating..."
            if(self.isDisplayFromFilter){
                self.serverFilterOptionSearchList(completion: {
                    completionHandler()
                })
            } else {
                self.serverAPIGetAllProduct(searchText: self.textFieldSearchInput.text ?? "", completion: {
                    completionHandler()
                })
            }
            break
        }
    }
}

// MARK:- Fileprivate method implementation
extension ProductListVC{
    
    //TODO: Remove if not in user
    // local list sorting
    fileprivate func sortProductList(isAscOrder:Bool){
        if(productDataList != nil && (productDataList?.count)! > 0){
            var tempProductInfo = productDataList
            if(isAscOrder){
                tempProductInfo = tempProductInfo?.sorted{(object1, object2) -> Bool in
                    if object1.product_price?.localizedCompare(object2.product_price!) == ComparisonResult.orderedAscending{
                        return true
                    } else{
                        return false
                    }
                }
            } else {
                tempProductInfo = tempProductInfo?.sorted{(object1, object2) -> Bool in
                    if object1.product_price?.localizedCompare(object2.product_price!) == ComparisonResult.orderedAscending{
                        return true
                    } else{
                        return false
                    }
                }
            }
//            print(tempProductInfo?.toJSON())
            // replace previous info with sorted data
            productDataList = tempProductInfo
        }
    }
}

// MARK:- Action method implementation
extension ProductListVC{
    @IBAction func backButtonAction(_ sender:Any){
        backButtonPressed = true
        if(isDisplaySearch){
            //self.removeFromParentViewController()
            self.view.removeFromSuperview()
        } else if isDisplayFromFilter {
            //_ = navigationController?.popToRootViewController(animated: true)
            //BaseApp.sharedInstance.openTabScreenWithIndex(index: 0)
            _ = navigationController?.popViewController(animated: true)
        } else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func methodOpenSearchAction(_ sender:Any){
        productListViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ProductVCStoryboard, viewControllerName: ProductListVC.nameOfClass) as! ProductListVC
        productListViewController?.isDisplaySearch = true
        self.view.addSubview((productListViewController?.view)!)
    }
    
    @IBAction func methodSearchAction(_ sender:Any){
        navBarSearch.isHidden = false
        viewSortFilterOption.isHidden = true
        textFieldSearchInput.becomeFirstResponder()
    }
    
    @IBAction func methodFilterAction(_ sender:Any){
        var isFound = false
        
//        if(BaseApp.appDelegate.navigationController?.viewControllers != nil){
//            for controller in (BaseApp.appDelegate.navigationController?.viewControllers)! {
//                if (controller.nameOfClass.compare((FilterVC.nameOfClass)) == ComparisonResult.orderedSame ){
//
//                    // Similarly, to dismiss a menu programmatically, you would do this:
//                    dismiss(animated: true, completion: nil)
//                    if(controller.nameOfClass.compare(DashboardViewController.nameOfClass) == ComparisonResult.orderedSame){
//                        BaseApp.appDelegate.navigationController?.popToRootViewController(animated: true)
//                    } else {
//                        BaseApp.appDelegate.navigationController?.popToViewController(controller, animated: true)
//                    }
//                    isFound = true
//                    break
//                }
//            }
//        }
//
//        if(!isFound) {
            filterVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.FilterVCStoryboard, viewControllerName: FilterVC.nameOfClass)
            filterVC?.selected_Cat_Id = cat_id
            BaseApp.appDelegate.navigationController?.pushViewController(filterVC!, animated: true)
//        }
    }
    
    @IBAction func sortButtonAction(_ sender:Any){
        
        if(actionSheetSortOption == nil){
            //Create the AlertController and add Its action like button in Actionsheet
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Sort By", message: nil, preferredStyle: .actionSheet)
            
            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                print("Cancel")
            }
            actionSheetControllerIOS8.addAction(cancelActionButton)
            
            let lowToHighActionButton = UIAlertAction(title: "Price: Low to High", style: .default)
            { _ in
                print("Price: Low to High")
                self.isSortAscending = true
                if(self.isDisplayFromFilter){
                    self.serverFilterOptionSearchList()
                } else {
                    self.serverAPIGetAllProduct(searchText: self.textFieldSearchInput.text ?? "")
                }
            }
            actionSheetControllerIOS8.addAction(lowToHighActionButton)
            
            let highToLowActionButton = UIAlertAction(title: "Price: High to Low", style: .default)
            { _ in
                print("Price: Hight to Low")
                self.isSortAscending = false
                if(self.isDisplayFromFilter){
                    self.serverFilterOptionSearchList()
                } else {
                    self.serverAPIGetAllProduct(searchText: self.textFieldSearchInput.text ?? "")
                }
            }
            actionSheetControllerIOS8.addAction(highToLowActionButton)
            self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        }
    }
}

// MARK:- keyboard notification
extension ProductListVC{
    func keyboardWillShow(sender: NSNotification) {
        buttonSearch.isHidden = true
        constraintSearchOptionViewWidth.constant = AppConstant.WidthWithoutButton
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if backButtonPressed {
            backButtonPressed = false
            return
        }
        buttonSearch.isHidden = false
        viewSortFilterOption.isHidden = false
        navBarSearch.isHidden = true
        self.labelScreenTitle.text = textFieldSearchInput.text
        serverAPIGetAllProduct(searchText: textFieldSearchInput.text!)
    }
}

extension ProductListVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //serverAPIGetAllProduct(searchText: textField.text!)
        return true
    }
}

extension ProductListVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDataList != nil ? (productDataList?.count)! : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let   cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.delegate = self
        cell.cellIndex = indexPath.row
        cell.btnForProductImage.sd_setBackgroundImage(with: URL(string: (productDataList?[indexPath.row].image!)!), for: .normal, completed: nil)
        cell.lblForName.text =  (productDataList?[indexPath.row].product_name!)!
        //cell.lblForPrice.text =  (productDataList?[indexPath.row].product_price!)!
        let productPrice:Float = Float(productDataList?[indexPath.row].product_price ?? "0.00")!
        if(productPrice > 0){
            cell.lblForPrice.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextTextViewCartCell(normalText: "\(String(format: "%.02f", productPrice))", textFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(12), textColor: UIColor(hexString: ColorCode.viewCartCellPriceColor) ?? UIColor.red, currency: AppConstant.CURRENCY_SYMBOL, currencyTextFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(9), currencyColor: UIColor(hexString: ColorCode.viewCartCellCurrencyColor) ?? UIColor.black)
        } else {
            cell.lblForPrice.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextTextViewCartCell(normalText: "0.00", textFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(12), textColor: UIColor(hexString: ColorCode.viewCartCellPriceColor) ?? UIColor.red, currency: AppConstant.CURRENCY_SYMBOL, currencyTextFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(9), currencyColor: UIColor(hexString: ColorCode.viewCartCellCurrencyColor) ?? UIColor.black)
        }
        
        
        if productDataList?[indexPath.row].is_wishlist == "0" {
            cell.btnForAddToFav.isSelected = true
        }else{
            cell.btnForAddToFav.isSelected = false
        }
        
        if productDataList?[indexPath.row].is_add_to_cart == "1" {
            cell.btnForAddToCart.isSelected = true
        }else{
            cell.btnForAddToCart.isSelected = false
        }
        return cell
    }
}

extension ProductListVC : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        //        let ssnString = ((arrForData.object(at: indexPath.row) as AnyObject).value(forKey: "ssn") as? String)!
        //        let notificationName = Notification.Name("CELLSELCTED")
        //        // Post notification
        //        NotificationCenter.default.post(name: notificationName, object: ssnString)
        
    }
}

extension ProductListVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return  CGSize(width:(self.view.frame.width/2 ) - 16 , height: collectionView.frame.height/3 + 100)
    }
}

extension ProductListVC: ProductCellDelegate{
    
    func addToCart(cellIndex:Int){
        APIClient.sharedInstance.serverAPIAddToCart(productId: (self.productDataList?[cellIndex])!.product_id!)
    }
    
    func addToWishList(cellIndex:Int){
        APIClient.sharedInstance.serverAPIAddToWishList(productId: (self.productDataList?[cellIndex])!.product_id!, onSuccess: {response in
            OperationQueue.main.addOperation() {
                //self.refreshScrInfo()
                self.serverAPIGetAllProduct(searchText: self.textFieldSearchInput.text ?? "")
            }
        })
    }
    
    func methodShowProductDetails(cellIndex:Int){
        let controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ProductDetailsVCStoryboard, viewControllerName: ProductDetailsVC.nameOfClass) as! ProductDetailsVC
        controller.product_id =  self.productDataList?[cellIndex].product_id
        controller.product_name =  self.productDataList?[cellIndex].product_name
        BaseApp.appDelegate.navigationController?.pushViewController(controller, animated: true)
    }
    
    func removeFromWishList(cellIndex:Int){
        APIClient.sharedInstance.serverAPIRemoveToWishList(productId: (productDataList?[cellIndex])!.product_id!, onSuccess: {response in
            OperationQueue.main.addOperation() {
                //self.refreshScrInfo()
                self.serverAPIGetAllProduct(searchText: self.textFieldSearchInput.text ?? "")
            }
        })
    }
}

extension ProductListVC{
    func serverAPIGetAllProduct(searchText:String, completion:(()->Void)? = nil){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            if(isDisplayLoader){
                BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            }
            isDisplayLoader = true
            
            var sortOption:NSNumber? = nil
            if(isSortAscending != nil){
                sortOption = isSortAscending! == true ? NSNumber(integerLiteral: 1) : NSNumber(integerLiteral: 2)
            }
            
            print("self.currentPageIndex===>%@",self.currentPageIndex)
            
            let featuredProductRequestParam = APIRequestParam.Product(limit:"\(pageLimit)", page:"\(currentPageIndex)", cat_id: cat_id, token: ApplicationPreference.getAppToken(), user_id: ApplicationPreference.getUserId(),width:String(describing: loadedVeiwProduct.frame.size.width * UIScreen.main.scale),height:String(describing: loadedVeiwProduct.frame.size.height * UIScreen.main.scale), type:self.type, sort:sortOption, search:searchText)
            let featuredProductRequest =  ProductRequest.init(productData: featuredProductRequestParam, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    BaseApp.sharedInstance.hideProgressHudView()
                    if(self.currentPageIndex == 1){
                        self.productDataList = response.productData
                    } else {
                        for productInfo in response.productData! {
                            self.productDataList?.append(productInfo)
                        }
                        
                        if(response.productData != nil){
                           // self.currentPageIndex += 1
                        }
                    }
                    self.collectionViewMain.reloadData()
                    
                    if(completion != nil){
                        completion!()
                    }
                }
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    
                    if(self.productDataList != nil && self.productDataList?.count == 0){
                        BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: self)
                    }
                    if(completion != nil){
                        completion!()
                    }
                }
            }); BaseApp.sharedInstance.jobManager?.addOperation(featuredProductRequest)
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
            if(completion != nil){
                completion!()
            }
        }
    }
    
    func serverFilterOptionSearchList(completion:(()->Void)? = nil){
        if(filterProductOption != nil){
            
            if (BaseApp.sharedInstance.isNetworkConnected){
                
                if(isDisplayLoader){
                    BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
                }
                isDisplayLoader = true
                
                if(isSortAscending != nil){
                    filterProductOption?.sort = isSortAscending! == true ? NSNumber(integerLiteral: 1) : NSNumber(integerLiteral: 2)
                }
                
                filterProductOption?.page = NSNumber(integerLiteral: self.currentPageIndex)
                filterProductOption?.limit = NSNumber(integerLiteral: self.pageLimit)
                filterProductOption?.width = String(describing: loadedVeiwProduct.frame.size.width * UIScreen.main.scale)
                filterProductOption?.height = String(describing: loadedVeiwProduct.frame.size.height * UIScreen.main.scale)
                
                let getFilterListItemsRequest = FilterProductRequest(filterProductData: filterProductOption, onSuccess:{ response in
                    
                    print(response.toJSON())
                    OperationQueue.main.addOperation() {
                        
                        BaseApp.sharedInstance.hideProgressHudView()
                        if(self.currentPageIndex == 1){
                            self.productDataList = response.productData
                        } else {
                            for productInfo in response.productData! {
                                self.productDataList?.append(productInfo)
                            }
                        }
                        self.collectionViewMain.reloadData()
                        if(completion != nil){
                            completion!()
                        }
                    }
                }, onError: { error in
                    print(error.toString())
                    
                    OperationQueue.main.addOperation() {
                        // when done, update your UI and/or model on the main queue
                        BaseApp.sharedInstance.hideProgressHudView()
                        BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: self)
                        if(completion != nil){
                            completion!()
                        }
                    }
                })
                BaseApp.sharedInstance.jobManager?.addOperation(getFilterListItemsRequest)
                
            } else {
                BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
                if(completion != nil){
                    completion!()
                }
            }
        }
    }
}
