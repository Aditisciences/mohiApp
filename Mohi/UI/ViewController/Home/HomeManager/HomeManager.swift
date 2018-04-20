//
//  HomeManager.swift
//  Mohi
//
//  Created by Sandeep Kumar  on 16/04/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import UIKit

class HomeManager: NSObject {
    
    //MARK: - Enum -
    enum availableDataType {
        case slider, offer, bannerBottom, bannerMiddle, categories, mostSearched, recentlyViewed, trendingNow
    }
    
    //MARK: - Variables -
    
    //Slider
    var slider: [String] = [String]()
    
    //Banner Middle
    var bannerMiddle: [String] = [String]()
    
    //Banner Bottom
    var bannerBottom: [String] = [String]()
    
    //Offers
    var offers: [[String: Any]] = [[String: Any]]()

    //Categories
    internal var categories: [Category] = [Category]()
    
    var homeCategories: [Category] {
        
        get {
            
            func appendHomeDictionary() -> Category {
                
                var homeDict: [String: Any] = [String: Any]()
                homeDict["name"] = "Home"
                homeDict["catId"] = 0
                
                let homeCategoryModel: Category = Mapper<Category>().map(JSON: homeDict)!
                
                return homeCategoryModel
            }
            
            if self.categories.count == 0 {
                
                self.categories = [appendHomeDictionary()]
                
            }else {
                
                let filterCategoriesNames: [String] = self.categories.map({ $0.name ?? "" })
                
                if !filterCategoriesNames.contains("Home") {
                    
                    self.categories.insert(appendHomeDictionary(), at: 0)
                }
            }
            
            return self.categories
            
        }
    }
    
    //Most Searched
    var mostSearchedProducts: [Product] = [Product]()
    
    var recentlyViewedProducts: [Product] = [Product]()
    
    var trendingNowProducts: [Product] = [Product]()

    //MARK: - Shared class object -
    static var shared: HomeManager = HomeManager()
}
