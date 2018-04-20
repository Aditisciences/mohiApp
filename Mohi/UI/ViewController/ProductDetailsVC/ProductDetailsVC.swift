//
//  ProductDetailsVC.swift
//  Mohi
//
//  Created by Consagous on 16/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import Cosmos
//import ZoomableImageSlider

class ProductDetailsVC: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgThumb1: UIButton!
    @IBOutlet weak var imgThumb2: UIButton!
    @IBOutlet weak var imgThumb3: UIButton!
    @IBOutlet weak var imgThumb4: UIButton!
    @IBOutlet weak var imageViewPreview: UIImageView!
    @IBOutlet weak var btnForWishList: UIButton!
    @IBOutlet weak var lblForName: UILabel!
    @IBOutlet weak var lblForPrice: UILabel!
    @IBOutlet weak var lblForAvailable: UILabel!
    @IBOutlet weak var viewForRating: CosmosView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var constraintWebViewHeight:NSLayoutConstraint!
    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var constraintCollectionViewHeight:NSLayoutConstraint!
    @IBOutlet weak var constraintSeparatorTop:NSLayoutConstraint!
    @IBOutlet weak var constraintDeliveryOptionTop:NSLayoutConstraint!
    @IBOutlet weak var constraintDeliveryOptionBottom:NSLayoutConstraint!
    @IBOutlet weak var collectionViewProductSuggestion: UICollectionView!
    @IBOutlet weak var imageLocation:UIImageView?
    @IBOutlet weak var imageArrow:UIImageView?
    
