//
//  ViewController5.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-06-30.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit
import EPNavController

class ViewController5: UIViewController, EPNavControllerDelegate {
    
    func supplementary() -> EPSupplementary {
        let title = "...and its heights.\n\n○  top padding: 10\n○  height: 140\n○  bottom padding: 30"
        return EPSupplementary(
            view: OceanImageView(title: title),
            topPadding: 10,
            viewHeight: 140,
            bottomPadding: 30)
    }
}
