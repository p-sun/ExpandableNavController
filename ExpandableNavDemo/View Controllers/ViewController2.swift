//
//  ViewController2.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-06-30.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

class ViewController2: UIViewController, EPNavControllerDelegate {
    
    func navBarCenter() -> EPNavBarCenter? {
        return .image(#imageLiteral(resourceName: "sushi"), height: 60)
    }
    
    func supplementary() -> EPSupplementary {
        return EPSupplementary(largeTitle: "Can Have a Title Image")
    }
    
    func navBarLeft() -> EPBarButtonItem? {
        return EPBarButtonItem(title: "Left", didTapButton: {
            print("left tapped")
        })
    }

    func navBarRight() -> EPBarButtonItem? {
        return EPBarButtonItem(title: "Right right right", didTapButton: {
            print("Right tapped")
        })
    }
}
