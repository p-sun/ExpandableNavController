//
//  ViewController6.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-06-30.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

class ViewController6: UIViewController, EPNavControllerDelegate {
    
    private let yellowView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9033690095, green: 0.9400885105, blue: 0.4191256762, alpha: 1)
        view.layer.cornerRadius = 24
        return view
    }()
    
    func supplementary() -> EPSupplementary {
        let supplementary = EPSupplementary(
            largeTitle: "You can constrain views to the bottom of the navigation bar 👇",
            fontSize: 20)
        return supplementary
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(yellowView)
        constrainTopToEPNavBarBottom(yellowView) // With this!
        yellowView.constrainEdgesHorizontally(to: view, offset: 30)
        yellowView.constrainHeight(100)
    }
}
