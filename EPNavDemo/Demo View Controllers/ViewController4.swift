//
//  ViewController4.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-06-30.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit
import EPNavController

class ViewController4: UIViewController, EPNavControllerDelegate {
    
    func supplementary() -> EPSupplementary {
        let title = "Each View Controller can \ndefine a supplementary view"
        return EPSupplementary(
            view: OceanImageView(title: title),
            topPadding: 0,
            viewHeight: 100,
            bottomPadding: 0)
    }
}
