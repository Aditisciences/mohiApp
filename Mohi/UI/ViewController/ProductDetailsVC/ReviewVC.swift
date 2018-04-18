//
//  ReviewVC.swift
//  Mohi
//
//  Created by Consagous on 06/11/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import Cosmos

class ReviewVC: BaseViewController {

    @IBOutlet weak var viewUpper: UIView!
    @IBOutlet weak var viewMedium: UIView!
    @IBOutlet weak var viewForRating: CosmosView!
    @IBOutlet weak var lblForProductName: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnForProductImage: UIButton!
    @IBOutlet weak var textForComment: KMPlaceholderTextView!
    
    var productData:APIResponseParam.ProductDetail.ProductDetailData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        viewUpper.layer.borderWidth = 1.0
        viewUpper.layer.borderColor =  UIColor.lightGray.cgColor
        viewUpper.clipsToBounds = true
        
        viewMedium.layer.borderWidth = 1.0
        viewMedium.layer.borderColor =  UIColor.lightGray.cgColor
        viewMedium.clipsToBounds = true
        
        btnSubmit.layer.cornerRadius = 10.0
        btnSubmit.clipsToBounds = true
        */
        
         btnForProductImage.sd_setImage(with: URL(string: (productData?.image)!), for: .normal, completed: nil)
        lblForProductName.text = productData?.product_name
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func backButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
    }

}

extension ReviewVC{
    
    func serverAPIAddToReview(){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            let rating: String = String(viewForRating.rating)
            
           
            let addReviewRequestParam =  APIRequestParam.Review.init(product_id:productData?.product_id, review:textForComment.text,user_id:ApplicationPreference.getUserId()!,token:ApplicationPreference.getAppToken(),name:(ApplicationPreference.getLoginInfo()?.value(forKey: "data") as! NSDictionary).value(forKey: "name") as! String,rating:rating)
            
            let featuredProductRequest =  AddReviewRequest.init(productData: addReviewRequestParam, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    //                    self.featuredDataList = response.featuredProductData
                    BaseApp.sharedInstance.hideProgressHudView()
                    //self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                    self.navigationController?.popViewController(animated: true)
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

extension ReviewVC{
    
    @IBAction func actionONSubmitButton(_ sender: Any){
        
        self.view.endEditing(true)
        
        if (textForComment.text?.isEmpty)! {
            let message = BaseApp.sharedInstance.getMessageForCode("enterReviewComment", fileName: "Strings")
            
            BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: message!, buttonTitle: "OK", controller: self)
         }  else {
            self.serverAPIAddToReview()
        }
        
}
}

