//
//  ModifyAddressVC.swift
//  Mohi
//
//  Created by RajeshYadav on 29/11/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

protocol ModifyAddressVCDelegate {
    func updateAddressInfo(address:APIResponseParam.ShippingAddress.ShippingAddressData?)
}

class ModifyAddressVC: BaseViewController {
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var constraintDeliverHereBtnHeight:NSLayoutConstraint!
    @IBOutlet weak var labelNoAddress: UILabel!

    fileprivate var lastViewOptionIndex = -1
    fileprivate var shippingAddressList:[APIResponseParam.ShippingAddress.ShippingAddressData]?
    fileprivate var addNewAddressVC:AddNewAddressVC?
    
    var selectedAddressData:APIResponseParam.ShippingAddress.ShippingAddressData?
    var isDisplayDeliverHereBtnHidden = true
    var delegate:ModifyAddressVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(isDisplayDeliverHereBtnHidden){
           // constraintDeliverHereBtnHeight.constant = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SwiftEventBus.onMainThread(self, name:AppConstant.kRefreshTableView,
                                   handler: handleRefreshTableView)
        addNewAddressVC = nil
        let selectedAddress = ApplicationPreference.getAddressInfo()
        if(selectedAddress != nil){
            //selectedAddressData = APIResponseParam.ShippingAddress.ShippingAddressData().getModelObjectFromServerResponse(jsonResponse: (selectedAddress as? AnyObject)!)

            let tempAddressData = APIResponseParam.ShippingAddress.ShippingAddressData().getModelObjectFromServerResponse(jsonResponse: (selectedAddress as? AnyObject)!)


            if (tempAddressData != nil && selectedAddressData != nil ){
                selectedAddressData = tempAddressData
            }else {
                selectedAddressData = tempAddressData
            }
        }
        self.serverAPIGetAddress()
    }
}

// MARK:- Handle notification
extension ModifyAddressVC{
    func handleRefreshTableView(notification: Notification!) -> Void{
        self.addressTableView.reloadData()
    }
}

// MARK:- Fileprivate method implementation
extension ModifyAddressVC{
    @objc fileprivate func reloadTableInfo(){
        self.addressTableView.reloadData()
    }
}

//MARK:- Action method implementation
extension ModifyAddressVC{
    @IBAction func backButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewAddressButtonAction(_ sender:Any){
        addNewAddressVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.MyAccountStoryboard, viewControllerName: AddNewAddressVC.nameOfClass) as AddNewAddressVC
        self.present(addNewAddressVC!, animated: true, completion: nil)
    }
    
    @IBAction func deliveryHereButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
        if(delegate != nil){
            delegate?.updateAddressInfo(address: selectedAddressData ?? nil)
        }
    }
}

extension ModifyAddressVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("I M TABLE")
        guard shippingAddressList != nil  else {
            print ("list is empty ++++")
            return 0
        }
        return shippingAddressList != nil ? (shippingAddressList?.count)! : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ModifyAddressCell.nameOfClass, for: indexPath) as! ModifyAddressCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.delegate = self
        cell.cellIndex = indexPath.row
        
        let shippingAddress = shippingAddressList![indexPath.row]
        cell.labelTitle.text = shippingAddress.firstname
        cell.labelDesc.text = shippingAddress.addressToString()
//        cell.buttonAddressSelection.isHidden = isDisplayDeliverHereBtnHidden
        
        // TODO: remove shipping address on BuyNow flow
        //cell.isDeleteBtnHidden = !isDisplayDeliverHereBtnHidden
        
