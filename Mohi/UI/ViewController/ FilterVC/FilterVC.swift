//
//  FilterVC.swift
//  Mohi
//
//  Created by Consagous on 17/10/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import SwiftRangeSlider

class FilterVC: BaseViewController {
    
    @IBOutlet weak var rangeSlider:RangeSlider!
    @IBOutlet weak var labelLowerValue:UILabel!
    @IBOutlet weak var labelUpperValue:UILabel!
    
    @IBOutlet weak var buttonBrandCollection:UIButton!
    @IBOutlet weak var buttonColorCollection:UIButton!
    @IBOutlet weak var buttonCatalogCollection:UIButton!
    
    @IBOutlet weak var brandNameValueList:UILabel!
    @IBOutlet weak var colorNameValueList:UILabel!
    @IBOutlet weak var categoriesNameValueList:UILabel!
    
    @IBOutlet weak var buttonInStock:UIButton!
    @IBOutlet weak var buttonOutStock:UIButton!
    
    fileprivate var filterOptionList:FilterOptionList?
    
//    @IBOutlet weak var colletionViewBrand:UICollectionView!
//    @IBOutlet weak var colletionViewColor:UICollectionView!
    
    var selected_Cat_Id:String?
    
    fileprivate var filterDataResponse:APIResponseParam.GetFilterListItems?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateSliderValue()
        
        serverFilterData()
        
        buttonInStock.isSelected = true
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //rangeSlider.needsUpdateConstraints()
        rangeSlider.setNeedsLayout()
        rangeSlider.setNeedsDisplay()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FilterVC{
    @IBAction func backButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
//        BaseApp.sharedInstance.openTabScreenWithIndex(index: 0)
    }
    
    @IBAction func inStockButtonAction(_ sender:Any){
        buttonInStock.isSelected = true
        buttonOutStock.isSelected = false
    }
    
    @IBAction func outStockButtonAction(_ sender:Any){
        buttonInStock.isSelected = false
        buttonOutStock.isSelected = true
    }
    
    @IBAction func applyButtonAction(_ sender:Any){
        serverFilterOptionSearchList()
    }
    
    @IBAction func filterOptionButtonAction(_ sender:Any){
        
        filterOptionList = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.FilterVCStoryboard, viewControllerName: FilterOptionList.nameOfClass)
        
        switch (sender as AnyObject).tag {
        case 1:
            filterOptionList?.optionListData = filterDataResponse?.getFilterListItemsData?.brands
            filterOptionList?.filterOptionType = .Brand
            filterOptionList?.title = BaseApp.sharedInstance.getMessageForCode("titleShopByBrand", fileName: "Strings")
            break
        case 2:
            filterOptionList?.optionListData = filterDataResponse?.getFilterListItemsData?.color
            filterOptionList?.filterOptionType = .Color
            filterOptionList?.title = BaseApp.sharedInstance.getMessageForCode("titleColor", fileName: "Strings")
            break
        case 3:
            filterOptionList?.optionListData = filterDataResponse?.getFilterListItemsData?.category
            filterOptionList?.filterOptionType = .Catagory
            filterOptionList?.title = BaseApp.sharedInstance.getMessageForCode("titleCategories", fileName: "Strings")
            break
        default:
            break
        }
        filterOptionList?.delegate = self
        self.navigationController?.pushViewController(filterOptionList!, animated: true)
    }
}

// MARK:- Fileprivate method implementation
extension FilterVC{
    fileprivate func updateSliderValue(){

        labelLowerValue.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextTextViewCartCell(normalText: "\(String(format: "%.02f", rangeSlider.lowerValue))", textFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(20), textColor: UIColor(hexString: ColorCode.viewCartCellPriceColor) ?? UIColor.red, currency: AppConstant.CURRENCY_SYMBOL, currencyTextFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(12), currencyColor: UIColor(hexString: ColorCode.viewCartCellCurrencyColor) ?? UIColor.black)
        
        labelUpperValue.attributedText = BaseApp.sharedInstance.convertSimpleTextToAttributedTextTextViewCartCell(normalText: "\(String(format: "%.02f", rangeSlider.upperValue))", textFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(20), textColor: UIColor(hexString: ColorCode.viewCartCellPriceColor) ?? UIColor.red, currency: AppConstant.CURRENCY_SYMBOL, currencyTextFont: FontsConfig.FontHelper.defaultFontUbantuWithSizeM(12), currencyColor: UIColor(hexString: ColorCode.viewCartCellCurrencyColor) ?? UIColor.black)
    }
    
