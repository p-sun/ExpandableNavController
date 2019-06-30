//
//  Constraints+Activation+Priority.swift
//

import UIKit

extension Sequence where Element == NSLayoutConstraint {
    
    func activate() {
        if let constraints = self as? [NSLayoutConstraint] {
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    func deActivate() {
        if let constraints = self as? [NSLayoutConstraint] {
            NSLayoutConstraint.deactivate(constraints)
        }
    }
}

extension NSLayoutConstraint {
    
    func with(_ p: UILayoutPriority) -> Self {
        priority = p
        return self
    }
    
    func set(active: Bool) -> Self {
        isActive = active
        return self
    }
}

extension UIView {

    func setHugging(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        setContentHuggingPriority(priority, for: axis)
    }
    
    func setCompressionResistance(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        setContentCompressionResistancePriority(priority, for: axis)
    }
}
