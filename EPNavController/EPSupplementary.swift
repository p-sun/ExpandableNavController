//
//  EPSupplementary.swift
//  EPNavController
//
//  Created by Paige Sun on 2019-07-07.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

public struct EPSupplementary {
    public let view: UIView?
    public let topPadding: CGFloat
    public let viewHeight: CGFloat
    public let bottomPadding: CGFloat
    
    public init(view: UIView?, topPadding: CGFloat, viewHeight: CGFloat, bottomPadding: CGFloat) {
        self.view = view
        self.topPadding = topPadding
        self.viewHeight = viewHeight
        self.bottomPadding = bottomPadding
    }
    
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
