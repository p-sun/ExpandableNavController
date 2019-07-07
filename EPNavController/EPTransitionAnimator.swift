//
//  EPTransitionAnimator.swift
//
//  Created by Paige Sun on 2019-06-18.
//

import UIKit

protocol EPViewCountrollerCountable: class {
    func viewControllersCount() -> Int
}

private struct AnimationStep {
    let onAnimation: () -> Void
    let onCancel: (() -> Void)?
    let onSuccess: (() -> Void)?
}

class EPTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let presenting: Bool
    private let toNavDelegate: EPNavControllerDelegate?
    private let fromNavDelegate: EPNavControllerDelegate?
    private let supplimentaryViewContainer: UIView
    private let containerHeightConstraint: NSLayoutConstraint
    private let navBar: EPNavBar
    private weak var viewControllerCountable: EPViewCountrollerCountable?
    
    private let animationDuration: TimeInterval = 0.3
    private var isAnimating = true
    
    init(presenting: Bool,
         toNavDelegate: EPNavControllerDelegate?,
         fromNavDelegate: EPNavControllerDelegate?,
         supplimentaryViewContainer: UIView,
         containerHeightConstraint: NSLayoutConstraint,
         navBar: EPNavBar,
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
        
        let horizontalTransitionStep: AnimationStep = animateHorizontalTransition(
            transitionContainer: context.containerView,
            toView: toView,
            fromView: fromView) { [weak self] in
                context.completeTransition(!context.transitionWasCancelled)
                self?.isAnimating = false
        }
        
        let fadeOutOldSubviewsSteps = fadeAndRemoveSubviews(supplimentaryViewContainer.subviews,
                                                       navBar.centerSubviews,
                                                       navBar.leftSubviews,
                                                       navBar.rightSubviews)
        
        let (backButtonWidth, backButtonStep) = animateBackButton()
        let (animateInSteps, leftWidth, rightWidth) = animateInContents()
        let centerWidth = navBar.frame.width - 60 -
            max(leftWidth, rightWidth, backButtonWidth) * 2
        let navBarCenterWidthStep = animateCenterWidth(toWidth: max(0, centerWidth))
        
        let animateOutSteps = fadeOutOldSubviewsSteps + [backButtonStep]
        let animateSizeSteps =  [containerHeightStep(), navBarCenterWidthStep]
        
        // Change this method if you want to animate elements separately
        animateAll(fullDurationSteps: [horizontalTransitionStep] + animateSizeSteps + animateInSteps + animateOutSteps,
                   animateOutSteps: [],
                   animateInSteps: [],
                   using: context)
    }
    
    // MARK: - Set Shadows on the View Controller Left Edge
    
    private func setShadow(on view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: -5, height: 0)
        view.layer.shadowRadius = 10
    }
    
    // MARK: - Animate in Supplementary view, left, right, and center contents
    
    private func animateInContents() -> (animationSteps: [AnimationStep], leftWidth: CGFloat, rightWidth: CGFloat)  {
        
        var animateInSteps = [AnimationStep]()
        
        if let newSupView = toNavDelegate?.supplementary()
            .add(to: supplimentaryViewContainer) {
            newSupView.alpha = 0
            let step = fadeInAndRemoveOnCancel(newSupView)
            animateInSteps.append(step)
        }
        
        if let center = toNavDelegate?.navBarCenter() {
            let newView = navBar.setCenter(center)
            newView.alpha = 0
            let step = fadeInAndRemoveOnCancel(newView)
            animateInSteps.append(step)
        }
        
        var leftWidth: CGFloat
        if let barButtonItem = toNavDelegate?.navBarLeft() {
            let newView = navBar.setLeftBarButtonItem(barButtonItem)
            newView.alpha = 0
            leftWidth = newView.intrinsicContentSize.width
            let step = fadeInAndRemoveOnCancel(newView)
            animateInSteps.append(step)
        } else {
            leftWidth = 0
        }
        
        var rightWidth: CGFloat
        if let barButtonItem = toNavDelegate?.navBarRight() {
            let newView = navBar.setRightBarButtonItem(barButtonItem)
            newView.alpha = 0
            rightWidth = newView.intrinsicContentSize.width
            let step = fadeInAndRemoveOnCancel(newView)
            animateInSteps.append(step)
        } else {
            rightWidth = 0
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
    
    // MARK: - Animate Main View Controller Horizontally
    
    private func animateHorizontalTransition(transitionContainer: UIView, toView: UIView, fromView: UIView, completion: @escaping () -> Void) -> AnimationStep {
        
        setupViewsForHorizontalTransition(container: transitionContainer,
                                          toView: toView,
                                          fromView: fromView)
        
        let onAnimation = horizontalTransitionAnimations(toView: toView,
                                                         fromView: fromView)
        
        return AnimationStep(onAnimation: onAnimation,
                             onCancel: completion,
                             onSuccess: completion)
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
    
    private func containerHeightStep() -> AnimationStep {
        let toHeight = toNavDelegate?.supplementary().containerHeight ??
            EPNavController.appearance.navCornerRadius
        let fromHeight = fromNavDelegate?.supplementary().containerHeight ??
            EPNavController.appearance.navCornerRadius
        supplimentaryViewContainer.superview?.layoutIfNeeded()
        
        return AnimationStep(
            onAnimation: { [weak self] in
                self?.containerHeightConstraint.constant = toHeight
                self?.supplimentaryViewContainer.superview?.setNeedsLayout()
                self?.supplimentaryViewContainer.superview?.layoutIfNeeded()
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
                for subview in self.navBar.centerSubviews {
                    subview.sizeToFit()
                }
            }, onSuccess: nil)
    }
    
    // MARK: - Animate Back Button
    
    private static var backButtonStartingWidth: CGFloat = 0
    
    private func animateBackButton() -> (backButtonWidth: CGFloat, animationStep: AnimationStep) {
        
        let vcCount = viewControllerCountable?.viewControllersCount() ?? 0
        if vcCount <= 1 || toNavDelegate?.navBarLeft() != nil {
            return (0, fadeOutToRight(navBar.backButton))
        } else {
            // Back button can shrink and expand, we only want the collpsed width
            if EPTransitionAnimator.backButtonStartingWidth == 0 {
                EPTransitionAnimator.backButtonStartingWidth = navBar.backButton.frame.width
            }
            return (EPTransitionAnimator.backButtonStartingWidth, fadeInToLeft(navBar.backButton))
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
                            using context: UIViewControllerContextTransitioning) {
        
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
                if context.transitionWasCancelled {
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

extension EPTransitionAnimator: EPEdgePanInteractorShouldBeginDelegate {
    func shouldBeginPanGesture() -> Bool {
        return !isAnimating
    }
}