//    @IBOutlet weak var buttonDeliveryOption: UIButton!
    @IBOutlet weak var labelDeliveryOptionEmptyAddress: UILabel!
    @IBOutlet weak var labelDeliveryOptionNoAddressDisplay: UILabel!
    @IBOutlet weak var labelDeliveryOptionChangeAddress: UILabel!
    @IBOutlet weak var labelDeliveryOptionAddress: UILabel!
    @IBOutlet weak var labelSeparator: UILabel!
    @IBOutlet weak var viewNoPinAddressView: UIView!
    @IBOutlet weak var viewPinNoAddressDisplayView: UIView!
    @IBOutlet weak var viewPinAddressDisplayView: UIView!
    
    var productData:APIResponseParam.ProductDetail.ProductDetailData?
    var mediaData:[APIResponseParam.ProductDetail.ProductMediaData]?
    
    var product_id:String? = ""
    var product_name:String? = ""
    
    var isViewAlreadyLoaded = false
    
    fileprivate var buyNowVC:BuyNowVC?
    fileprivate var loginViewController:LoginViewController?
    fileprivate var deliveryOptionAlertViewController:DeliveryOptionAlertViewController?
    fileprivate var lastSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelScreenTitle.text = product_name ?? ""
        scrollView.isHidden = true
        viewForRating.isUserInteractionEnabled = false
        self.labelDeliveryOptionChangeAddress.text = ""
        self.labelDeliveryOptionAddress.text = ""
        self.labelDeliveryOptionNoAddressDisplay.text = ""
        
        self.imageLocation?.image = imageLocation?.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.imageLocation?.tintColor = UIColor(hexString: ColorCode.primaryColor)
        
        self.imageArrow?.image = imageArrow?.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.imageArrow?.tintColor = UIColor(hexString: ColorCode.primaryColor)
        
        displayDeliveryOption()
        
        collectionViewProductSuggestion.register(UINib(nibName: ProductSuggestionCell.nameOfClass, bundle: nil), forCellWithReuseIdentifier: ProductSuggestionCell.nameOfClass)
        
        // load html page for product details
        let request = URLRequest(url: URL(string: "\(APIParamConstants.productDetailUrl)\(product_id ?? "")")!)
        webView.loadRequest(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buyNowVC = nil
        loginViewController = nil
        deliveryOptionAlertViewController = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(!isViewAlreadyLoaded){
            isViewAlreadyLoaded = true
            serverAPIGetAllProductDetails()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Action method implementation
extension ProductDetailsVC{
    @IBAction func backButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionONAddToWishList(_ sender: Any){
        if productData?.is_wishlist == "1" {
            APIClient.sharedInstance.serverAPIRemoveToWishList(productId: (productData?.product_id!)!,onSuccess:{
                response in
                
                OperationQueue.main.addOperation() {
                    self.serverAPIGetAllProductDetails()
                }
                
            }, onError:{
                error in
            } )
        }else{
            APIClient.sharedInstance.serverAPIAddToWishList(productId: (productData?.product_id!)!,onSuccess:{
                response in
                
                OperationQueue.main.addOperation() {
                    self.serverAPIGetAllProductDetails()
                }
                
            }, onError:{
                error in
            } )
        }
    }
    
    @IBAction func actionONSideImages(_ sender: UIButton){
        if(sender.tag < (productData?.productMediaData?.count)!){
            let mediaData = productData?.productMediaData
            let imageUrl = mediaData?[sender.tag].thumbnail!
            lastSelectedIndex = sender.tag
            
            imgThumb1.layer.borderWidth = 0.0
            imgThumb2.layer.borderWidth = 0.0
            imgThumb3.layer.borderWidth = 0.0
            imgThumb4.layer.borderWidth = 0.0
            
            sender.layer.borderWidth = 1.0
            
            imageViewPreview.sd_setImage(with: URL(string: imageUrl!))
        }
    }
    
    @IBAction  func actionFullImagePriview(_ sender: Any){
        previewScr()
    }
    
    @IBAction  func actionONSizeChart(_ sender: Any){
        
    }
    @IBAction func actionONAddToCart(_ sender: Any){
        APIClient.sharedInstance.serverAPIAddToCart(productId: (productData?.product_id)!)
    }
    @IBAction  func actionONBuyNow(_ sender: Any){
        
        if(!BaseApp.sharedInstance.isUserAlreadyLoggedInToApplication()){
            if(loginViewController == nil){
                loginViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.onBoardStoryboard, viewControllerName: LoginViewController.nameOfClass)
                BaseApp.sharedInstance.loginCallingScr = LoginCallingScr.ProductDetail
                self.navigationController?.pushViewController(loginViewController!, animated: true)
            }
        } else {
            APIClient.sharedInstance.serverAPIAddToCart(productId: (productData?.product_id)!, displayNotification: true, buyNowAction: true, onSuccess: {
                response in
                
                // TODO: parse quote_id
                self.buyNowVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.BuyStoryboard, viewControllerName: BuyNowVC.nameOfClass)
                
                if(response.addToCartData != nil){
                    self.buyNowVC?.quote_id = response.addToCartData?.quote_id ?? ""
                }
                //self.buyNowVC?.productInfo = self.productData
                self.productData?.qty = "1" // default quantity
                self.buyNowVC?.productDataList = [self.productData!]
                self.navigationController?.pushViewController(self.buyNowVC!, animated: true)
                
            }, onError: {
                error in
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                   // if(displayNotification){
                        BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: nil, controller: nil)
                   // }
                }
            })
        }
    }
    
    @IBAction func actionONWriteReview(_ sender: Any){
        let controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ProductDetailsVCStoryboard, viewControllerName: ReviewVC.nameOfClass) as! ReviewVC
        controller.productData = productData
        BaseApp.appDelegate.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction  func actionDeliveryOption(_ sender: UIButton){
        print("actionDeliveryOption")
        if(productData?.pincode != nil && !(sender.tag == 1 || sender.tag == 2)){
            //self.labelDeliveryOptionAddress.text = pro.checkServiceAvailabilityData?.pincodeAddress
            self.updateConstraintForDisplayDeliveryOptionInfo()
            self.viewNoPinAddressView.isHidden = true
            self.viewPinNoAddressDisplayView.isHidden = true
            self.viewPinAddressDisplayView.isHidden = false
            self.labelDeliveryOptionAddress.text = productData?.pincodeAddress ?? ""
        }else {
            if(deliveryOptionAlertViewController == nil){
                deliveryOptionAlertViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.CustomAlertStoryboard, viewControllerName: DeliveryOptionAlertViewController.nameOfClass)
                
                deliveryOptionAlertViewController?.delegate = self
                deliveryOptionAlertViewController?.view.frame = self.view.frame
                self.view.addSubview((deliveryOptionAlertViewController?.view)!)
            }
        }
    }
}

