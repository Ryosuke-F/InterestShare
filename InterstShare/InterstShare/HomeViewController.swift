//
//  HomeViewController.swift
//  InterstShare
//
//  Created by Ryosuke Fukuda on 7/17/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var currentUserProfileImageButton: UIButton!
    @IBOutlet weak var currentUserFullNameButton: UIButton!
    
    //MARK: - UICollectionViewDataSource
    private var interests = Interest.createInterests()
    private var slideRightTransitionAnimator = SlideRIghtTransitionAnimator()
    
    //Making the status bar white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUserProfileImageButton.layer.cornerRadius = currentUserProfileImageButton.bounds.width/2
        currentUserProfileImageButton.layer.masksToBounds = true
        
        
        if UIScreen.mainScreen().bounds.size.height == 480.0 {
            
            let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = CGSizeMake(250.0, 300.0)
        }
        
    }
    
    private struct Storyboard {
        static let CellIdentifier = "Interest Cell"
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Interest" {
            let cell = sender as! InterestCollectionViewCell
            let interest = cell.interest
            
            let navigationViewController = segue.destinationViewController as! UINavigationController
            let interestViewController = navigationViewController.topViewController as! InterestViewController
            interestViewController.interest = interest
        }
        
//        } else if segue.identifier == "Create New Interest" {
//            let newInterestViewController = segue.destinationViewController as! NewInterestViewController
//            
//            newInterestViewController.transitioningDelegate = slideRightTransitionAnimator
//            
//        }
    }

    
}


extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return interests.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath) as! InterestCollectionViewCell
        
        cell.interest =  self.interests[indexPath.item]
        
        return cell
        
    }

}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        //Use the minimamLineSpacing when the collectionView is holizantolly.
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        //memory gives CGRect.
        var offset = targetContentOffset.memory
        
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        //it can not only give but also get it.
        targetContentOffset.memory = offset
        
    }
    
}



















