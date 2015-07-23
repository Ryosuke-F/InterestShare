//
//  SlideRIghtTransitionAnimator.swift
//  InterstShare
//
//  Created by Ryosuke Fukuda on 7/22/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit

class SlideRIghtTransitionAnimator: NSObject {
    
    var duration = 1.0
    private var isPresenting = false
    
}

extension SlideRIghtTransitionAnimator: UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = false
        return self
    }

}


extension SlideRIghtTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let containerView = transitionContext.containerView() as UIView
        
        
        let offscreenLeft = CGAffineTransformMakeTranslation(-containerView.frame.width, 0)
        let minimaize = CGAffineTransformMakeScale(0, 0)
        let shiftDown = CGAffineTransformMakeTranslation(0, 15)
        let scaleDown = CGAffineTransformScale(shiftDown, 0.8, 0.8)
        
        if isPresenting {
            
            let minimizeAndOffscreenLeft = CGAffineTransformConcat(minimaize, offscreenLeft)
            toView.transform = minimizeAndOffscreenLeft
        }
        
        
        if isPresenting {
            
            containerView.addSubview(fromView)
            containerView.addSubview(toView)
        } else {
            
            containerView.addSubview(toView)
            containerView.addSubview(fromView)
        }
        
        //Animation 
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: nil, animations: { () -> Void in
            
            if self.isPresenting {
                
                fromView.transform = scaleDown
                fromView.alpha = 0.5
                toView.transform = CGAffineTransformIdentity
                
            } else {
                
                fromView.transform = offscreenLeft
                toView.alpha = 1.0
                toView.transform = CGAffineTransformIdentity
                
            }
            
        }) { (finished) -> Void in
            
            if finished {
                
                transitionContext.completeTransition(true)
            }
            
        }
        
    }
    
}








































