//
//  PaymentVC.swift
//  Mohi
//
//  Created by Consagous on 29/11/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

class PaymentVC: BaseViewController {
    
    @IBOutlet weak var labelProductPriceQuantity:UILabel!
    @IBOutlet weak var labelPriceTotal:UILabel!
    @IBOutlet weak var labelDeliveryCharges:UILabel!
    @IBOutlet weak var labelPriceGrossTotal:UILabel!
    @IBOutlet weak var creditCardBtn:UIButton!
    @IBOutlet weak var codCardBtn:UIButton!
    @IBOutlet weak var textFieldCouponCode:UITextField!
    @IBOutlet weak var textFieldGiftCertificate:UITextField!

    //var productDataList:[APIResponseParam.ProductDetail.ProductDetailData]?
    var cartProductDataList:[ProductData] = []
    
    var productQuantity:String = ""
    var totalPrice:String = ""
    var grossTotalPrice:String = ""
    var productDeliveryCharges:Int = 0
    var quote_id = ""
    var selectedAddressData:APIResponseParam.ShippingAddress.ShippingAddressData?
    
    fileprivate var selectedPaymentMode:APIParamConstants.PaymentMode = APIParamConstants.PaymentMode.COD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codCardBtn.isSelected = true
        prepareScrInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
}

//MARK:- Fileprivate method implementation
extension PaymentVC{
    fileprivate func prepareScrInfo(){
        
        labelProductPriceQuantity.text = getProductItemStr()
        labelDeliveryCharges.text = "\(productDeliveryCharges) \(AppConstant.CURRENCY_SYMBOL)"
        labelPriceTotal.text = totalPrice
        labelPriceGrossTotal.text = grossTotalPrice
        
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
        labelDeliveryCharges.text = "\(productDeliveryCharges) \(AppConstant.CURRENCY_SYMBOL)"
        labelPriceGrossTotal.text = "\(String(format: "%.02f", grossTotal + Float(productDeliveryCharges))) \(AppConstant.CURRENCY_SYMBOL)"
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
extension PaymentVC{
    @IBAction func backButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyButtonAction(_ sender:Any){
        
    }
    
    @IBAction func continueButtonAction(_ sender:Any){
        if(selectedPaymentMode == APIParamConstants.PaymentMode.COD){
            serverPlaceOrderAPI()
        } else {
            BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: BaseApp.sharedInstance.getMessageForCode("paymentModeError", fileName: "Strings")!, buttonTitle: nil, controller: nil)
            
            // PayUMoney implementation
//            let currentTimeStamp = String(Int(NSDate().timeIntervalSince1970*1000))
//            PayUServiceHelper.sharedManager().getPayment(self, "test@mailinator.com", "9977333408", "Test", "10", currentTimeStamp, didComplete: { (dict, error) in
//                if let error = error {
//                    print("Error")
//                    print(error)
//                }else {
//                    print("Sucess")
//                }
//
//            }, didFail: { (error) in
//                print("Payment Process Breaked")
//                print(error)
//            })
        }
    }
    
    @IBAction func paymentModeButtonAction(_ sender:Any){
        creditCardBtn.isSelected = false
        codCardBtn.isSelected = false
        
        switch sender as! UIButton {
        case creditCardBtn:
            creditCardBtn.isSelected = true
            selectedPaymentMode = APIParamConstants.PaymentMode.CREDIT
            break
        case codCardBtn:
            codCardBtn.isSelected = true
            selectedPaymentMode = APIParamConstants.PaymentMode.COD
            break
        default:
            break
        }
    }
}

extension PaymentVC{
    func serverPlaceOrderAPI(){

        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")

            let loginInfo = ApplicationPreference.getLoginInfo()
            let loginInfoModel = APIResponseParam.Login.LoginData().getModelObjectFromServerResponse(jsonResponse: loginInfo!)
            //let itemData = APIRequestParam.PlaceOrder.ItemsData(product_id: (productInfo?.product_id)!, qty: productQuantity)
            var purchaseItemDataList:[APIRequestParam.PlaceOrder.ItemsData] = []
            
            if cartProductDataList.count > 0 {
                for productInfo in cartProductDataList{
                    purchaseItemDataList.append(APIRequestParam.PlaceOrder.ItemsData(product_id: (productInfo.id)!, qty: (productInfo.quantity)!))
                }
            }

            var paymentMethod = ""
            if selectedPaymentMode == APIParamConstants.PaymentMode.COD {
                paymentMethod = APIParamConstants.PaymentMethodName.checkmo.rawValue
            }

            let orderData = APIRequestParam.PlaceOrder.OrderData(currency_id: AppConstant.CURRENCY_SYMBOL, quote_id: quote_id, user_id: ApplicationPreference.getUserId()!, token: ApplicationPreference.getAppToken()!, address_id: selectedAddressData?.address_id ?? "", items: purchaseItemDataList, payment_method: paymentMethod)

            let placeOrder = APIRequestParam.PlaceOrder(order_data: orderData)
            let addShippingAddressRequest = PlaceOrderRequest(productData: placeOrder, onSuccess: {
                response in

                print(response.toJSON())

                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Success", message: response.message!, buttonTitle: nil, controller: nil)
                    
                    ((UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? TabBarViewController)?.updateViewCartCount()
                    BaseApp.sharedInstance.openTabScreenWithIndex(index: TabIndex.Home.rawValue)
                    
                    SwiftEventBus.post(AppConstant.kRefreshViewCart)
                }
            }, onError: {
                error in
                print(error.toString())

                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: self)
                }
            })
            //
            BaseApp.sharedInstance.jobManager?.addOperation(addShippingAddressRequest)


        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
}
