//
//  ViewController.swift
//  DemoCarosuel
//
//  Created by cl-macmini-23 on 13/02/18.
//  Copyright © 2018 cl-macmini-23. All rights reserved.
//

import UIKit

enum BookingSteps: Int {
    case truckSize = 1
    case truckType = 2
    case truckCapacity = 3
    case helper = 4
    
    static func rawValue(_ type: Int) -> BookingSteps? {
        switch type {
        case BookingSteps.truckSize.rawValue:
            return .truckSize
        case BookingSteps.truckType.rawValue:
            return .truckType
        case BookingSteps.truckCapacity.rawValue:
            return .truckCapacity
        case BookingSteps.helper.rawValue:
            return .helper
        default:
            return nil
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var firstSelectedView: UIImageView!
    @IBOutlet weak var secondSelectedView: UIImageView!
    @IBOutlet weak var thirdSelectedView: UIImageView!
    @IBOutlet weak var fourthSelectedView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    var bookingStatus = 0
    
    var selectedCellsView = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.reloadData()
    }
    
    func setUpLayout() {
        if let layout = collectionView?.collectionViewLayout as? CollectionCellCustomLayout {
            //layout.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.firstSelectedView.isHidden  = true
        self.secondSelectedView.isHidden = true
        self.thirdSelectedView.isHidden  = true
        self.fourthSelectedView.isHidden = true
    }
    
    //MARK :- Take Snap shots of cell view and move to center postion of view
    private func animateView(from index: Int, frame: CGRect, cell: BookingCell) {
        let view = UIImageView()
        view.frame.size =  frame.size
        view.frame.origin = frame.origin
        view.contentMode = .scaleAspectFill
        view.image = cell.imageView.screenshot()
        
        UIView.animate(withDuration: 0.7, animations: {
            
            if self.bookingStatus == 0 {
                view.center = self.getCenterPosition(of: self.firstSelectedView)
            } else if self.bookingStatus == 1 {
                view.center = self.getCenterPosition(of: self.secondSelectedView)
            } else if self.bookingStatus == 2 {
                view.center = self.getCenterPosition(of: self.thirdSelectedView)
            } else if self.bookingStatus == 3 {
                view.center = self.getCenterPosition(of: self.fourthSelectedView)
            }
            if self.bookingStatus < 4 {
                view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.selectedCellsView.insert(view, at: self.bookingStatus)
                self.view.addSubview(view)
                self.bookingStatus += 1
                print(self.bookingStatus)
                
            }
        }) { (success) in
            
            
            self.collectionView.transform = CGAffineTransform(translationX: 0, y: +100)
            self.collectionView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            UIView.animate(withDuration: 0.8, animations: {
                self.collectionView.transform = CGAffineTransform.identity
            }) { success in
                if success {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    /// Get center point of argument view
    ///
    /// - Parameter view: view for which center is to be calculate
    /// - Returns: center point of view
    private func getCenterPosition(of view: UIImageView) -> CGPoint {
        var centerPostion = CGPoint()
        centerPostion.x = view.frame.origin.x + self.containerView.frame.origin.x + view.bounds.width/2
        centerPostion.y = view.frame.origin.y + self.containerView.frame.origin.y + view.bounds.height/2
        return centerPostion
    }
    
    @IBAction func stepBackBooking(_ sender: UIButton) {
        self.viewWillAppear(true)
        print(self.bookingStatus)
        guard let bookingStep: BookingSteps = BookingSteps.rawValue(self.bookingStatus) else {
            return
        }
        
        switch bookingStep {
        case .truckSize:
            self.removeSelectedViewWithAnimation(self.selectedCellsView[self.bookingStatus - 1])
        case .truckType:
            self.removeSelectedViewWithAnimation(self.selectedCellsView[self.bookingStatus - 1])
        case .truckCapacity:
            self.removeSelectedViewWithAnimation(self.selectedCellsView[self.bookingStatus - 1])
        case .helper:
            self.removeSelectedViewWithAnimation(self.selectedCellsView[self.bookingStatus - 1])
        }
    }
    
    
    private func removeSelectedViewWithAnimation(_ view: UIView) {
        
        UIView.animate(withDuration: 0.7, animations: {
            self.bookingStatus -= 1
            self.selectedCellsView.remove(at: self.bookingStatus)
            view.transform =  CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            if success {
                view.removeFromSuperview()
                if self.bookingStatus == 0 {
                    self.collectionView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    self.collectionView.reloadData()
                    UIView.animate(withDuration: 1, animations: {
                        self.collectionView.transform = CGAffineTransform.identity
                    })
                }
            }
        }
    }
}


extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let bookingStep: BookingSteps = BookingSteps.rawValue(self.bookingStatus+1) else {
            return 1
        }
        
        switch bookingStep {
        case .truckSize:
            return 4
        case .truckType:
            return 5
        case .truckCapacity:
            return 2
        case .helper:
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCell", for: indexPath) as? BookingCell else {
            fatalError("Cell not found")
        }
        //cell.demoView.backgroundColor = .clear
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BookingCell else {
            fatalError("Cell not found")
        }
    
        let celllayout = collectionView.layoutAttributesForItem(at: indexPath)
        var frame = celllayout?.frame
       
        let cellFrameInSuperview:CGRect!  = collectionView.convert(celllayout!.frame, to: collectionView.superview)
        print(cellFrameInSuperview)
        frame?.origin.x += collectionView.frame.origin.x
        frame?.origin.y += collectionView.frame.origin.y
        self.animateView(from: indexPath.row, frame: cellFrameInSuperview!, cell: cell)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        for (index, cell) in collectionView.visibleCells.enumerated() {
//            let indexPath = IndexPath(item: index, section: 0)
//             let celllayout = collectionView.layoutAttributesForItem(at: indexPath)
//            // print(celllayout?.center)
//        }
//    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}




