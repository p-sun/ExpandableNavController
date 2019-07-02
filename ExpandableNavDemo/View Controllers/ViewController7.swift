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
        let supplementary = EPSupplementary(
            largeTitle: "You Can Add Buttons To the Left and Right",
            fontSize: 20)
        supplementary.view?.backgroundColor = #colorLiteral(red: 0.6786003113, green: 1, blue: 0.7185514569, alpha: 1)
        return supplementary
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
