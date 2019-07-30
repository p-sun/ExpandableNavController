//
//  EPNavControllerAnimator.swift
//  TravelerWhitelabel
//
//  Created by Paige Sun on 2019-07-30.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import UIKit

class EPNavControllerAnimator {
    
    private static var backButtonStartingWidth: CGFloat = 0
    
    let animationDuration: TimeInterval
    
    private let navBar: EPNavBar
    private let supplementaryContainer: UIView
    private let containerHeightConstraint: NSLayoutConstraint
    private weak var viewControllerCountable: EPViewCountrollerCountable?
    
    private let toNavDelegate: EPNavControllerDelegate?
    private let fromNavDelegate: EPNavControllerDelegate?
    
    init(navBar: EPNavBar,
         supplementaryContainer: UIView,
         containerHeightConstraint: NSLayoutConstraint,
         viewControllerCountable: EPViewCountrollerCountable,
         toNavDelegate: EPNavControllerDelegate?,
         fromNavDelegate: EPNavControllerDelegate?,
         animated: Bool) {
        self.navBar = navBar
        self.supplementaryContainer = supplementaryContainer
        self.containerHeightConstraint = containerHeightConstraint
        self.viewControllerCountable = viewControllerCountable
        
        self.toNavDelegate = toNavDelegate
        self.fromNavDelegate = fromNavDelegate
        
        animationDuration = animated ? 0.3 : 0
    }
    
    // MARK: - Public
    
    func startAnimation(animationSteps: [AnimationStep] = [], context: UIViewControllerContextTransitioning? = nil) {
        let fadeOutOldSubviewsSteps = fadeAndRemoveSubviews(
            supplementaryContainer.subviews,
            navBar.centerContent.subviews,
            navBar.leftContent.subviews,
            navBar.rightContent.subviews)
        
        let (backButtonWidth, backButtonStep) = animateBackButton()
        let (animateInSteps, leftWidth, rightWidth) = animateInContents()
        let centerWidth = navBar.frame.width - 60 -
            max(leftWidth, rightWidth, backButtonWidth) * 2
        let navBarCenterWidthStep = animateCenterWidth(toWidth: max(0, centerWidth))
        
        let animateOutSteps = fadeOutOldSubviewsSteps + [backButtonStep]
        let animateSizeSteps =  [containerHeightStep(), navBarCenterWidthStep]
        
        // Change this method if you want to animate elements separately
        animateAll(fullDurationSteps: animationSteps + animateInSteps + animateSizeSteps + animateInSteps + animateOutSteps,
                   animateOutSteps: [],
                   animateInSteps: [],
                   using: context)
    }
    
    // MARK: - Animate in Supplementary view, left, right, and center contents
    
    private func animateInContents() -> (animationSteps: [AnimationStep], leftWidth: CGFloat, rightWidth: CGFloat)  {
        
        var animateInSteps = [AnimationStep]()
        
        if let newSupView = toNavDelegate?.supplementary()
            .add(to: supplementaryContainer) {
            newSupView.alpha = 0
            let step = fadeInAndRemoveOnCancel(newSupView)
            animateInSteps.append(step)
        }
        
        if let center = toNavDelegate?.navBarCenter() {
            navBar.setCenter(center)
            if let newView = center.view.superview {
                newView.alpha = 0
                let step = fadeInAndRemoveOnCancel(newView)
                animateInSteps.append(step)
            }
        }
        
        var leftWidth: CGFloat = 0
        if let barButtonItem = toNavDelegate?.navBarLeft() {
            navBar.setLeftBarButtonItem(barButtonItem)
            leftWidth = barButtonItem.button.intrinsicContentSize.width

            if let newView = barButtonItem.button.superview {
                newView.alpha = 0
                let step = fadeInAndRemoveOnCancel(newView)
                animateInSteps.append(step)
            }
        }
        
        var rightWidth: CGFloat = 0
        if let barButtonItem = toNavDelegate?.navBarRight() {
            navBar.setRightBarButtonItem(barButtonItem)
            rightWidth = barButtonItem.button.intrinsicContentSize.width

            if let newView = barButtonItem.button.superview {
                newView.alpha = 0
                let step = fadeInAndRemoveOnCancel(newView)
                animateInSteps.append(step)
            }
        }
        
        return (animateInSteps, leftWidth, rightWidth)
    }
    
    // MARK: - Fade Out Old Subviews
    
    private func fadeAndRemoveSubviews(_ subviewsArray: [UIView]...) -> [AnimationStep] {
        var steps = [AnimationStep]()
        for subviews in subviewsArray {
            for subview in subviews {
                let step = fadeOutAndRemoveOnSuccess(subview)
                steps.append(step)
            }
        }
        return steps
    }
    
    // MARK: - Animate Container Height
    