extension ProductDetailsVC: DeliveryOptionAlertViewControllerDelegate{
    func closeDeliveryOptionAlertViewControllerScr() {
        if(deliveryOptionAlertViewController != nil){
            deliveryOptionAlertViewController?.view.removeFromSuperview()
            deliveryOptionAlertViewController = nil
        }
    }
    
    func savePincodeInfo(pincode: String) {
        closeDeliveryOptionAlertViewControllerScr()
        
        // TODO: API call for pincode test
//        updateConstraintForDisplayDeliveryOptionInfo()
//        labelDeliveryOptionAddress.text = "Dispatched in 1 day"
        serverAPICheckServiceAvailability(pinCode: pincode)
    }
}

// MARK:- Fileprivate method implementation
extension ProductDetailsVC{
    fileprivate func prepareScrInfo(){
        if(productData != nil){
            mediaData = productData?.productMediaData
            
            imgThumb1.layer.borderWidth = 0.0
            imgThumb2.layer.borderWidth = 0.0
            imgThumb3.layer.borderWidth = 0.0
            imgThumb4.layer.borderWidth = 0.0
            
            if mediaData?.count != 0 {
                imageViewPreview.sd_setImage(with: URL(string: (mediaData?[0].base)!))
                
                
                for i in 0 ..< (mediaData?.count)! {
                    
                    switch i {
                    case 0:
                        imgThumb1.sd_setImage(with: URL(string: (mediaData?[0].thumbnail)!), for: .normal, completed: nil)
                        imgThumb1.layer.borderWidth = 1.0
                        break
                    case 1:
                        imgThumb2.sd_setImage(with: URL(string: (mediaData?[1].thumbnail)!), for: .normal, completed: nil)
                        break
                    case 2:
                        imgThumb3.sd_setImage(with: URL(string: (mediaData?[2].thumbnail)!), for: .normal, completed: nil)
                        break
                    case 3:
                        imgThumb4.sd_setImage(with: URL(string: (mediaData?[3].thumbnail)!), for: .normal, completed: nil)
                        break
                    default:
                        break
                    }
                }
            }
            
           
            if productData?.is_wishlist == "1" {
                btnForWishList.isSelected = true
            }else{
                btnForWishList.isSelected = false
            }
            
            lblForName.text = productData?.product_name
            let productPrice:Float = Float(productData?.product_price ?? "0.00")!
            if(productPrice > 0){
                lblForPrice.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextTextViewCartCell(normalText: "\(String(format: "%.02f", productPrice))", textFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(18), textColor: UIColor(hexString: ColorCode.viewCartCellPriceColor) ?? UIColor.red, currency: AppConstant.CURRENCY_SYMBOL, currencyTextFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(14), currencyColor: UIColor.black)
            } else {
                lblForPrice.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextTextViewCartCell(normalText: "0.00", textFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(18), textColor: UIColor(hexString: ColorCode.viewCartCellPriceColor) ?? UIColor.red, currency: AppConstant.CURRENCY_SYMBOL, currencyTextFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(14), currencyColor: UIColor.black)
            }
            
            let rating: Double = Double((productData?.rating)!)!
            viewForRating.rating =  rating
            
            // update pincode view
            self.viewNoPinAddressView.isHidden = true
            self.viewPinNoAddressDisplayView.isHidden = true
            self.viewPinAddressDisplayView.isHidden = true
            self.labelDeliveryOptionChangeAddress.text = ""
            self.labelDeliveryOptionAddress.text = ""
            self.labelDeliveryOptionNoAddressDisplay.text = ""
            if(productData?.pincode != nil){
                self.viewPinNoAddressDisplayView.isHidden = false
                self.labelDeliveryOptionChangeAddress.attributedText = updatePincodeString(pincode: (productData?.pincode!)!)
                self.labelDeliveryOptionNoAddressDisplay.attributedText =  self.labelDeliveryOptionChangeAddress.attributedText
            } else {
                viewNoPinAddressView.isHidden = false
            }
            
            collectionViewProductSuggestion.reloadData()
        }
    }
    
