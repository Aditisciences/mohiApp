//
//  ROItemsHorizontalView.swift
//  Roo
//
//  Created by Sandeep Kumar  on 17/02/18.
//  Copyright © 2018 Sandeep Kumar . All rights reserved.
//

import UIKit

class ProductHorizontalView: UIView {

    //MARK: - IBOutlets -
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var titlelabel: UILabel!
    
    //MARK: - Enum -
    enum type {
        case offer, product
    }
    
    //MARK: - Variables -
    var viewType: ProductHorizontalView.type = ProductHorizontalView.type.product
    
    var products: [Product] = [Product]()
    var offers: [[String: Any]] = [[String: Any]]()

    //MARK: - Instance -
    class func intializeItemsHorizontalView(type: ProductHorizontalView.type, frame: CGRect) -> ProductHorizontalView? {
        guard let itemsHorizontalView = Bundle.main.loadNibNamed("ProductHorizontalView", owner: self, options: nil)?.first as? ProductHorizontalView else {
            return nil
        }
        itemsHorizontalView.frame = frame
        itemsHorizontalView.viewType = type
        return itemsHorizontalView
    }

    //MARK: - View life cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initializeCollectionView()
        
        self.productsCollectionView.delegate = self
        self.productsCollectionView.dataSource = self
    }
    
    //MARK: - Initalize class -
    private func initializeCollectionView() {
        self.registerCollectionViewNib()
    }
    
    private func registerCollectionViewNib() {
        
        let flow = self.productsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionHeadersPinToVisibleBounds = true
        
        ProductCollectionViewCell.registerNib(forTable: self.productsCollectionView)
        HomeOfferCollectionViewCell.registerNib(forTable: self.productsCollectionView)
    }
    
    func configureView(products: [Product], title: String) {
        
        self.titlelabel.text = title
        self.products = products
        
        DispatchQueue.main.async { [weak self] in
            self?.productsCollectionView.reloadData()
        }
    }
    
    func configureView(offers: [[String: Any]], title: String) {
        
        self.titlelabel.text = title
        self.offers = offers
                
        DispatchQueue.main.async { [weak self] in
            self?.productsCollectionView.reloadData()
        }
        
    }
}

extension ProductHorizontalView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Collection view delegate -
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch self.viewType {
        case ProductHorizontalView.type.product:
            
            return self.products.count
            
        case ProductHorizontalView.type.offer:
            
            return self.offers.count
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch self.viewType {
        case ProductHorizontalView.type.product:
            
            let itemCollection: ProductCollectionViewCell = ProductCollectionViewCell.productItemObject(forCollection: collectionView, indexPath: indexPath)
            itemCollection.configureProductCollectionCell(product: self.products[indexPath.item])
            return itemCollection
            
        case ProductHorizontalView.type.offer:
            
            let itemOffer: HomeOfferCollectionViewCell = HomeOfferCollectionViewCell.itemObject(forCollection: collectionView, indexPath: indexPath)
            
            let dict: [String: Any] = self.offers[indexPath.item]
            let urlString: String = dict[dict.keys.first!] as! String
            
            itemOffer.configureOfferCell(imageURL: urlString)
            return itemOffer
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch self.viewType {
        case ProductHorizontalView.type.product:
       
            return CGSize(width: 160, height: 240)

        case ProductHorizontalView.type.offer:
            
            return CGSize(width: 140, height: 80)
        }
    }
}
