//
//  BookingCell.swift
//  DemoCarosuel
//
//  Created by cl-macmini-23 on 13/02/18.
//  Copyright © 2018 cl-macmini-23. All rights reserved.
//

import UIKit

class BookingCell: UICollectionViewCell {
    
    @IBOutlet weak var demoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
//        self.layer.cornerRadius = max(self.bounds.width, self.bounds.height)/2
//        self.layer.masksToBounds = true
    }

}

extension UIView {
    
    func screenshot() -> UIImage {
        return UIGraphicsImageRenderer(size: bounds.size).image { _ in
            drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
        }
    }
    
}