    fileprivate func previewScr(){
        //let images = ["http://www.kurzweilai.net/images/iPhone4-S.jpg", "https://s-media-cache-ak0.pinimg.com/originals/93/aa/25/93aa2535372bb8d37ed42864ad55d904.jpg", "http://images.efulfilment.de/get_image/?t=29A598C0F35F861AECC5DF972434840B", "http://images.all-free-download.com/images/graphicthumb/monitor_the_cameras_02_hd_picture_168726.jpg"]
        
        var images:[String] = []
        var urlString:String?
        if(productData != nil){
            mediaData = productData?.productMediaData
            // image array list
            for mediaDataItem in mediaData!{
                urlString = mediaDataItem.base
                
                if(urlString != nil){
                    images.append(urlString ?? "")
                }
            }
            
            if(images.count > 0){
                let vc = ZoomableImageSlider(images: images, currentIndex: nil, placeHolderImage: nil)
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func updateConstraintForDisplayDeliveryOptionInfo(){
        labelSeparator.isHidden = false
        constraintDeliveryOptionTop.constant = 10
        constraintDeliveryOptionBottom.constant = 10
    }
    
    fileprivate func updatePincodeString(pincode:String) -> NSAttributedString{
        let baseString = BaseApp.sharedInstance.getMessageForCode("pinCodePlaceHolder", fileName: "Strings")
        let attributedString = BaseApp.sharedInstance.convertSimpleTextToAttributedTextHiddenHeader(baseString!, pincode)
        
        return attributedString ?? NSAttributedString(string: "")
    }
}

//MARK:- UIWebViewDelegate method implementation
extension ProductDetailsVC {
    func webViewDidFinishLoad(_ webView: UIWebView) {
//        BaseApp.sharedInstance.hideProgressHudView()
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
        constraintWebViewHeight.constant = webView.frame.size.height
//        self.scrollView.isHidden = false
    }
}


extension ProductDetailsVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(productData != nil){
            return productData?.related_products != nil ? (productData?.related_products?.count)! : 0
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productInfo = productData?.related_products?[indexPath.row]
        
        // Default product cell
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductSuggestionCell.nameOfClass, for: indexPath) as! ProductSuggestionCell
        cell.delegate =  self
        cell.cellIndex = indexPath.row
        
        if(productInfo?.image != nil){
            //cell.btnForProductImage.sd_setImage(with: URL(string: (productInfo?.image!)!), for: .normal, completed: nil)
            cell.imageViewProductImage.sd_setImage(with: URL(string: (productInfo?.image!)!))
        }
        
        cell.lblForName.text =  productInfo?.product_name ?? ""
        
        let productPrice:Float = Float(productInfo?.product_price ?? "0.00")!
        if(productPrice > 0){
            cell.lblForPrice.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextTextViewCartCell(normalText: "\(String(format: "%.02f", productPrice))", textFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(12), textColor: UIColor(hexString: ColorCode.viewCartCellPriceColor) ?? UIColor.red, currency: AppConstant.CURRENCY_SYMBOL, currencyTextFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(9), currencyColor: UIColor(hexString: ColorCode.viewCartCellCurrencyColor) ?? UIColor.black)
        } else {
            cell.lblForPrice.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextTextViewCartCell(normalText: "0.00", textFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(12), textColor: UIColor(hexString: ColorCode.viewCartCellPriceColor) ?? UIColor.red, currency: AppConstant.CURRENCY_SYMBOL, currencyTextFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(9), currencyColor: UIColor(hexString: ColorCode.viewCartCellCurrencyColor) ?? UIColor.black)
        }
        
//        if(productInfo?.is_wishlist?.caseInsensitiveCompare("0") == ComparisonResult.orderedSame) {
//            cell.btnForAddToFav.isSelected = true
//        }else{
//            cell.btnForAddToFav.isSelected = false
//        }
//        
//        if(productInfo?.is_add_to_cart?.caseInsensitiveCompare("0") == ComparisonResult.orderedSame) {
//            cell.btnForAddToCart.isSelected = true
//        }else{
//            cell.btnForAddToCart.isSelected = false
//        }
        return cell
    }
}

extension ProductDetailsVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        //        let ssnString = ((arrForData.object(at: indexPath.row) as AnyObject).value(forKey: "ssn") as? String)!
        //        let notificationName = Notification.Name("CELLSELCTED")
        //        // Post notification
        //        NotificationCenter.default.post(name: notificationName, object: ssnString)
        
    }
}

