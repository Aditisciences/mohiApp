//
//  TopAddSliderTableViewCell.swift
//  Mohi
//
//  Created by Sandeep Kumar  on 17/04/18.
//  Copyright © 2018 Consagous. All rights reserved.
//

import UIKit
import ImageSlideshow

class TopAddSliderTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet var slideshow: ImageSlideshow!
    
    //MARK: - Initialize cell -
    class func cellObject(forTable tableView: UITableView, indexPath: IndexPath) -> TopAddSliderTableViewCell {
        let cell: TopAddSliderTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier(), for: indexPath) as! TopAddSliderTableViewCell
        return cell
    }
    
    class func registerNib(forTable tableView: UITableView) {
        let nib: UINib = UINib(nibName: "TopAddSliderTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: self.cellIdentifier())
    }
    
    class func cellIdentifier() -> String {
        return "TopAddSliderTableViewCellIdentifier"
    }
    
    //MARK: - View life cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 3.0
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.appTheamRedColor()
        slideshow.pageControl.pageIndicatorTintColor = UIColor.appTheamWhiteColor()
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
             //print("current page:", page)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(sliderImageURLs: [String]) {
        
        if sliderImageURLs.count > 0 {
            
            var sdWebImageSource:[SDWebImageSource] = []
            for tempImageUrl in sliderImageURLs {
                sdWebImageSource.append(SDWebImageSource(urlString: tempImageUrl)!)
            }
            self.slideshow.setImageInputs(sdWebImageSource)
        }
        
    }
}