    fileprivate func updateFilterOptionValue(){
        
        if(filterDataResponse != nil && filterDataResponse?.getFilterListItemsData != nil){
            // prepare filter option for brand
            if(filterDataResponse?.getFilterListItemsData?.brands != nil){
                var brandNameList:[String] = []
                for brand in (filterDataResponse?.getFilterListItemsData?.brands!)!{
                    if brand.status{
                        brandNameList.append((brand.name?.localizedLowercase.localizedCapitalized) ?? "")
                    }
                }
                
                brandNameValueList.text = brandNameList.joined(separator: ",")
            }
            
            // prepare filter option for color
            if(filterDataResponse?.getFilterListItemsData?.color != nil){
                var colorNameList:[String] = []
                for color in (filterDataResponse?.getFilterListItemsData?.color!)!{
                    if color.status{
                        colorNameList.append((color.name?.localizedLowercase.localizedCapitalized) ?? "")
                    }
                }
                
                colorNameValueList.text = colorNameList.joined(separator: ",")
            }
            
            // prepare filter option for Catagories
            if(filterDataResponse?.getFilterListItemsData?.category != nil){
                var categoryNameList:[String] = []
                for category in (filterDataResponse?.getFilterListItemsData?.category!)!{
                    if category.status{
                        categoryNameList.append((category.name?.localizedLowercase.localizedCapitalized) ?? "")
                    }
                }
                
                categoriesNameValueList.text = categoryNameList.joined(separator: ",")
            }
        }
    }
    
//    fileprivate func openProductListScr(productDataList:[APIResponseParam.Product.ProductData]?){
//        let productList:ProductListVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ProductVCStoryboard, viewControllerName: ProductListVC.nameOfClass) as ProductListVC
//        productList.isDisplayFromFilter = true
//        productList.productDataList = productDataList
//        self.navigationController?.pushViewController(productList, animated: true)
//
//    }
}

// MARK:- Action method implmenentation
extension FilterVC{
    //- (void)rangeSliderValueDidChange:(MARKRangeSlider *)slider {
//    NSLog(@"%0.2f - %0.2f", slider.leftValue, slider.rightValue);
//}
    
    @IBAction func rangeSliderValueDidChange(slider:RangeSlider){
//        RangeSlider
        print("left Value: \(slider.lowerValue) right value: \(slider.upperValue)")
        
        updateSliderValue()
    }
}

extension FilterVC: FilterOptionListDelegate{
    func updateOptionList(){
        if filterOptionList?.filterOptionType == FilterOptionType.Brand{
            filterDataResponse?.getFilterListItemsData?.brands = filterOptionList?.optionListData
        } else if filterOptionList?.filterOptionType == FilterOptionType.Color{
            filterDataResponse?.getFilterListItemsData?.color = filterOptionList?.optionListData
        } else if filterOptionList?.filterOptionType == FilterOptionType.Catagory{
            filterDataResponse?.getFilterListItemsData?.category = filterOptionList?.optionListData
        }
        
        updateFilterOptionValue()
    }
}

//
//extension FilterVC: UICollectionViewDataSource{
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        //return itemList.count
//        if collectionView == colletionViewBrand{
//
//        } else if collectionView == colletionViewColor {
//
//        }
//
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let dashboardCollectionCell:DashboardCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! DashboardCollectionCell
////
////        dashboardCollectionCell.labelTitle.text = itemList[indexPath.row]
////        dashboardCollectionCell.backgroundColor = UIColor.white
////        return dashboardCollectionCell
//        return UICollectionViewCell(frame: CGRect.zero)
//    }
//}
//
//extension FilterVC: UICollectionViewDelegate{
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        print("Item Selection")
////        print(indexPath)
//        //TODO: open selection list view controller as per collection type
//    }
//}

