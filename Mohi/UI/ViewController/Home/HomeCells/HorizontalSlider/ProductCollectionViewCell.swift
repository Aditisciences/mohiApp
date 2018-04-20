//
//  ROItemCollectionViewCell.swift
//  Roo
//
//  Created by Sandeep Kumar  on 17/02/18.
//  Copyright © 2018 Sandeep Kumar . All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets -
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var likeBackView: UIView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!

    // MARK: - Variables -
    
    // MARK: - Initialize item -
    class func productItemObject(forCollection collectionView: UICollectionView, indexPath: IndexPath) -> ProductCollectionViewCell {
        let item: ProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.itemIdentifier(), for: indexPath) as! ProductCollectionViewCell
        return item
    }
    
    class func registerNib(forTable collectionView: UICollectionView) {
        let itemCollectionNib: UINib = UINib(nibName:String(describing: ProductCollectionViewCell.self), bundle:Bundle.main)
        collectionView.register(itemCollectionNib, forCellWithReuseIdentifier: self.itemIdentifier())
    }
    
    class func itemIdentifier() -> String {
        return "ProductCollectionViewCellIdentifier"
    }
    
    //MARK: - View life cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Initalize class -
    func configureProductCollectionCell(product: Product) {
        
        self.nameLabel.text = product.productName ?? ""
        self.subtitleLabel.text = "RS \(product.productPrice ?? 0)"
        self.priceLabel.text = "RS \(product.productPrice ?? 0)"

        if let uRL: URL = URL(string: product.image ?? "") {
            
            self.productImageView.sd_setImage(with: uRL, placeholderImage: nil, options: [], completed: { [weak self] (image, error, cacheType, url) in
                self?.productImageView.image = image
            })
            
        }
    }

}
