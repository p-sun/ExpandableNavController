//
//  EPEdgePanInteractor.swift
//
//  Created by Paige Sun on 2019-06-18.
//

import UIKit

protocol EPEdgePanInteractorShouldBeginDelegate: class {
    func shouldBeginPanGesture() -> Bool
}

protocol EPEdgePanInteractorDelegate: class {
     func epEdgePanInteractorDidBeginPopGesture(_ epEdgePanInteractor: EPEdgePanInteractor)
}

class EPEdgePanInteractor: UIPercentDrivenInteractiveTransition {
    
    var isActive: Bool = false
    
    weak var shouldBeginDelegate: EPEdgePanInteractorShouldBeginDelegate?
    weak var delegate: EPEdgePanInteractorDelegate?

    private let transitionCompletionThreshold: CGFloat = 0.5
    
    init(attachTo view: UIView) {
        super.init()
        setupBackGesture(in: view)
    }
    
    private func setupBackGesture(in view: UIView) {
        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
        swipeBackGesture.edges = .left
        view.addGestureRecognizer(swipeBackGesture)
    }
    
    @objc private func handleBackGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
        
        guard let delegate = delegate else {
            print("EPEdgePanInteractor Error: No delegate was assigned")
            return
        }
        
        guard let frameWidth = gesture.view?.frame.width else {
            print("EPEdgePanInteractor Error: Gesture recognizer's view has no width")
            return
        }
        
        let viewTranslation = gesture.translation(in: gesture.view?.superview)
        let transitionProgress = viewTranslation.x / frameWidth
        
        switch gesture.state {
        case .began:
            
            let shouldBeginPanGesture = shouldBeginDelegate?.shouldBeginPanGesture() ?? true
            guard shouldBeginPanGesture else {
                // Don't allow pan gesture if the UIViewControllerAnimatedTransitioning
                // Has not finished animating yet
                return
            }
            
            isActive = true
            delegate.epEdgePanInteractorDidBeginPopGesture(self)
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
