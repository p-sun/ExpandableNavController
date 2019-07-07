//
//  UIColor+Swizzling.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-07-05.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

struct ColorSwizzler {
    private static var hasBeenSwizzled = false
    
    static func swizzle() {
        guard !hasBeenSwizzled else {
            return
        }
        hasBeenSwizzled = true
        
        let shouldSwizzleTouch = Bool(truncating: 1)
        if shouldSwizzleTouch {
            // Doesn't swizzle colors on backgrounds of UIButtons
            UIView.swizzleTouchesBegan()
        } else {
            // Swizzles colors on backgrounds of UIButtons
            // Cannot be used concurrently with swizzleTouchesBegan
            UIView.swizzleLayerWillDraw()
        }
        
        // Swizzle all calls for cgColors, and other private UIColor subclassses
        UIColor.replaceColorsWithRandomColors()
    }
}

private extension UIColor {
    static func replaceColorsWithRandomColors() {
        
        // Returns true if the given class has `superclass` anywhere in its class hierarchy
        func isClassSubclassOf(_ base: AnyClass?, superclass: AnyClass) -> Bool {
            var _class: AnyClass? = base
            while _class != nil && _class != superclass {
                _class = class_getSuperclass(_class)
            }
            return _class == superclass
        }
        
        var classCount = objc_getClassList(nil, 0)
        let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(classCount))
        let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)
        classCount = objc_getClassList(autoreleasingAllClasses, classCount)
        
        
        for i in 0 ..< classCount {
            if let currentClass: AnyClass = allClasses[Int(i)],
                isClassSubclassOf(currentClass, superclass: UIColor.self),
                let originalMethod = class_getInstanceMethod(currentClass.self, #selector(getter: cgColor)) {
                method_setImplementation(originalMethod, imp_implementationWithBlock(
                    unsafeBitCast(UIColor.randomColorBlock, to: AnyObject.self))
                )
            }
        }
    }
}

private extension UIView {
    class func swizzleTouchesBegan() {
        let originalSelector = #selector(touchesBegan(_:with:))
        let swizzledSelector = #selector(setRandomColorForAllSubviews)
        let originalMethod = class_getInstanceMethod(self, originalSelector)!
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)!
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    class func swizzleLayerWillDraw() {
        let originalSelector = #selector(layerWillDraw(_:))
        let swizzledSelector = #selector(setRandomColorForAllSubviews)
        let originalMethod = class_getInstanceMethod(self, originalSelector)!
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)!
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    @objc private func setRandomColorForAllSubviews() {
        setRandomColorRecusively(rootView: self)
    }
    
    private func setRandomColorRecusively(rootView: UIView) {
        rootView.backgroundColor = UIColor.randomColor()
        
        for subview in rootView.subviews {
            setRandomColorRecusively(rootView: subview)
        }
    }
}

private extension UIColor {
    static func randomColor() -> UIColor {
        let randomRed = CGFloat(arc4random_uniform(256))
        let randomBlue = CGFloat(arc4random_uniform(256))
        let randomGreen = CGFloat(arc4random_uniform(256))
        
        return UIColor(red: randomRed/255.0,
                       green: randomGreen/255.0,
                       blue: randomBlue/255.0,
                       alpha: 1.0)
    }
    
    static let randomColorBlock: @convention(block) (AnyObject?) -> CGColor = { _ -> (CGColor) in
        return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [
            CGFloat(Float(arc4random()) / Float(UINT32_MAX)), // R
            CGFloat(Float(arc4random()) / Float(UINT32_MAX)), // G
            CGFloat(Float(arc4random()) / Float(UINT32_MAX)), // B
            1.0, // A
            ])!
    }
}
