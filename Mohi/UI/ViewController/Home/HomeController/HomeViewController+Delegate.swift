//
//  HomeViewController+Delegate.swift
//  Mohi
//
//  Created by Sandeep Kumar  on 17/04/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import Foundation

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table View Delegates -
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let sliderCell: TopAddSliderTableViewCell = TopAddSliderTableViewCell.cellObject(forTable: tableView, indexPath: indexPath)
            sliderCell.configureCell(sliderImageURLs: HomeManager.shared.slider)
            
            return sliderCell
            
        case 1:
            
            let offerCell: HomeOfferTableViewCell = HomeOfferTableViewCell.cellObject(forTable: tableView, indexPath: indexPath)
            
            let rectFrame: CGRect = CGRect.init(x: 0.0, y: 0.0, width: offerCell.bounds.size.width, height: offerCell.bounds.size.height)
            
            let collectionView: ProductHorizontalView? = ProductHorizontalView.intializeItemsHorizontalView(type: ProductHorizontalView.type.offer, frame: rectFrame)
            
            
            let filterCollectionViews = offerCell.offerView.subviews.filter { ($0.isKind(of: ProductHorizontalView.self)) }
            
            if let earlierCollectionView: ProductHorizontalView = filterCollectionViews.first as? ProductHorizontalView {
                earlierCollectionView.configureView(offers: HomeManager.shared.offers, title: "Offers")
            } else {
                collectionView?.configureView(offers: HomeManager.shared.offers, title: "Offers")
                offerCell.offerView.addSubview(collectionView ?? UIView())
            }
            
            return offerCell
            
        case 2:
            
            let productCell: ProductTableViewCell = ProductTableViewCell.cellObject(forTable: tableView, indexPath: indexPath)
            
            let rectFrame: CGRect = CGRect.init(x: 0.0, y: 0.0, width: productCell.bounds.size.width, height: productCell.bounds.size.height)
            
            let collectionView: ProductHorizontalView? = ProductHorizontalView.intializeItemsHorizontalView(type: ProductHorizontalView.type.product, frame: rectFrame)
            
            let filterCollectionViews = productCell.productView.subviews.filter { ($0.isKind(of: ProductHorizontalView.self)) }
            
            if let earlierCollectionView: ProductHorizontalView = filterCollectionViews.first as? ProductHorizontalView {
                earlierCollectionView.configureView(products: HomeManager.shared.mostSearchedProducts, title: "Most Searched")
            } else {
                collectionView?.configureView(products: HomeManager.shared.mostSearchedProducts, title: "Most Searched")
                productCell.productView.addSubview(collectionView ?? UIView())
            }
            
            return productCell
            
        case 3:
            
            let productCell: ProductTableViewCell = ProductTableViewCell.cellObject(forTable: tableView, indexPath: indexPath)
            
            let rectFrame: CGRect = CGRect.init(x: 0.0, y: 0.0, width: productCell.bounds.size.width, height: productCell.bounds.size.height)
            
            let collectionView: ProductHorizontalView? = ProductHorizontalView.intializeItemsHorizontalView(type: ProductHorizontalView.type.product, frame: rectFrame)
            
            let filterCollectionViews = productCell.productView.subviews.filter { ($0.isKind(of: ProductHorizontalView.self)) }
            
            if let earlierCollectionView: ProductHorizontalView = filterCollectionViews.first as? ProductHorizontalView {
                earlierCollectionView.configureView(products: HomeManager.shared.trendingNowProducts, title: "Trending Now")
            } else {
                collectionView?.configureView(products: HomeManager.shared.trendingNowProducts, title: "Trending Now")
                productCell.productView.addSubview(collectionView ?? UIView())
            }
            
            return productCell
            
        case 4:
            
            let bannerCell: BannerTableViewCell = BannerTableViewCell.cellObject(forTable: tableView, indexPath: indexPath)
            
            if HomeManager.shared.bannerMiddle.count > 0 {
                bannerCell.configureCell(imageURL: HomeManager.shared.bannerMiddle[0])
            }
            
            return bannerCell
            
        case 5:
            
            let bannerCell: BannerTableViewCell = BannerTableViewCell.cellObject(forTable: tableView, indexPath: indexPath)
            
            if HomeManager.shared.bannerMiddle.count > 1 {
                bannerCell.configureCell(imageURL: HomeManager.shared.bannerMiddle[1])
            }
            
            return bannerCell
            
        case 6:
            
            let productCell: ProductTableViewCell = ProductTableViewCell.cellObject(forTable: tableView, indexPath: indexPath)
            
            let rectFrame: CGRect = CGRect.init(x: 0.0, y: 0.0, width: productCell.bounds.size.width, height: productCell.bounds.size.height)
            
            let collectionView: ProductHorizontalView? = ProductHorizontalView.intializeItemsHorizontalView(type: ProductHorizontalView.type.product, frame: rectFrame)
            
            let filterCollectionViews = productCell.productView.subviews.filter { ($0.isKind(of: ProductHorizontalView.self)) }
            
            if let earlierCollectionView: ProductHorizontalView = filterCollectionViews.first as? ProductHorizontalView {
                earlierCollectionView.configureView(products: HomeManager.shared.recentlyViewedProducts, title: "Items You Viewed")
            } else {
                collectionView?.configureView(products: HomeManager.shared.recentlyViewedProducts, title: "Items You Viewed")
                productCell.productView.addSubview(collectionView ?? UIView())
            }
            
            return productCell
            
        case 7:
            
            let bannerCell: BannerTableViewCell = BannerTableViewCell.cellObject(forTable: tableView, indexPath: indexPath)
            
            if HomeManager.shared.bannerBottom.count > 0 {
                bannerCell.configureCell(imageURL: HomeManager.shared.bannerMiddle[0])
            }
            
            return bannerCell
            
        default:
            let footerCell: FooterTableViewCell = FooterTableViewCell.cellObject(forTable: tableView, indexPath: indexPath)
            return footerCell
        }
        
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
