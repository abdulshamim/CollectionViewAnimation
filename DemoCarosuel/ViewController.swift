//
//  ViewController.swift
//  DemoCarosuel
//
//  Created by cl-macmini-23 on 13/02/18.
//  Copyright © 2018 cl-macmini-23. All rights reserved.
//

import UIKit

enum BookingSteps: Int {
    case truckSize
    case truckType
    case truckCapacity
    case helper
    
    static func rawValue(type: Int) -> BookingSteps? {
        switch type {
        case 0:
            return .truckSize
        case 1:
            return .truckType
        case 2:
            return .truckCapacity
        case 3:
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
    
    var touchCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.firstSelectedView.isHidden = true
        self.secondSelectedView.isHidden = true
        self.thirdSelectedView.isHidden = true
        self.fourthSelectedView.isHidden = true
    }
    
    func setLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height:80)
        layout.scrollDirection = .horizontal
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        collectionView.collectionViewLayout = layout
        layout.minimumInteritemSpacing = 20
        //collectionView.isPagingEnabled = true
    }
    
    
    
    private func makeRound(of view: UIView) {
        view.layer.cornerRadius  = self.firstSelectedView.bounds.height/2
        view.layer.masksToBounds = true
        view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }


    private func initialTransform(from index: Int) {
        if index == 0 {
            self.firstSelectedView.transform = CGAffineTransform(scaleX: 0, y: 0)
        } else if index == 1 {
            self.secondSelectedView.transform = CGAffineTransform(scaleX: 0, y: 0)
        } else if index == 2 {
            self.thirdSelectedView.transform = CGAffineTransform(scaleX: 0, y: 0)
        } else if index == 3 {
            self.fourthSelectedView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
    }
    
    private func animateView(from index: Int, frame: CGRect, cell: BookingCell) {
        let view = UIImageView()
        view.frame = frame
//        view.layer.cornerRadius  = view.bounds.height/2
//        view.layer.masksToBounds = true
        view.image = cell.imageView.screenshot()
        print(self.containerView.frame.origin)
        UIView.animate(withDuration: 0.8, animations: {
            self.touchCount += 1
            if self.touchCount == 1 {
                print(self.firstSelectedView.frame.origin)
                self.firstSelectedView.frame.origin.x += self.containerView.frame.origin.x
                self.firstSelectedView.frame.origin.y += self.containerView.frame.origin.y
                view.frame = self.firstSelectedView.frame
            } else if self.touchCount == 2 {
                self.secondSelectedView.frame.origin.x += self.containerView.frame.origin.x
                self.secondSelectedView.frame.origin.y += self.containerView.frame.origin.y
                view.center = self.secondSelectedView.center
            } else if self.touchCount == 3 {
                self.thirdSelectedView.frame.origin.x += self.containerView.frame.origin.x
                self.thirdSelectedView.frame.origin.y += self.containerView.frame.origin.y
                view.center = self.thirdSelectedView.center
            } else if self.touchCount == 4 {
                self.fourthSelectedView.frame.origin.x += self.containerView.frame.origin.x
                self.fourthSelectedView.frame.origin.y += self.containerView.frame.origin.y 
                view.center = self.fourthSelectedView.center
            }
            if self.touchCount <= 4 {
                view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.view.addSubview(view)
            }
        })
    }
    
    @IBAction func stepBackBooking(_ sender: UIButton) {
        
    }
}



extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCell", for: indexPath) as? BookingCell else {
            fatalError("Cell not found")
        }
       // cell.demoView.backgroundColor = UIColor.brown
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath)")
        guard let cell = collectionView.cellForItem(at: indexPath) as? BookingCell else {
            fatalError("Cell not found")
        }
        let celllayout = collectionView.layoutAttributesForItem(at: indexPath)
        var frame = celllayout?.frame
        frame?.origin.y += collectionView.frame.origin.y + self.firstSelectedView.bounds.height/2
        frame?.origin.x += collectionView.frame.origin.x + self.firstSelectedView.bounds.width/2
        self.animateView(from: indexPath.row, frame: frame!, cell: cell)
    }
}
