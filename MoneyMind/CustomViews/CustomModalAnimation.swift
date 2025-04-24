//
//  CustomModalAnimation.swift
//  MoneyMind
//
//  Created by Павел on 22.04.2025.
//

import UIKit

final class CustomModalAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: isPresenting ? .to : .from)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        
        if isPresenting {
            containerView.addSubview(toView)
            toView.alpha = 0
            toView.transform = CGAffineTransform(translationX: 0, y: 100)
            
            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
            animations: {
                toView.alpha = 1
                toView.transform = .identity
            },
            completion: { finished in
                transitionContext.completeTransition(finished)
            }
            )
        } else {
            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                animations: {
                    toView.alpha = 0
                    toView.transform = CGAffineTransform(translationX: 0, y: 100)
                },
                completion: { finished in
                    toView.removeFromSuperview()
                    transitionContext.completeTransition(finished)
                }
            )
        }
    }
}
