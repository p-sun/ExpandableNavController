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
        label.constrainEdges(to: parent, insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        
        self.init(view: parent, topPadding: 0, viewHeight: 100, bottomPadding: 0)
    }
}
