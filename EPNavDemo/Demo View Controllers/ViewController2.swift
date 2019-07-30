//
//  ViewController2.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-06-30.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit
import EPNavController

class ViewController2: UIViewController, EPNavControllerDelegate {
    
    func navBarCenter() -> EPNavBarCenter? {
        return EPNavBarCenter(image: #imageLiteral(resourceName: "sushi"), height: 60)
    }
    
    func supplementary() -> EPSupplementary {
        return EPSupplementary(largeTitle: "Can Have a Title Image")
    }
}
