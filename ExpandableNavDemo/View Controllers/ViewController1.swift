//
//  ViewController1.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-06-28.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

class ViewController1: UIViewController, EPNavControllerDelegate {
    
    func supplementary() -> EPSupplementary {
        return EPSupplementary(largeTitle: "EPNavController")
    }
}

extension EPSupplementary {
    
    init(largeTitle: String, fontSize: CGFloat = 28) {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        label.text = largeTitle
        label.numberOfLines = 0
        
        let parent = UIView()
        parent.addSubview(label)
        label.constrainTop(to: parent, offset: 26)
        label.constrainEdgesHorizontally(to: parent, leftInset: 20, rightInset: 20)
        
        self.init(view: parent, topPadding: 0, viewHeight: 100, bottomPadding: 0)
    }
    
    init(largeTitle: String, subtitle: String, viewHeight: CGFloat = 140) {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.text = largeTitle
        titleLabel.numberOfLines = 0
        
        let subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        subtitleLabel.text = subtitle
        subtitleLabel.numberOfLines = 0
        subtitleLabel.setHugging(.defaultLow, for: .vertical)
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 14
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        
        let parent = UIView()
        parent.addSubview(stack)
        
        stack.constrainTop(to: parent, offset: 26)
        stack.constrainEdgesHorizontally(to: parent, leftInset: 20, rightInset: 20)
        
        self.init(view: parent, topPadding: 0, viewHeight: viewHeight, bottomPadding: 0)
    }
}
