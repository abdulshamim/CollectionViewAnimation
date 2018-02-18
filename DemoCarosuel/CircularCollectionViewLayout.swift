//
//  CircularCollectionViewLayout.swift
//  CircularCollectionView
//
//  Created by Abdul Shamim on 2/8/18.
//  Copyright © 2018 Rounak Jain. All rights reserved.
//

import UIKit


class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
  // 1
  var anchorPoint = CGPoint(x: 0.5, y: 0.5)
  var angle: CGFloat = 0 {
    // 2
    didSet {
      zIndex = Int(angle * 1000000)
      transform = CGAffineTransform(rotationAngle: angle)
    }
  }
  
  override func copy(with zone: NSZone? = nil) -> Any {
    let copiedAttributes: CircularCollectionViewLayoutAttributes = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
  
  //  copiedAttributes.anchorPoint = self.anchorPoint
   // copiedAttributes.angle = self.angle
    return copiedAttributes
  }
  
}

class CircularCollectionViewLayout: UICollectionViewLayout {
  
  let itemSize = CGSize(width: 100, height: 100)
  
  var angleAtExtreme: CGFloat {
    return collectionView!.numberOfItems(inSection: 0) > 0 ?
      -CGFloat(collectionView!.numberOfItems(inSection: 0) - 1) * anglePerItem : 0
  }
  var angle: CGFloat {
    return angleAtExtreme * collectionView!.contentOffset.x / (collectionViewContentSize.width - (collectionView?.bounds.width)!)
  }
  
  var radius: CGFloat = 400 {
    didSet {
      invalidateLayout()
    }
  }
  
  var anglePerItem: CGFloat {
    return atan(itemSize.width / radius)
  }
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0)) * itemSize.width,
                  height: (collectionView?.bounds.height)!)
  }
  
  override class var layoutAttributesClass: AnyClass {
    return CircularCollectionViewLayoutAttributes.self
  }

  var attributesList = [CircularCollectionViewLayoutAttributes]()
  
  
  override func prepare() {
    super.prepare()
    
    let centerX = collectionView!.bounds.width/2 - 100
  //  let centerX = collectionView!.contentOffset.x + ((collectionView?.bounds.width)! / 2.0)
    let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
    
    // 1
    let theta = atan2(collectionView!.bounds.width / 2.0,
                      radius + (itemSize.height / 2.0) - (collectionView!.bounds.height / 2.0))
    print(theta)
    // 2
    var startIndex = 0
    var endIndex = collectionView!.numberOfItems(inSection: 0) - 1
    // 3
    if (angle < -theta) {
      startIndex = Int(floor((-theta - angle) / anglePerItem))
    }
    // 4
    endIndex = min(endIndex, Int(ceil((theta - angle) / anglePerItem)))
    // 5
    if (endIndex < startIndex) {
      endIndex = 0
      startIndex = 0
    }
    collectionView?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    //collectionView.
    attributesList = (startIndex...endIndex).map { (i)
      -> CircularCollectionViewLayoutAttributes in
      // 1
      let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
      attributes.size = self.itemSize

      // 2
      attributes.center = CGPoint(x: CGFloat(i+1) * self.itemSize.width, y: self.collectionView!.bounds.midY)
      // 3
//      attributes.angle = self.angle + (self.anglePerItem * CGFloat(i))
//        print(self.angle)
//        print( attributes.angle )
//        print(anchorPointY)
//      attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
      
      return attributes
    }
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//    var result = [CircularCollectionViewLayoutAttributes]()
//    if let attributes = super.layoutAttributesForElements(in: rect) {
//      for item in attributes {
//        let cellAttributes = item.copy() as! CircularCollectionViewLayoutAttributes
//        if item .representedElementKind == nil {
//          let frame = cellAttributes.frame
//          cellAttributes.frame = frame.insetBy(dx: 10, dy: 10)
//        }
//        result.append(cellAttributes)
//      }
//    }
//    attributesList = result
    return attributesList
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return attributesList[indexPath.row]
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return false
  }
}





