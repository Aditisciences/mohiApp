//
//  HomeOfferCollectionViewCell.swift
//  Mohi
//
//  Created by Sandeep Kumar  on 17/04/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import UIKit
import SDWebImage

class HomeOfferCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets -
    @IBOutlet weak var offerImageView: UIImageView!
    
    // MARK: - Initialize item -
    class func itemObject(forCollection collectionView: UICollectionView, indexPath: IndexPath) -> HomeOfferCollectionViewCell {
        let item: HomeOfferCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.itemIdentifier(), for: indexPath) as! HomeOfferCollectionViewCell
        return item
    }
    
    class func registerNib(forTable collectionView: UICollectionView) {
        let itemCollectionNib: UINib = UINib(nibName:String(describing: HomeOfferCollectionViewCell.self), bundle:Bundle.main)
        collectionView.register(itemCollectionNib, forCellWithReuseIdentifier: self.itemIdentifier())
    }
    
    class func itemIdentifier() -> String {
        return "HomeOfferCollectionViewCellIdentifier"
    }
    
    //MARK: - View life cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Initalize class -
    func configureOfferCell(imageURL: String) {
        
        if let uRL: URL = URL(string: imageURL) {
            
            self.offerImageView.sd_setImage(with: uRL, placeholderImage: nil, options: [], completed: { [weak self] (image, error, cacheType, url) in
                self?.offerImageView.image = image
            })
            
        }
        
    }
    
}
