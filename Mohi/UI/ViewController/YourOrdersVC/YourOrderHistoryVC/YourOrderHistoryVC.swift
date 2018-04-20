//
//  YourOrderHistoryVC.swift
//  Mohi
//
//  Created by Mac on 05/12/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

enum OrderStatus:String{
    case Pending
    case Complete
    case Canceled
    case Processing
}

class YourOrderHistoryVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellHeightWithToolbar:CGFloat = 185
    let cellHeightWithOutToolbar:CGFloat = 145
    
    let cellImage_Height:CGFloat = 90
    let cellImage_Width:CGFloat = 90
    
    var getOrderHistoryData:[APIResponseParam.GetOrderHistory.GetOrderHistoryData] = []
    fileprivate var needHelpViewController:NeedHelpViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        needHelpViewController = nil
        refreshScrInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK:- Action method implementation
extension YourOrderHistoryVC{
    @IBAction func backButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
    }
}

// MARK:- Fileprivate method implementation
extension YourOrderHistoryVC{
    fileprivate func refreshScrInfo(){
        serverAPI()
    }
}

//MARK:- UITableViewDataSource and UITableViewDelegate method implementation
extension YourOrderHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getOrderHistoryData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(getOrderHistoryData.count > 0){
            let orderStatus = getOrderHistoryData[indexPath.row]
            if(orderStatus.status?.caseInsensitiveCompare(OrderStatus.Canceled.rawValue) == ComparisonResult.orderedSame){
                return cellHeightWithOutToolbar
            }
        }
        
        return cellHeightWithToolbar
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderHistoryCell.nameOfClass, for: indexPath) as! OrderHistoryCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
//        cell.labelProductDeliveryStatus.text = getOrderHistoryData[indexPath.row].status
        cell.viewPendingToolbar.isHidden = true
        cell.viewDeliveryToolbar.isHidden = true
        cell.delegate = self
        
        let orderStatus = getOrderHistoryData[indexPath.row]
        if(orderStatus.status?.caseInsensitiveCompare(OrderStatus.Pending.rawValue) == ComparisonResult.orderedSame){ // Pending
            cell.viewPendingToolbar.isHidden = false
        } else if(orderStatus.status?.caseInsensitiveCompare(OrderStatus.Complete.rawValue) == ComparisonResult.orderedSame){ // Delivered
//            cell.viewDeliveryToolbar.isHidden = false
        }
        
        cell.labelProductTitle.text = orderStatus.product_name
        cell.labelProductDeliveryStatus.text = ""
        cell.cellIndex = indexPath.row
        
        var imageName = "Orange-icon"
        if(orderStatus.status?.caseInsensitiveCompare(OrderStatus.Complete.rawValue) == ComparisonResult.orderedSame){
            imageName = "green-icon"
        } else if(orderStatus.status?.caseInsensitiveCompare(OrderStatus.Canceled.rawValue) == ComparisonResult.orderedSame){
            imageName = "Red-icon"
        }
        
        cell.labelProductDeliveryStatus.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextIcon(orderStatus.status_text ?? "", isIconLeftSide: true, isIconAdd: true, iconName:imageName, iconOffset: CGPoint(x: 0, y: -6))
        
        cell.imageViewProduct?.sd_setImage(with: URL(string: (orderStatus.image)!))
        
        return cell
    }
}

// Mark:- OrderHistoryCellDelegate method implementation
extension YourOrderHistoryVC: OrderHistoryCellDelegate{
    func openWriteReviewScr(cellIndex:Int) {
        
    }
    
    func cancelButtonPressed(cellIndex:Int){
        let orderStatus = getOrderHistoryData[cellIndex]
        
        // Add Delete functionality && update address id; if save address id remove
        APIClient.sharedInstance.serverAPICancelOrder(orderId: orderStatus.order_id, onSuccess: {
            response in
            
            print(response.toJSON())
            
            OperationQueue.main.addOperation() {
                // remove saved address when remove address id and default address id is same
                self.refreshScrInfo()
            }
        }, onError: nil)
        
    }
    
    func needHelpButtonPressed(cellIndex:Int){
        if(needHelpViewController == nil){
            //needHelpViewController = BaseApp.sharedInstance.getvi
            needHelpViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.YourOrdersStoryboard, viewControllerName: NeedHelpViewController.nameOfClass)
            self.navigationController?.pushViewController(needHelpViewController!, animated: true)
        }
    }
}
extension YourOrderHistoryVC{
    func serverAPI(){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let getOrderHistoryRequestParam = APIRequestParam.GetOrderHistory(user_id: ApplicationPreference.getUserId(), token: ApplicationPreference.getAppToken(), width: "\(cellImage_Width*UIScreen.main.scale)", height: "\(cellImage_Height*UIScreen.main.scale)")
            
            let featuredProductRequest =  GetOrderHistoryRequest(getOrderHistoryData: getOrderHistoryRequestParam, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    BaseApp.sharedInstance.hideProgressHudView()
                    self.getOrderHistoryData = response.getOrderHistoryData!
                    self.tableView.reloadData()
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
