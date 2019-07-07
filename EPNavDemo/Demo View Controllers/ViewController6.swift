//
//  ViewController6.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-06-30.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit
import EPNavController

class ViewController6: UIViewController, EPNavControllerDelegate {
    
    private let imageView: UIView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = #imageLiteral(resourceName: "water")
        view.layer.cornerRadius = 30
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
        
        view.addSubview(imageView)
        constrainTopToEPNavBarBottom(imageView) // With this!
        imageView.constrainEdgesHorizontally(to: view, offset: 20)
        imageView.constrainHeight(100)
    }
}
