//
//  Constrainable.swift
//

import UIKit

extension UIView: Constrainable {
    
    @discardableResult
    public func prepareForAutolayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

extension UILayoutGuide: Constrainable {
    
    @discardableResult
    public func prepareForAutolayout() -> Self { return self }
}

public protocol Constrainable {
    
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }

    @discardableResult
    func prepareForAutolayout() -> Self
}

