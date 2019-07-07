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

public extension EPNavControllerDelegate {
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