    private func containerHeightStep() -> AnimationStep {
        let toHeight = toNavDelegate?.supplementary().containerHeight ??
            EPNavController.appearance.navCornerRadius
        let fromHeight = fromNavDelegate?.supplementary().containerHeight ??
            EPNavController.appearance.navCornerRadius
        supplementaryContainer.superview?.layoutIfNeeded()
        
        return AnimationStep(
            onAnimation: { [weak self] in
                self?.containerHeightConstraint.constant = toHeight
                self?.supplementaryContainer.superview?.setNeedsLayout()
                self?.supplementaryContainer.superview?.layoutIfNeeded()
            }, onCancel: { [weak self] in
                self?.containerHeightConstraint.constant = fromHeight
            }, onSuccess: nil)
    }
    
    // MARK: - Animate Nav Bar's Center Width
    
    private func animateCenterWidth(toWidth: CGFloat) -> AnimationStep {
        guard let centerWidthConstraint = navBar.centerWidthConstraint else {
            return AnimationStep(onAnimation: {}, onCancel: nil, onSuccess: nil)
        }
        let fromWidth = centerWidthConstraint.constant
        navBar.superview?.layoutIfNeeded()
        
        return AnimationStep(
            onAnimation: {
                centerWidthConstraint.constant = toWidth
                self.navBar.superview?.layoutIfNeeded()
                
        }, onCancel: {
            centerWidthConstraint.constant = fromWidth
            guard toWidth != fromWidth else { return }
            for subview in self.navBar.centerContent.subviews {
                self.sizeToFitLabels(subview)
            }
        }, onSuccess: nil)
    }
    
    private func sizeToFitLabels(_ root: UIView) {
        if let _ = root as? UILabel {
            root.sizeToFit()
        }
        for subview in root.subviews {
            sizeToFitLabels(subview)
        }
    }
    
    // MARK: - Animate Back Button
    
    
    private func animateBackButton() -> (backButtonWidth: CGFloat, animationStep: AnimationStep) {
        
        let vcCount = viewControllerCountable?.viewControllersCount() ?? 0
        if vcCount <= 1 || toNavDelegate?.navBarLeft() != nil {
            return (0, fadeOutToRight(navBar.backButton))
        } else {
            // Back button can shrink and expand, we only want the collpsed width
            if EPNavControllerAnimator.backButtonStartingWidth == 0 {
                EPNavControllerAnimator.backButtonStartingWidth = navBar.backButton.frame.width
            }
            return (EPNavControllerAnimator.backButtonStartingWidth, fadeInToLeft(navBar.backButton))
        }
    }
    
    private func fadeOutToRight(_ backButton: EPNavBarBackButton) -> AnimationStep {
        return AnimationStep(onAnimation: {
            backButton.alpha = 0
            
            backButton.imageLabelConstraint.constant = 40
            backButton.superview?.layoutIfNeeded()
        }, onCancel: {
            backButton.imageLabelConstraint.constant = 5
        },
           onSuccess: nil)
    }
    
    private func fadeInToLeft(_ backButton: EPNavBarBackButton) -> AnimationStep {
        let oldConstant = backButton.imageLabelConstraint.constant
        return AnimationStep(
            onAnimation: {
                backButton.alpha = 1
                
                backButton.imageLabelConstraint.constant = 5
                backButton.superview?.layoutIfNeeded()
        }, onCancel: {
            backButton.imageLabelConstraint.constant = oldConstant
        },
           onSuccess: nil)
    }
    
    // MARK: - Generic Fade Animations
    
    private func fadeOutAndRemoveOnSuccess(_ fromView: UIView) -> AnimationStep {
        return AnimationStep(
            onAnimation: {
                fromView.alpha = 0 },
            onCancel: nil,
            onSuccess: {
                fromView.removeFromSuperview()
        })
    }
    
    private func fadeInAndRemoveOnCancel(_ toView: UIView) -> AnimationStep {
        return AnimationStep(
            onAnimation: {
                toView.alpha = 1
        }, onCancel: {
            toView.removeFromSuperview()
        }, onSuccess: nil)
    }
    
    // MARK: - Animate All Steps with one UIView.animateKeyframes
    
    private func animateAll(fullDurationSteps: [AnimationStep],
                            animateOutSteps: [AnimationStep],
                            animateInSteps: [AnimationStep],
                            using context: UIViewControllerContextTransitioning?) {
        
        UIView.animateKeyframes(
            withDuration: animationDuration, delay: 0, options: [],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                    fullDurationSteps.forEach { $0.onAnimation() }
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    animateOutSteps.forEach { $0.onAnimation() }
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    animateInSteps.forEach { $0.onAnimation() }
                })
        },
            completion: { _ in
                if let context = context, context.transitionWasCancelled {
                    animateOutSteps.forEach { $0.onCancel?() }
                    animateInSteps.forEach { $0.onCancel?() }
                    fullDurationSteps.forEach { $0.onCancel?() }
                } else {
                    animateOutSteps.forEach { $0.onSuccess?() }
                    animateInSteps.forEach { $0.onSuccess?() }
                    fullDurationSteps.forEach { $0.onSuccess?() }
                }
        })
    }
}
