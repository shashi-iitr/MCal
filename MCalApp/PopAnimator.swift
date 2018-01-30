//
//  PopAnimator.swift
//  MCalApp
//
//  Created by shashi kumar on 29/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewContr = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromViewContr = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)

        transitionContext.containerView.insertSubview((toViewContr?.view)!, belowSubview: (fromViewContr?.view)!)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            fromViewContr?.view.alpha = 0
        }) { (success) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

}