// MARK:- Server API calling
extension FilterVC{
    func serverFilterData(){
        if (BaseApp.sharedInstance.isNetworkConnected){
                        BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let getFilterListItemsRequest = GetFilterListItemsRequest(onSuccess:{ response in
                
                print(response.toJSON())
                OperationQueue.main.addOperation() {
                    
                    BaseApp.sharedInstance.hideProgressHudView()
                    self.filterDataResponse = response
                    
                    if(self.selected_Cat_Id != nil){
                        // prepare filter option for Catagories
                        if(self.filterDataResponse?.getFilterListItemsData?.category != nil){
                            var categoryNameList:[String] = []
                            for category in (self.filterDataResponse?.getFilterListItemsData?.category!)!{
                                if(category.id?.compare(self.selected_Cat_Id!) == ComparisonResult.orderedSame){
                                    category.status = true
                                }
                            }
                        }
                    }
                    
                    if(self.filterDataResponse?.getFilterListItemsData != nil && response.getFilterListItemsData?.priceData != nil){
                        self.rangeSlider.lowerValue = Double(response.getFilterListItemsData?.priceData?.low ?? "0.00") ?? 0.00
                        self.rangeSlider.upperValue = Double(response.getFilterListItemsData?.priceData?.high ?? "0.00") ?? 0.00
                    }
                    
                    self.updateSliderValue()
                    self.updateFilterOptionValue()
                }
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: self)
                }
            })
            BaseApp.sharedInstance.jobManager?.addOperation(getFilterListItemsRequest)
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
        }
    }
    
    func serverFilterOptionSearchList(){
        var brandIdListInfo = ""
        var colorIdListInfo = ""
        var categoryIdList:[String] = []
        if(filterDataResponse != nil && filterDataResponse?.getFilterListItemsData != nil){
            // prepare filter option for brand
            if(filterDataResponse?.getFilterListItemsData?.brands != nil){
                var brandIdList:[String] = []
                for brand in (filterDataResponse?.getFilterListItemsData?.brands!)!{
                    if brand.status{
                        brandIdList.append(brand.id ?? "")
                    }
                }
                
                brandIdListInfo = brandIdList.joined(separator: ",")
            }
            
            // prepare filter option for color
            if(filterDataResponse?.getFilterListItemsData?.color != nil){
                var colorIdList:[String] = []
                for color in (filterDataResponse?.getFilterListItemsData?.color!)!{
                    if color.status{
                        colorIdList.append(color.id ?? "")
                    }
                }
                
                colorIdListInfo = colorIdList.joined(separator: ",")
            }
            
            // prepare filter option for Catagories
            if(filterDataResponse?.getFilterListItemsData?.category != nil){
                
                for category in (filterDataResponse?.getFilterListItemsData?.category!)!{
                    if category.status{
                        categoryIdList.append(category.id ?? "")
                    }
                }
            }
            
            let filterProductData = APIRequestParam.FilterProduct(user_id: ApplicationPreference.getUserId(), token: ApplicationPreference.getAppToken(), cat_id: categoryIdList, height: "600", width: "600", from_price: "\(rangeSlider.lowerValue)", to_price: "\(rangeSlider.upperValue)", availabilty: buttonInStock.isSelected == true ? "1":"2", brand: brandIdListInfo, color: colorIdListInfo)
            
            let productList:ProductListVC = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ProductVCStoryboard, viewControllerName: ProductListVC.nameOfClass) as ProductListVC
            productList.isDisplayFromFilter = true
            productList.filterProductOption = filterProductData
            self.navigationController?.pushViewController(productList, animated: true)
        }
    }
}
