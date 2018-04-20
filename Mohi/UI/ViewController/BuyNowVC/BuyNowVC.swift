//
//  BuyNowVC.swift
//  Mohi
//
//  Created by Consagous on 29/11/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

class ProductData{
    var id:String?
    var name:String?
    var price:String?
    var quantity:String?
    var imageUrl:String?
}

class BuyNowVC: BaseViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var labelShippingAddress:UILabel!
    @IBOutlet weak var labelProductPriceQuantity:UILabel!
    @IBOutlet weak var labelPriceTotal:UILabel!
    @IBOutlet weak var labelDeliveryCharges:UILabel!
    @IBOutlet weak var labelPriceGrossTotal:UILabel!
    @IBOutlet weak var labelFullTotal:UILabel!
    @IBOutlet weak var constraintTableViewHeight:NSLayoutConstraint!
    
    fileprivate var selectedAddressData:APIResponseParam.ShippingAddress.ShippingAddressData?
    fileprivate var modifyAddressVC:ModifyAddressVC?
    fileprivate var addNewAddressVC:AddNewAddressVC?
    fileprivate var paymentVC:PaymentVC?
    fileprivate var deliveryCharges = 50
    fileprivate var pickerArray = AppConstant.quantityArray
    
    var quote_id = ""
    var productDataList:[APIResponseParam.ProductDetail.ProductDetailData]?
    var veiwCartProductDataList:[APIResponseParam.AddToCartList.AddToCartListData]?
    
    fileprivate var cartProductDataList:[ProductData] = []
    
    var tempQtyValue = ""
    var seletecCellQtyValue = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelDeliveryCharges.text = ""
        deliveryCharges = 0
        
        // TODO: Change when delivery charges coming from server
        var productDataInfo:ProductData?
        if(productDataList != nil){
            for productInfo in productDataList!{
                productDataInfo = ProductData()
                productDataInfo?.id = productInfo.product_id
                productDataInfo?.name = productInfo.product_name
                productDataInfo?.price = productInfo.product_price
                productDataInfo?.quantity = productInfo.qty
                productDataInfo?.imageUrl = productInfo.image
                cartProductDataList.append(productDataInfo!)
            }
        } else if (veiwCartProductDataList != nil){
            for productInfo in veiwCartProductDataList!{
                productDataInfo = ProductData()
                productDataInfo?.id = productInfo.product_id
                productDataInfo?.name = productInfo.product_name
                productDataInfo?.price = productInfo.product_price
                productDataInfo?.quantity = productInfo.qty.stringValue
                productDataInfo?.imageUrl = productInfo.image
                quote_id = productInfo.quote_id ?? ""
                cartProductDataList.append(productDataInfo!)
            }
        }
        
        calculateTotal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        modifyAddressVC = nil
        addNewAddressVC = nil
        paymentVC = nil
        prepareScrInfo()
        
        if(selectedAddressData != nil){
            serverAPIGetDeliveryCharges(quote_id: quote_id, address_id: (selectedAddressData?.address_id)!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if(self.tableView.contentSize.height > 0){
            self.constraintTableViewHeight?.constant = self.tableView.contentSize.height
        }
    }
}

//MARK:- Fileprivate method implementation
extension BuyNowVC{
    fileprivate func prepareScrInfo(){
        let selectedAddress = ApplicationPreference.getAddressInfo()
        if(selectedAddress != nil && selectedAddressData == nil){
            selectedAddressData = APIResponseParam.ShippingAddress.ShippingAddressData().getModelObjectFromServerResponse(jsonResponse: (selectedAddress as? AnyObject)!)
        }
        
        if(selectedAddressData != nil){
            labelShippingAddress.text = selectedAddressData?.fullAddressToString()
        } else {
            labelShippingAddress.text = ""
        }
        
        // Call devlivery charge api
        
    }
    
    fileprivate func calculateTotal(){
        var grossTotal:Float = 0.00
        var priceFloatValue:Float = 0.00
        var qty:Float = 1.00
        var productPrice = ""
        
        if cartProductDataList.count > 0 {
            for productInfo in cartProductDataList{
                productPrice = (productInfo.price ?? "0.00")
                qty = Float(productInfo.quantity ?? "1") ?? 1.00
                if(productPrice.length > 0){
                    priceFloatValue = Float(productPrice)!
                }
                
                grossTotal += (priceFloatValue*qty)
            }
        }
        print(grossTotal)
        
        labelPriceTotal.text = "\(String(format: "%.02f", grossTotal)) \(AppConstant.CURRENCY_SYMBOL)"
        labelDeliveryCharges.text = "\(deliveryCharges) \(AppConstant.CURRENCY_SYMBOL)"
        labelPriceGrossTotal.text = "\(String(format: "%.02f", grossTotal + Float(deliveryCharges))) \(AppConstant.CURRENCY_SYMBOL)"
        labelFullTotal.text = labelPriceGrossTotal.text
        labelProductPriceQuantity.text = getProductItemStr()
    }
    
    fileprivate func getProductItemStr() -> String{
        var priceItem = ""
        var qty = 0
        if cartProductDataList.count > 0 {
            for productInfo in cartProductDataList{
                let quantity:Int = Int(productInfo.quantity ?? "0") ?? 0
                qty += quantity
            }
        }
        
        if(qty == 1){
            priceItem = "Price (\(qty) item)"
        } else {
            priceItem = "Price (\(qty) items)"
        }
        
        return priceItem
    }
}

