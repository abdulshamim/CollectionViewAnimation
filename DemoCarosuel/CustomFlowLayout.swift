//
//  CustomFlowLayout.swift
//  DemoCarosuel
//
//  Created by cl-macmini-23 on 22/02/18.
//  Copyright © 2018 cl-macmini-23. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    @IBInspectable open var sideItemScale: CGFloat = 0.7
    @IBInspectable open var yOffsetTranslate: CGFloat = 0.5

    var size = CGSize()
    private let visibleOffset: CGFloat = 10
    

    override func prepare() {
        self.scrollDirection = .horizontal
        self.setupCollectionView()
        self.updateLayout()
    }
    
    fileprivate func setupCollectionView() {
        guard let collectionView = self.collectionView else { return }
        
        self.size = CGSize(width: collectionView.bounds.width/3.5, height: collectionView.bounds.width/3.5)
        self.itemSize.width = collectionView.bounds.width/3.5
        self.itemSize.height = collectionView.bounds.width/3.5
        if collectionView.decelerationRate != UIScrollViewDecelerationRateFast {
            collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        }
    }
    
    
    func updateLayout() {
        guard let collectionView = self.collectionView else { return }
        let collectionSize = collectionView.bounds.size
       
        let yInset: CGFloat = (collectionSize.height - self.itemSize.height)// / 2
        
        var xInset: CGFloat = 10
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        
        if numberOfItems < 2 && numberOfItems > 0 {
            xInset = (collectionSize.width - self.itemSize.width) / 2
        }
    
        self.sectionInset = UIEdgeInsetsMake(yInset, xInset, yInset, xInset)
        
        let side = self.itemSize.width
        let scaledItemOffset =  (side - side*self.sideItemScale) / 2
        
        let fullSizeSideItemOverlap = visibleOffset + scaledItemOffset
      //  let inset = xInset
        self.minimumLineSpacing = abs(xInset - fullSizeSideItemOverlap)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        return attributes.map({ self.transformLayoutAttributes($0) })
    }
    
    fileprivate func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
         guard let collectionView = self.collectionView else { return attributes }
      
        print(self.minimumLineSpacing)
        
        let collectionCenter = collectionView.frame.size.width/2
        let offset = collectionView.contentOffset.x
        let normalizedCenter = attributes.center.x - offset
        let maxDistance = self.itemSize.width + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance)/maxDistance
      
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, scale)
        attributes.zIndex = Int(scale * 50)
       
        let yPostionDistance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let positionRatio = abs((maxDistance - yPostionDistance)/maxDistance)
        let yTranslate =  positionRatio * (1.8 - self.yOffsetTranslate) //+ self.yOffsetTranslate
        attributes.center.y +=  -yTranslate/2.3*attributes.center.y
        attributes.center.y += 26
        return attributes
    }
    
}













