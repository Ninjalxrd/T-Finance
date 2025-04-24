//
//  CustomHeightPresentationController.swift
//  MoneyMind
//
//  Created by Павел on 17.04.2025.
//

import UIKit
import SnapKit

final class CustomHeightPresentationController: UIPresentationController {
    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.35)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
 
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let height = UIScreen.main.bounds.height / 2.5
        
        return CGRect(
            x: 0,
            y: containerView.bounds.height - height,
            width: containerView.bounds.width,
            height: height
        )
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        guard let container = containerView else { return }
        bgView.frame = container.bounds
        
        if let presented = presentedView {
            presented.frame = frameOfPresentedViewInContainerView
        }
    }
    
    override func presentationTransitionWillBegin() {
        setupUI()
        bgView.alpha = 0

        containerView?.insertSubview(bgView, at: 0)

        presentedViewController.transitionCoordinator?.animate { _ in
            self.bgView.alpha = 1
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChange),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillChange(notification: Notification) {
        guard
            let containerView = containerView,
            let userInfo = notification.userInfo,
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        
        let keyboardHeight = containerView.convert(endFrame, from: nil).intersection(containerView.bounds).height
        
        let bottomInset = keyboardHeight > 0 ? keyboardHeight : 0
        let targetY = containerView.bounds.height - bottomInset - (UIScreen.main.bounds.height / 2.5)
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve << 16)
        ) {
            self.presentedView?.frame.origin.y = targetY
        }
    }
    
    override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
        } completion: { _ in
            self.bgView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    private lazy var downSwipeGestureRecognizer: UISwipeGestureRecognizer = {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(downSwipeAction))
        swipeRecognizer.direction = .down
        swipeRecognizer.delegate = self
        swipeRecognizer.cancelsTouchesInView = false
        return swipeRecognizer
    }()
    
    @objc func downSwipeAction() {
        self.presentedViewController.dismiss(animated: true)
    }
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        return tap
    }()

    @objc func tapAction() {
        self.presentedViewController.dismiss(animated: true)
    }
}

private extension CustomHeightPresentationController {
    func setupUI() {
        guard let container = containerView, let presented = presentedView else { return }
        container.addSubview(bgView)
        container.addSubview(bgView)
        
        bgView.frame = container.bounds
        bgView.alpha = 0

        container.addSubview(presented)
        presented.translatesAutoresizingMaskIntoConstraints = false
                        
        setupLayout()
        bgView.addGestureRecognizer(downSwipeGestureRecognizer)
        bgView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupLayout() {
        guard let container = containerView, let presented = presentedView else { return }
        bgView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        let height = container.bounds.height / 2.5
        presented.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(height)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CustomHeightPresentationController:
    UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
