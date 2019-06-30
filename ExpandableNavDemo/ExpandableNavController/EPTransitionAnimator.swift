//
//  EPTransitionAnimator.swift
//
//  Created by Paige Sun on 2019-06-18.
//

import UIKit

protocol EPViewCountrollerCountable: class {
    func viewControllersCount() -> Int
}

class EPTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let presenting: Bool
    private let toNavDelegate: EPNavControllerDelegate?
    private let fromNavDelegate: EPNavControllerDelegate?
    private let supplimentaryViewContainer: UIView
    private let containerHeightConstraint: NSLayoutConstraint
    private let navBar: EPNavBarView
    private weak var viewControllerCountable: EPViewCountrollerCountable?
    
    private let animationDuration: TimeInterval = 0.3
    private let animationOptions: UIView.AnimationOptions = .curveEaseOut
    private var isAnimating = true
    
    init(presenting: Bool,
         toNavDelegate: EPNavControllerDelegate?,
         fromNavDelegate: EPNavControllerDelegate?,
         supplimentaryViewContainer: UIView,
         containerHeightConstraint: NSLayoutConstraint,
         navBar: EPNavBarView,
         viewControllerCountable: EPViewCountrollerCountable) {
        self.presenting = presenting
        self.toNavDelegate = toNavDelegate
        self.fromNavDelegate = fromNavDelegate
        self.supplimentaryViewContainer = supplimentaryViewContainer
        self.containerHeightConstraint = containerHeightConstraint
        self.navBar = navBar
        self.viewControllerCountable = viewControllerCountable
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using context: UIViewControllerContextTransitioning) {
        isAnimating = true
        
        guard let fromView = context.view(forKey: .from) else { return }
        guard let toView = context.view(forKey: .to) else { return }
        
        let shadowedView = presenting ? toView : fromView
        setShadow(on: shadowedView)
        
        animateHorizontalTransition(
            transitionContainer: context.containerView,
            toView: toView,
            fromView: fromView) { [weak self] completed in
                context.completeTransition(!context.transitionWasCancelled)
                self?.isAnimating = false
        }
        
        animateContainerHeight(
            toHeight: toNavDelegate?.supplementary().containerHeight ?? EPNavController.appearance.navCornerRadius,
            fromHeight: fromNavDelegate?.supplementary().containerHeight ?? EPNavController.appearance.navCornerRadius,
            using: context)
        
        for oldSubview in supplimentaryViewContainer.subviews {
            fadeOutAndRemoveOnSuccess(oldSubview, using: context)
        }
        for oldSubview in navBar.centerSubviews {
            fadeOutAndRemoveOnSuccess(oldSubview, using: context)
        }
        
        let vcCount = viewControllerCountable?.viewControllersCount() ?? 0
        if vcCount <= 1 {
            fadeOutToRight(navBar.backButton, using: context, onSuccess: {})
        } else {
            fadeInToLeft(navBar.backButton, using: context, onSuccess: {})
        }
        
        if let toNavDelegate = toNavDelegate {
            if let newSupView = toNavDelegate
                .supplementary()
                .add(to: supplimentaryViewContainer) {
                newSupView.alpha = 0
                fadeInAndRemoveOnCancel(newSupView, using: context)
            }
            
            if let centerConfig = toNavDelegate.navBarCenter() {
                let navBarCenterView = navBar.addSubview(with: centerConfig)
                navBarCenterView.alpha = 0
                fadeInAndRemoveOnCancel(navBarCenterView, using: context)
            }
        }
    }
    
    private func setShadow(on view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: -5, height: 0)
        view.layer.shadowRadius = 10
    }
    
    // MARK: - Animate Main View Controller Horizontally
    
    private func animateHorizontalTransition(transitionContainer: UIView, toView: UIView, fromView: UIView, completion: @escaping (Bool) -> Void) {
        
        setupViewsForHorizontalTransition(container: transitionContainer,
                                          toView: toView,
                                          fromView: fromView)
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: animationOptions,
                       animations: horizontalTransitionAnimations(toView: toView, fromView: fromView),
                       completion: completion)
    }
    
    private func setupViewsForHorizontalTransition(container: UIView, toView: UIView, fromView: UIView) {
        let width = fromView.frame.width
        let height = fromView.frame.height
        let completeRightFrame = CGRect(x: width, y: 0, width: width, height: height)
        if presenting {
            container.addSubview(toView)
            toView.alpha = 1.0
            toView.frame = completeRightFrame
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }
    }
    
    private func horizontalTransitionAnimations(toView: UIView, fromView: UIView) -> () -> Void {
        let width = fromView.frame.width
        let height = fromView.frame.height
        let centerFrame = CGRect(x: 0, y: 0, width: width, height: height)
        let completeLeftFrame = CGRect(x: -width, y: 0, width: width, height: height)
        let completeRightFrame = CGRect(x: width, y: 0, width: width, height: height)
        let transitionAnimations: (() -> Void) = { [weak self] in
            guard let presenting = self?.presenting else {return}
            
            if presenting {
                fromView.frame = completeLeftFrame
            } else {
                fromView.frame = completeRightFrame
            }
            toView.frame = centerFrame
        }
        return transitionAnimations
    }
    
    // MARK: - Animate Container Height
    
    private func animateContainerHeight(toHeight: CGFloat, fromHeight: CGFloat, using context: UIViewControllerContextTransitioning) {
        
        supplimentaryViewContainer.superview?.layoutIfNeeded()
        
        let animations: () -> Void = { [weak self] in
            self?.containerHeightConstraint.constant = toHeight
            self?.supplimentaryViewContainer.superview?.layoutIfNeeded()
        }
        let completion: (Bool) -> Void = { [weak self] _ in
            if context.transitionWasCancelled {
                self?.containerHeightConstraint.constant = fromHeight
            }
        }
        UIView.animate(withDuration: animationDuration, delay: 0, options: animationOptions, animations: animations, completion: completion)
    }
    
    // MARK: - Animate Fade In and Out
    
    private func fadeOutToRight(_ backButton: EPNavBarBackButton, using context: UIViewControllerContextTransitioning, onSuccess: @escaping () -> Void) {
        
        backButton.imageLabelConstraint.constant = 5
        backButton.superview?.layoutIfNeeded()

        let animations: () -> Void = {
            backButton.alpha = 0
            
            backButton.imageLabelConstraint.constant = 40
            backButton.superview?.layoutIfNeeded()
        }
        animateOut(using: context, animations: animations, onSuccess: onSuccess)
    }
    
    private func fadeInToLeft(_ backButton: EPNavBarBackButton, using context: UIViewControllerContextTransitioning, onSuccess: @escaping () -> Void) {

        let animations: () -> Void = {
            backButton.alpha = 1
            
            backButton.imageLabelConstraint.constant = 5
            backButton.superview?.layoutIfNeeded()
        }
        animateOut(using: context, animations: animations, onSuccess: onSuccess)
    }
    
    private func fadeOutAndRemoveOnSuccess(_ fromView: UIView, using context: UIViewControllerContextTransitioning) {
        animateOut(using: context,
                   animations: { fromView.alpha = 0 },
                   onSuccess: { fromView.removeFromSuperview() })
    }
    
    private func fadeInAndRemoveOnCancel(_ toView: UIView, using context: UIViewControllerContextTransitioning) {
        animateIn(using: context,
                  animations: { toView.alpha = 1 },
                  onCancel: { toView.removeFromSuperview() })
    }

    // MARK: - Generic Animate In and Out
    
    private func animateOut(using context: UIViewControllerContextTransitioning, animations: @escaping() -> Void, onSuccess: @escaping () -> Void) {
        let completion: (Bool) -> Void = { _ in
            if !context.transitionWasCancelled {
                onSuccess()
            }
        }
        UIView.animate(withDuration: animationDuration / 2, delay: 0, options: animationOptions, animations: animations, completion: completion)
    }
    
    private func animateIn(using context: UIViewControllerContextTransitioning, animations: @escaping () -> Void, onCancel: @escaping () -> Void) {
        let completion: (Bool) -> Void = { _ in
            if context.transitionWasCancelled {
                onCancel()
            }
        }
        UIView.animate(withDuration: animationDuration / 2, delay: animationDuration / 2, options: animationOptions, animations: animations, completion: completion)
    }
}

extension EPTransitionAnimator: EPEdgePanInteractorShouldBeginDelegate {
    func shouldBeginPanGesture() -> Bool {
        return !isAnimating
    }
}
