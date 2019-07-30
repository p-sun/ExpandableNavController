//
//  EPTransitionAnimator.swift
//
//  Created by Paige Sun on 2019-06-18.
//

import UIKit

protocol EPViewCountrollerCountable: class {
    func viewControllersCount() -> Int
}

struct AnimationStep {
    let onAnimation: () -> Void
    let onCancel: (() -> Void)?
    let onSuccess: (() -> Void)?
}

class EPTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let presenting: Bool
    
    private let controllerAnimator: EPNavControllerAnimator
    private var isAnimating = true
    
    init(presenting: Bool,
         controllerAnimator: EPNavControllerAnimator) {
        
        self.presenting = presenting
        self.controllerAnimator = controllerAnimator
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {
        return controllerAnimator.animationDuration
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
        
        controllerAnimator.startAnimation(animationSteps: [horizontalTransitionStep], context: context)
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
    
    // MARK: - Set Shadows on the View Controller Left Edge
    
    private func setShadow(on view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: -5, height: 0)
        view.layer.shadowRadius = 10
    }
}

extension EPTransitionAnimator: EPEdgePanInteractorShouldBeginDelegate {
    func shouldBeginPanGesture() -> Bool {
        return !isAnimating
    }
}
