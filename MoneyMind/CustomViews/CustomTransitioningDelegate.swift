//
//  CustomTransitioningDelegate.swift
//  MoneyMind
//
//  Created by Павел on 18.04.2025.
//

import UIKit

final class CustomTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return CustomHeightPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        CustomModalAnimation(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        CustomModalAnimation(isPresenting: false)
    }
}
