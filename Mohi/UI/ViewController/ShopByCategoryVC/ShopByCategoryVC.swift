//
//  ShopByCategoryVC.swift
//  Mohi
//
//  Created by Consagous on 19/09/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import UIKit
import ObjectMapper

class ShopByCategoryVC: BaseViewController {
    
    @IBOutlet weak var tablView: UITableView!
    
    var categoriesList:[APIResponseParam.Categories.CategoriesData]?
    var loadedVeiw = CategoryCell()
    
    fileprivate var productListViewController:ProductListVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablView.delegate = self
        tablView.dataSource = self
        
        loadedVeiw =  UINib(nibName: "CategoryCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CategoryCell
        tablView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        serverAPIAllCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        productListViewController = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ShopByCategoryVC{
    @IBAction func backButtonAction(_ sender:Any){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func methodSearchAction(_ sender:Any){
        productListViewController = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ProductVCStoryboard, viewControllerName: ProductListVC.nameOfClass) as! ProductListVC
        productListViewController?.isDisplaySearch = true
        productListViewController?.isAllowFilter = false
        self.view.addSubview((productListViewController?.view)!)
    }
}

extension ShopByCategoryVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categoriesList == nil {
            return 0
        }
        return categoriesList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.lblForCateName.text = categoriesList?[indexPath.row].name
        //cell.btnForCategoriesImage.sd_setImage(with: URL(string: (categoriesList?[indexPath.row].image!)!), for: .normal, completed: nil)
//        cell.imageViewForCategoriesImage.sd_setImage(with: URL(string: (categoriesList?[indexPath.row].image!)!))
        
        cell.imageViewForCategoriesImage.sd_setImage(with: URL(string: (categoriesList?[indexPath.row].image!)!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let catInfo = categoriesList![indexPath.row]
        let controller = BaseApp.sharedInstance.getViewController(storyboardName: AppConstant.ProductVCStoryboard, viewControllerName: ProductListVC.nameOfClass) as! ProductListVC
        controller.cat_id = catInfo.cat_id ?? ""
        controller.screenTitle = catInfo.name ?? ""
        BaseApp.appDelegate.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ShopByCategoryVC{
    
    func serverAPIAllCategory(){
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let featuredProductRequestParam = APIRequestParam.Categories.init(limit:"", page:"",user_id: ApplicationPreference.getUserId()!, token: ApplicationPreference.getAppToken(),width:String(describing: (loadedVeiw.frame.size.width) * UIScreen.main.scale),height:String(describing: (loadedVeiw.frame.size.height) * UIScreen.main.scale))
            
            let featuredProductRequest =  CategoriesRequest.init(categoriesData: featuredProductRequestParam, onSuccess: { response in
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    self.categoriesList = response.categoriesData
                    BaseApp.sharedInstance.hideProgressHudView()
                    self.tablView.reloadData()
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
