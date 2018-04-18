//
//  HomeManager+Additions.swift
//  Mohi
//
//  Created by Sandeep Kumar  on 16/04/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import Foundation
import ObjectMapper

extension HomeManager {
    
    //MARK: - Fetch All Categories -
    func fetchAllCategoriesFromAPI(completion: @escaping ((_ status: Bool) -> Swift.Void)) {
        
        if (BaseApp.sharedInstance.isNetworkConnected){
            
            BaseApp.sharedInstance.showProgressHudViewWithTitle(title: "")
            
            let featuredProductRequestParam = APIRequestParam.Categories(limit:"", page:"",user_id: "319", token: "6ob6engXtqUQl37", width: "\(UIScreen.main.bounds.size.width)", height: "45.0")
            
            let featuredProductRequest =  CategoriesRequest(categoriesData: featuredProductRequestParam, onSuccess: { response in
                
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    
                    BaseApp.sharedInstance.hideProgressHudView()
                    
                    var categoriesTempArray: [Category] = [Category]()

                    if let categoriesArray: [[String: Any]] = response.toJSON()["data"] as? [[String: Any]] {
                        for categoryDictionary in categoriesArray {
                            if let categoryModel: Category = Mapper<Category>().map(JSON: categoryDictionary) {
                                categoriesTempArray.append(categoryModel)
                            }
                        }
                    }
                    HomeManager.shared.categories = categoriesTempArray
                    
                    completion(true)
                }
                
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: nil)
                    
                    completion(true)
                }
            })
            BaseApp.sharedInstance.jobManager?.addOperation(featuredProductRequest)
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
            completion(true)
        }
    }
    
    func fetchAllHomeData(completion: @escaping ((_ status: Bool) -> Swift.Void)) {
        
        if (BaseApp.sharedInstance.isNetworkConnected){

            let homeScreenDetail = APIRequestParam.HomeScreenDetail(user_id:"319", token: "6ob6engXtqUQl37", width: "\(UIScreen.main.bounds.size.width)", height: "\(UIScreen.main.bounds.size.height)")
            
            let homeScreenDetailRequest = GetHomeScreenDetailsRequest(homeScreenDetail: homeScreenDetail, onSuccess:{ response in
                
                print(response.toJSON())
                
                OperationQueue.main.addOperation() {
                    BaseApp.sharedInstance.hideProgressHudView()
                    self.fillDataReceivedFromHomePageAPI(response: response.homeData)
                    
                    completion(true)
                }
            }, onError: { error in
                print(error.toString())
                
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    BaseApp.sharedInstance.hideProgressHudView()
                    BaseApp.sharedInstance.showAlertViewControllerWith(title: "Error", message: error.errorMsg!, buttonTitle: "OK", controller: nil)
                    
                    completion(true)
                }
            })
            BaseApp.sharedInstance.jobManager?.addOperation(homeScreenDetailRequest)
            
        } else {
            BaseApp.sharedInstance.showNetworkNotAvailableAlertController()
            completion(true)
        }
    }
}

extension HomeManager {
    
    func fillDataReceivedFromHomePageAPI(response: [String: Any]?) {
        
        guard let data: [String: Any] = response?["data"] as? [String: Any] else {
            return
        }
        
        if let banners: [String: Any] = data["banners"] as? [String: Any] {
            
            if let slider: [String] = banners["slider"] as? [String] {
                self.slider = slider
            }
            
            if let middleBanner: [String] = banners["banners-middle"] as? [String] {
                self.bannerMiddle = middleBanner
            }
            
            if let bottomBanner: [String] = banners["banner-bottom"] as? [String] {
                self.bannerBottom = bottomBanner
            }
            
            if let offerDict: [String: Any] = banners["offer"] as? [String: Any] {
                
                var offerArray: [[String: Any]] = [[String: Any]]()
                
                for key in offerDict.keys {
                    
                    var dict: [String: Any] = [String: Any]()
                    dict[key] = (offerDict[key] as! [String]).first!
                    offerArray.append(dict)
                }
                
                self.offers = offerArray
            }
            
        }
        
        
        var categoriesTempArray: [Category] = [Category]()
        
        if let categoriesArray: [[String: Any]] = data["categories"] as? [[String: Any]] {
            for categoryDictionary in categoriesArray {
                if let categoryModel: Category = Mapper<Category>().map(JSON: categoryDictionary) {
                    categoriesTempArray.append(categoryModel)
                }
            }
        }
        HomeManager.shared.categories = categoriesTempArray
        
        var mostSearchedTempArray: [Product] = [Product]()
        
        if let mostSearchedArray: [[String: Any]] = data["most_searched"] as? [[String: Any]] {
            for mostSearchedDictionary in mostSearchedArray {
                if let productModel: Product = Mapper<Product>().map(JSON: mostSearchedDictionary) {
                    mostSearchedTempArray.append(productModel)
                }
            }
        }
        HomeManager.shared.mostSearchedProducts = mostSearchedTempArray
        
        
        var trendingNowTempArray: [Product] = [Product]()
        
        if let trendingNowArray: [[String: Any]] = data["trending_now"] as? [[String: Any]] {
            for trendingNowDictionary in trendingNowArray {
                if let productModel: Product = Mapper<Product>().map(JSON: trendingNowDictionary) {
                    trendingNowTempArray.append(productModel)
                }
            }
        }
        HomeManager.shared.trendingNowProducts = trendingNowTempArray
        
        
        var itemsViewedTempArray: [Product] = [Product]()
        
        if let itemsViewedArray: [[String: Any]] = data["recently_viewed"] as? [[String: Any]] {
            for itemsViewedDictionary in itemsViewedArray {
                if let productModel: Product = Mapper<Product>().map(JSON: itemsViewedDictionary) {
                    itemsViewedTempArray.append(productModel)
                }
            }
        }
        HomeManager.shared.recentlyViewedProducts = itemsViewedTempArray
        
    }
    
}
