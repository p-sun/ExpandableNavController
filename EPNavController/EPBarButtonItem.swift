//
//  EPBarButtonItem.swift
//  EPNavController
//
//  Created by Paige Sun on 2019-07-07.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

public enum EPNavBarCenter {
    case title(_ text: String)
    case image(_ image: UIImage, height: CGFloat)
}

public struct EPBarButtonItem {
    let title: String
    let didTapButton: (() -> Void)?
    
    public init(title: String, didTapButton: (() -> Void)?) {
        self.title = title
        self.didTapButton = didTapButton
    }
}
