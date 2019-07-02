//
//  EPNavControllerDelegate.swift
//
//  Created by Paige Sun on 2019-06-18.
//

import UIKit

public protocol EPNavControllerDelegate {
    func supplementary() -> EPSupplementary
    func navBarCenter() -> EPNavBarCenter?
    func navBarLeft() -> EPBarButtonItem?
    func navBarRight() -> EPBarButtonItem?
}

extension EPNavControllerDelegate {
    func supplementary() -> EPSupplementary {
        return EPSupplementary(view: nil, topPadding: 0, viewHeight: 0, bottomPadding: 0)
    }
    
    func navBarCenter() -> EPNavBarCenter? {
        return nil
    }
    
    func navBarLeft() -> EPBarButtonItem? {
        return nil
    }
    
    func navBarRight() -> EPBarButtonItem? {
        return nil
    }    
}

extension EPNavControllerDelegate where Self: UIViewController {
    
    @discardableResult
    public func constrainTopToEPNavBarBottom(_ mainView: UIView, offset: CGFloat = 0) -> NSLayoutConstraint {
        return mainView.constrainTopToTopLayoutGuide(
            of: self,
            inset: EPNavController.appearance.topNavFromLayoutGuide
                + supplementary().containerHeight
                + offset)
    }
}

public struct EPSupplementary {
    let view: UIView?
    let topPadding: CGFloat
    let viewHeight: CGFloat
    let bottomPadding: CGFloat
    
    var containerHeight: CGFloat {
        let total = topPadding + viewHeight + bottomPadding
        return max(EPNavController.appearance.navCornerRadius, total)
    }
    
    func add(to container: UIView) -> UIView? {
        guard let view = view else { return nil }
        container.addSubview(view)
        view.constrainTop(to: container, offset: topPadding)
        view.constrainLeft(to: container)
        view.constrainRight(to: container)
        view.constrainHeight(viewHeight)
        return view
    }
}