//MARK:- Action  method implementation
extension BuyNowVC{
    @IBAction func backButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeAddressButtonAction(_ sender:Any){
        
        if(ApplicationPreference.getAddressInfo() != nil){
            modifyAddressVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.MyAccountStoryboard, viewControllerName: ModifyAddressVC.nameOfClass)
            modifyAddressVC?.delegate = self
            modifyAddressVC?.isDisplayDeliverHereBtnHidden = false
            modifyAddressVC?.selectedAddressData = selectedAddressData
            self.navigationController?.pushViewController(modifyAddressVC!, animated: true)
        } else{
            addNewAddressVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.MyAccountStoryboard, viewControllerName: AddNewAddressVC.nameOfClass)
            self.navigationController?.pushViewController(addNewAddressVC!, animated: true)
        }
    }
    
    @IBAction func continueButtonAction(_ sender:Any){
        if(selectedAddressData != nil){
            paymentVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.BuyStoryboard, viewControllerName: PaymentVC.nameOfClass)
            
            // information for place order
            paymentVC?.quote_id = self.quote_id
            paymentVC?.cartProductDataList = self.cartProductDataList
            paymentVC?.selectedAddressData = self.selectedAddressData
            paymentVC?.productDeliveryCharges = self.deliveryCharges
            paymentVC?.totalPrice = self.labelPriceTotal.text!
            paymentVC?.grossTotalPrice = self.labelFullTotal.text!
            self.navigationController?.pushViewController(paymentVC!, animated: true)
        } else {
            //
            BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: BaseApp.sharedInstance.getMessageForCode("emptyAddress", fileName: "Strings")!, buttonTitle: nil, controller: nil)
        }
    }
}

extension BuyNowVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return cartProductDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BuyNowTableViewCell.nameOfClass, for: indexPath) as! BuyNowTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let productInfo = cartProductDataList[indexPath.row]
        cell.delegate = self
        cell.labelExpectedDeliveryCharges.isHidden = true
        cell.cellIndex = indexPath.row
        cell.labelProductName.text = productInfo.name ?? ""
        let productPrice:Float = Float(productInfo.price ?? "0.00")!
        cell.labelProductPrice.text = "\(String(format: "%.02f", productPrice)) \(AppConstant.CURRENCY_SYMBOL)"
        cell.txtForQty.text = productInfo.quantity ?? "1"
        //cell.imageView?.sd_setImage(with: URL(string: (productInfo.imageUrl!)))
        cell.imageViewProductThumnail.sd_setImage(with: URL(string: (productInfo.imageUrl!)))
        return cell
    }
}

extension BuyNowVC: ModifyAddressVCDelegate{
    func updateAddressInfo(address: APIResponseParam.ShippingAddress.ShippingAddressData?) {
        if(address != nil){
            selectedAddressData = address
        } else{
            selectedAddressData = nil
        }
        
        // update price info
        prepareScrInfo()
    }
}

extension BuyNowVC: BuyNowTableViewCellDelegate{
    func actionOnQty(cellIndex:Int, quantity:String){
//        let productInfo = cartProductDataList[cellIndex]
//        productInfo.quantity = quantity
//        cartProductDataList[cellIndex] = productInfo
//        calculateTotal()
        
        let productInfo = cartProductDataList[cellIndex]
        if(productInfo != nil){
            seletecCellQtyValue = cellIndex
            //productInfo?.qty = Int(quantity) as! NSNumber
            productInfo.quantity = quantity
            cartProductDataList[cellIndex] = productInfo
            
            calculateTotal()
            
            serverAPIUpdateCartQuantityCount(product_id: productInfo.id ?? "", qty: quantity, quote_id: self.quote_id)
        }
    }
    
    func quantityButtonAction(cellIndex: Int, quantity: String) {
        tempQtyValue = quantity
    }
}

extension BuyNowVC {
    func serverAPIUpdateCartQuantityCount(product_id:String, qty:String, quote_id:String){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let updateCartQtyRequestParam = APIRequestParam.UpdateCartQty(user_id: ApplicationPreference.getUserId(), token: ApplicationPreference.getAppToken(), product_id: product_id, qty: qty, quote_id: quote_id)
            
            let updateCartQtyRequest =  UpdateCartQtyRequest(updateCartQty: updateCartQtyRequestParam, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    BaseApp.sharedInstance.hideProgressHudView()
                    self.tableView.reloadData()
                    ((UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? TabBarViewController)?.updateViewCartCount()
                }
                
            }, onError: { error in
                print(error.toString())
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: self)
                    let productInfo = self.cartProductDataList[self.seletecCellQtyValue]
                    if(productInfo != nil){
                        
                        //productInfo?.qty = Int(quantity) as! NSNumber
                        productInfo.quantity = self.tempQtyValue
                        self.cartProductDataList[self.seletecCellQtyValue] = productInfo
                        
                        self.calculateTotal()
                        self.tableView.reloadData()
                        
                    }
                    
                }
            }); BaseApp.sharedInstance.jobManager?.addOperation(updateCartQtyRequest)
            
            DispatchQueue.main.async {
                
            }
            
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
    
    func serverAPIGetDeliveryCharges(quote_id:String, address_id:String){
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let getShippingPriceParam = APIRequestParam.GetShippingPrice(user_id: ApplicationPreference.getUserId(), token: ApplicationPreference.getAppToken(), address_id: address_id, quote_id: quote_id)
            
            let updateCartQtyRequest =  GetShippingPriceRequest(getShippingPriceData: getShippingPriceParam, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    BaseApp.sharedInstance.hideProgressHudView()
                    
                    if(response.getShippingPriceData != nil){
                        self.labelDeliveryCharges.text = response.getShippingPriceData?.amount
                        self.deliveryCharges = Int(response.getShippingPriceData?.amount ?? "0")!
                    } else {
                        self.labelDeliveryCharges.text = ""
                        self.deliveryCharges = 0
                    }
                    
                    self.calculateTotal()
                }
                
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: self)
                }
            }); BaseApp.sharedInstance.jobManager?.addOperation(updateCartQtyRequest)
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
}