//        if(self.selectedAddressData != nil){
//            if(shippingAddressList![indexPath.row].address_id?.caseInsensitiveCompare(self.selectedAddressData?.address_id ?? "") == ComparisonResult.orderedSame){
//                cell.buttonAddressSelection.isSelected = true
//            } else{
//                cell.buttonAddressSelection.isSelected = false
//            }
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let shippingAddress = shippingAddressList![indexPath.row]
//        if(!isDisplayDeliverHereBtnHidden && selectedAddressData != nil){
//            if(selectedAddressData?.address_id?.localizedCaseInsensitiveCompare(shippingAddress.address_id ?? "") == ComparisonResult.orderedSame){
//                lastViewOptionIndex = indexPath.row
//                cell.setSelected(true, animated: false)
//
//                selectedAddressData = shippingAddress
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if((shippingAddressList?.count)! > indexPath.row){
            let shippingAddress = shippingAddressList![indexPath.row]
            selectedAddressData = shippingAddress
        } else{
            self.addressTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ModifyAddressVC: ModifyAddressCellDelegate{
    
    func editButton(cellIndex: Int, editButtonFrame: CGRect) {
        if((shippingAddressList?.count)! > cellIndex){
            // open address in edit mode
            addNewAddressVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.MyAccountStoryboard, viewControllerName: AddNewAddressVC.nameOfClass) as AddNewAddressVC
            
            addNewAddressVC?.shippingAddressData = shippingAddressList![cellIndex]
            
            addNewAddressVC?.screenTitle = BaseApp.sharedInstance.getMessageForCode("titleModifyAddress", fileName: "Strings") ?? ""
            
            self.present(addNewAddressVC!, animated: true, completion: nil)
        } else{
            self.addressTableView.reloadData()
        }
    }
    

    
    func deleteButton(cellIndex:Int, editButtonFrame:CGRect){
        
        print("List total count: \(shippingAddressList?.count)")
        print("Delete Cell Index: \(cellIndex)")
        // Add Delete functionality && update address id; if save address id remove
        if((shippingAddressList?.count)! > cellIndex){
            if (BaseApp.sharedInstance.isNetworkConnected){
                
                // First remove from list and call server api
                let addressId = shippingAddressList![cellIndex].address_id!
                
                self.shippingAddressList?.remove(at: cellIndex)
                self.addressTableView?.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
                
                if(self.shippingAddressList?.count == 0){
                    self.labelNoAddress.isHidden = false
                }
                
                BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
                let  removeShippingAddressParma = APIRequestParam.DeleteShippingAddress(user_id: ApplicationPreference.getUserId(), token: ApplicationPreference.getAppToken(), address_id: addressId)
                let removeFromAddToCartRequest =  DeleteShippingAddressRequest(deleteShippingAddress: removeShippingAddressParma, onSuccess: { response in
                    print(response.toJSON())

                    OperationQueue.main.addOperation() {

                        BaseApp.sharedInstance.showAlertViewControllerWith(title: "Success", message: response.message!, buttonTitle: nil, controller: nil)

                        let selectedAddress = ApplicationPreference.getAddressInfo()
                        if(selectedAddress != nil){
                            self.selectedAddressData = APIResponseParam.ShippingAddress.ShippingAddressData().getModelObjectFromServerResponse(jsonResponse: (selectedAddress as? AnyObject)!)
                        } else {
                            ApplicationPreference.removeAddressInfo()
                            self.selectedAddressData = nil
                            self.labelNoAddress.isHidden = false
                        }

                        if self.delegate != nil {
                            self.delegate?.updateAddressInfo(address: self.selectedAddressData)
                        }

                        print("Remove Object :\(cellIndex)")

                        DispatchQueue.main.async {
                            BaseApp.sharedInstance.hideProgressHudView()
                        }

                    }
                }, onError: { error in
                    print(error.toString())

                    OperationQueue.main.addOperation() {
                        // when done, update your UI and/or model on the main queue
                        BaseApp.sharedInstance.hideProgressHudView()
                        BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: nil, controller: nil)
                        self.serverAPIGetAddress()
                    }
                })
                BaseApp.sharedInstance.jobManager?.addOperation(removeFromAddToCartRequest)
                
            } else {
                BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
            }
            
        } else {
            self.addressTableView?.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
        }
    }
    
    func viewOptionButton(cellIndex:Int){
        
        if isDisplayDeliverHereBtnHidden == false {
            if(lastViewOptionIndex > -1 && lastViewOptionIndex != cellIndex){
                addressTableView.beginUpdates()
                var cell = addressTableView.cellForRow(at: IndexPath(row: lastViewOptionIndex, section: 0))
                cell?.setSelected(false, animated: true)
                lastViewOptionIndex = cellIndex
                
                cell = addressTableView.cellForRow(at: IndexPath(row: lastViewOptionIndex, section: 0))
                cell?.setSelected(true, animated: true)
                addressTableView.endUpdates()
            }
        } else {
            if(lastViewOptionIndex == -1 || lastViewOptionIndex != cellIndex){
                addressTableView.beginUpdates()
                var cell = addressTableView.cellForRow(at: IndexPath(row: lastViewOptionIndex, section: 0))
                cell?.setSelected(false, animated: true)
                lastViewOptionIndex = cellIndex
                
                cell = addressTableView.cellForRow(at: IndexPath(row: lastViewOptionIndex, section: 0))
                cell?.setSelected(true, animated: true)
                addressTableView.endUpdates()
            }
        }
        lastViewOptionIndex = cellIndex
    }
    
    func cellCurrentSelectedIndex(cellIndex:Int){
        if(lastViewOptionIndex != cellIndex){
            addressTableView.beginUpdates()
            let cell = addressTableView.cellForRow(at: IndexPath(row: lastViewOptionIndex, section: 0))
            cell?.setSelected(false, animated: true)
            lastViewOptionIndex = cellIndex
            addressTableView.endUpdates()
        }
    }
}

extension ModifyAddressVC{
    
    func serverAPIGetAddress(){
        labelNoAddress.isHidden = true
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let getShippingAddress = APIRequestParam.GetShippingAddress(user_id: ApplicationPreference.getUserId(), token: ApplicationPreference.getAppToken())
            let getShippingAddressRequest =  GetShippingAddressRequest(getShippingAddress: getShippingAddress, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    self.shippingAddressList = response.shippingAddressDataList
                    BaseApp.sharedInstance.hideProgressHudView()
                    
                    if(self.shippingAddressList?.count == 0){
                        self.labelNoAddress.isHidden = false
                        ApplicationPreference.removeAddressInfo()
                    } else { // check if default address is alos remove
                        var found = false
                        
//                        for shippingAddress in self.shippingAddressList!{
//
//                            if(self.selectedAddressData?.address_id?.localizedCaseInsensitiveCompare(shippingAddress.address_id ?? "") == ComparisonResult.orderedSame){
//                                found = true
//                            }
//                        }
                        
//                        if !found {
//                            ApplicationPreference.removeAddressInfo()
//                        }
                    }
                    
                    self.lastViewOptionIndex = -1
                    self.addressTableView.reloadData()
                    
                }
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: self)
                }
            })
            BaseApp.sharedInstance.jobManager?.addOperation(getShippingAddressRequest)
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
}
