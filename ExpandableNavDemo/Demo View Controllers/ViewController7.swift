//
//  ViewController8.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-07-02.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

class ViewController7: UIViewController, EPNavControllerDelegate {
    
    func supplementary() -> EPSupplementary {
        return EPSupplementary(
            largeTitle: "You Can Add Buttons\nTo the Left and Right",
            fontSize: 20)
    }
    
    func navBarLeft() -> EPBarButtonItem? {
        return EPBarButtonItem(title: "Left Button", didTapButton: {
            print("Left button tapped")
        })
    }
    
    func navBarRight() -> EPBarButtonItem? {
        return EPBarButtonItem(title: "Right Button", didTapButton: {
            print("Right button tapped")
        })
    }
}
