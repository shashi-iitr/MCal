//
//  PushAnimator.swift
//  MCalApp
//
//  Created by shashi kumar on 29/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewContr = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! ViewController
        let toViewContr = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        transitionContext.containerView.addSubview((toViewContr?.view)!)
        toViewContr?.view.alpha = 1
        toViewContr?.view.frame = fromViewContr.referenceFrame
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            toViewContr?.view.alpha = 1
            toViewContr?.view.frame = UIScreen.main.bounds
        }) { (success) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

}
