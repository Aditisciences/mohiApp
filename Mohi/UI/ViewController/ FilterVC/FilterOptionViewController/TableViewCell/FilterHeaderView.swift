//
//  HeaderView.swift
//  Mohi
//

import UIKit

protocol FilterHeaderViewDelegate: class {
    func toggleSection(header: FilterHeaderView, section: Int)
}

class FilterHeaderView: UITableViewHeaderFooterView {

    var item: MyDeviceFilterOptionModelItem? {
        didSet {
            guard let item = item else {
                return
            }
            
            titleLabel?.text = item.sectionTitle
            setCollapsed(collapsed: item.isCollapsed)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var imageViewArrow: UIImageView?
    var section: Int = 0
    
    weak var delegate: FilterHeaderViewDelegate?
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    @objc private func didTapHeader() {
        delegate?.toggleSection(header: self, section: section)
    }

    func setCollapsed(collapsed: Bool) {
        imageViewArrow?.rotate(collapsed ? 0.0 : .pi/2)
        //imageViewArrow?.rotate(collapsed ? 0.0 : CGAffineTransformMakeRotation(CGFloat(M_PI_2)))
    }
}

extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
}
