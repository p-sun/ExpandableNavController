//
//  EPBarButtonItem.swift
//  EPNavController
//
//  Created by Paige Sun on 2019-07-07.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

public struct EPNavBarCenter {
    let view: UIView
    
    public init(title: String) {
        let label = UILabel()
        label.attributedText = EPNavController.appearance.titleAttributedString(title)
        label.setCompressionResistance(.init(210), for: .horizontal)
        label.setHugging(.required, for: .horizontal)
        view = label
    }
    
    public init(image: UIImage, height: CGFloat) {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.setCompressionResistance(.init(210), for: .horizontal)
        imageView.constrainHeight(height)
        view = imageView
    }
}

public struct EPBarButtonItem {
    let button = UIButton()
    let didTapButton: (() -> Void)?
    
    public init(title: String, didTapButton: (() -> Void)?) {
        button.setAttributedTitle(EPNavController.appearance.backAttributedString(title),
                                  for: .normal)
        
        button.setCompressionResistance(.required, for: .horizontal)
        button.setHugging(.required, for: .horizontal)
        
        self.didTapButton = didTapButton
    }
}
