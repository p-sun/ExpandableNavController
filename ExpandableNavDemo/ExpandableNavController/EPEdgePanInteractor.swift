//
//  EPEdgePanInteractor.swift
//
//  Created by Paige Sun on 2019-06-18.
//

import UIKit

protocol EPEdgePanInteractorShouldBeginDelegate: class {
    func shouldBeginPanGesture() -> Bool
}

class EPEdgePanInteractor: UIPercentDrivenInteractiveTransition {
    
    var isActive: Bool = false
    
    weak var shouldBeginDelegate: EPEdgePanInteractorShouldBeginDelegate?
    
    private let transitionCompletionThreshold: CGFloat = 0.5
    private let nav: UINavigationController
    
    init(attachTo navController: UINavigationController) {
        self.nav = navController
        super.init()
        setupBackGesture(view: navController.view)
    }
    
    private func setupBackGesture(view: UIView) {
        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
        swipeBackGesture.edges = .left
        view.addGestureRecognizer(swipeBackGesture)
    }
    
    @objc private func handleBackGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
        
        let viewTranslation = gesture.translation(in: gesture.view?.superview)
        let transitionProgress = viewTranslation.x / nav.view.frame.width
        
        switch gesture.state {
        case .began:
            
            let shouldBeginPanGesture = shouldBeginDelegate?.shouldBeginPanGesture() ?? true
            guard shouldBeginPanGesture else {
                // Don't allow pan gesture if the UIViewControllerAnimatedTransitioning
                // Has not finished animating yet
                return
            }
            
            isActive = true
            nav.popViewController(animated: true)
        case .changed:
            if isActive {
                update(transitionProgress)
            }
        case .cancelled:
            isActive = false
            cancel()
        case .ended:
            isActive = false
            if gesture.velocity(in: gesture.view).x > 300 {
                finish()
                return
            }
            if (transitionProgress > transitionCompletionThreshold)  {
                finish()
            } else {
                cancel()
            }
        default:
            return
        }
    }
}
