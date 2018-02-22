//
//  CollectionCellCustomLayout.swift
//  DemoCarosuel
//
//  Created by cl-macmini-23 on 20/02/18.
//  Copyright © 2018 cl-macmini-23. All rights reserved.
//

import UIKit



class CollectionLaytoutAttributes: UICollectionViewLayoutAttributes {
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let coppiedAttributes = super.copy(with: zone) as! CollectionLaytoutAttributes
        return coppiedAttributes
    }
}

class CollectionCellCustomLayout: UICollectionViewLayout {
    
    @IBInspectable open var sideItemScale: CGFloat = 0.6
    
    let minimumLineSpacing: CGFloat = 50
    let size = CGSize(width: 100, height: 100)
    private var cache = [CollectionLaytoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        let width = CGFloat(collectionView!.numberOfItems(inSection: 0)) * size.width
        let height = collectionView!.bounds.height
        return CGSize(width: width, height: height)
    }
    
    override open func prepare() {
        super.prepare()
        
   //     let centerX = collectionView!.bounds.width/2 - 100
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        for i in 0..<collectionView!.numberOfItems(inSection: 0) {
            let attribute = CollectionLaytoutAttributes(forCellWith: IndexPath(item: i, section: 0))
           
            let xOffset = CGFloat(i)*self.size.width //+ self.size.width/2
            let yOffset = self.collectionView!.bounds.minY
            
            let frame = CGRect(x: xOffset, y: yOffset, width: self.size.width, height: self.size.height)
           // attribute.size = self.size
           // attribute.center = CGPoint(x: xOffset , y: self.collectionView!.bounds.midY)
            attribute.frame = frame.insetBy(dx: 5, dy: 0)
            cache.append(attribute)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        return attributes.map({ self.transformLayoutAttributes($0) })
    }
    
    fileprivate func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }
        
        let collectionCenter = collectionView.frame.size.width/2
        let offset = collectionView.contentOffset.x
        let normalizedCenter = attributes.center.x - offset
        let maxDistance = self.size.width + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance)/maxDistance
        
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        
        
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.zIndex = Int(scale * 80)
        attributes.center.y = attributes.center.y
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> CollectionLaytoutAttributes? {
        return self.cache[indexPath.item]
    }
}