extension ProductDetailsVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        //if collectionViewMain.tag == 0{
//        if(self.rowIndex == 0) {
//            return CGSize(width:100 , height: 100)
//        }
        return  CGSize(width:140 , height: collectionView.frame.height)
    }
}

//MARK:- ProductCellDelegate method implementation
extension ProductDetailsVC: ProductSuggestionCellDelegate {
    func methodShowProductDetails(cellIndex:Int){
//        if(delegate != nil){
//            delegate?.methodShowProductDetails(cellIndex: cellIndex, rowIndex: self.rowIndex)
//        }
        
        // Load product Detail screen
        let controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ProductDetailsVCStoryboard, viewControllerName: ProductDetailsVC.nameOfClass) as! ProductDetailsVC
        controller.product_id =  productData?.related_products?[cellIndex].product_id
        controller.product_name =  productData?.related_products?[cellIndex].product_name
        BaseApp.appDelegate.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK:- Delivery Option
extension ProductDetailsVC{
    func displayDeliveryOption(){
        labelDeliveryOptionAddress.text = ""
        viewNoPinAddressView.isHidden = false
        viewPinNoAddressDisplayView.isHidden = true
        viewPinAddressDisplayView.isHidden = true
        
//        constraintSeparatorTop.constant = 0
        constraintDeliveryOptionTop.constant = 0
        constraintDeliveryOptionBottom.constant = 0
        
        //labelDeliveryOptionAddress.text = "Dispatched in 1 day"
    }
}

// MARK:- Server API Calling
extension ProductDetailsVC{
    
    func serverAPIGetAllProductDetails(){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let featuredProductRequestParam = APIRequestParam.ProductDetail(product_id:product_id,user_id: ApplicationPreference.getUserId()!, token: ApplicationPreference.getAppToken(),width:"\(imageViewPreview.frame.size.width * UIScreen.main.scale)",height:"\(imageViewPreview.frame.size.height*UIScreen.main.scale)")
            let featuredProductRequest =  ProductDetailRequest.init(productData: featuredProductRequestParam, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    BaseApp.sharedInstance.hideProgressHudView()
                    self.productData = response.productDetailData
                    BaseApp.sharedInstance.hideProgressHudView()
                    //                    self.tablView.reloadData()
                    self.scrollView.isHidden = false
                    self.prepareScrInfo()
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
    
    func serverAPICheckServiceAvailability(pinCode:String){
        //
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let checkServiceAvailabilityParam = APIRequestParam.CheckServiceAvailability(pincode: pinCode, user_id: ApplicationPreference.getUserId()!)
            
            let featuredProductRequest =  CheckServiceAvailabilityRequest(checkServiceAvailabilityData: checkServiceAvailabilityParam, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    BaseApp.sharedInstance.hideProgressHudView()
                    
                    self.updateConstraintForDisplayDeliveryOptionInfo()
                    self.viewNoPinAddressView.isHidden = true
                    self.viewPinNoAddressDisplayView.isHidden = true
                    self.viewPinAddressDisplayView.isHidden = false
//                    self.labelDeliveryOptionChangeAddress.text = response.checkServiceAvailabilityData?.pincode

                    self.labelDeliveryOptionChangeAddress.attributedText = self.updatePincodeString(pincode: (response.checkServiceAvailabilityData?.pincode!)!)
                    self.labelDeliveryOptionNoAddressDisplay.attributedText = self.labelDeliveryOptionChangeAddress.attributedText
                    self.labelDeliveryOptionAddress.text = response.checkServiceAvailabilityData?.pincodeAddress
                    
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
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
}

