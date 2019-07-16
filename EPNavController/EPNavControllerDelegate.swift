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

public extension EPNavControllerDelegate where Self: UIViewController {
    
    // Set minusOffsetForRoundedCorners to true so table will go under the nav bar
    // And peek under the rounded corners
    @discardableResult
    func constrainTopToEPNavBarBottom(_ mainView: UIView,
                                      minusOffsetForRoundedCorners: Bool = true,
                                      offset: CGFloat = 0) -> NSLayoutConstraint {
        var offsetFromTop = EPNavController.appearance.topNavFromLayoutGuide
            + supplementary().containerHeight
            + offset
        
        if minusOffsetForRoundedCorners {
            offsetFromTop -= EPNavController.appearance.navCornerRadius
        }
        
        return mainView.constrainToTopLayoutGuide(of: self, offset: offsetFromTop)
    }
}
