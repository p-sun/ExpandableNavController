//
//  AnimationTestViewControllers.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-07-01.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

class DemoViewController1: DemoViewController, EPNavControllerDelegate {
    
    func navBarCenter() -> EPNavBarCenter? {
        return EPNavBarCenter.title("A very long title")
    }
    
    func navBarLeft() -> EPBarButtonItem? {
        return EPBarButtonItem(title: "Long Left Button", didTapButton: {})
    }
    
    func navBarRight() -> EPBarButtonItem? {
        return EPBarButtonItem(title: "Right", didTapButton: {})
    }
    
    override func nextViewController() -> UIViewController? {
        return DemoViewController2()
    }
}


class DemoViewController2: DemoViewController, EPNavControllerDelegate {

    func navBarCenter() -> EPNavBarCenter? {
        return .image(#imageLiteral(resourceName: "sushi"), height: 60)
    }

    func navBarLeft() -> EPBarButtonItem? {
        return EPBarButtonItem(title: "Left", didTapButton: {})
    }
    
    func navBarRight() -> EPBarButtonItem? {
        return EPBarButtonItem(title: "Long Right Button", didTapButton: {})
    }
    
    override func nextViewController() -> UIViewController? {
       return DemoViewController3()
    }
}

class DemoViewController3: DemoViewController, EPNavControllerDelegate {
    
    func navBarCenter() -> EPNavBarCenter? {
        return .title("Short Title Only")
    }
    
    override func nextViewController() -> UIViewController? {
        return DemoViewController4()
    }
}

class DemoViewController4: DemoViewController, EPNavControllerDelegate {
    
    func navBarCenter() -> EPNavBarCenter? {
        return .title("A long title without other buttons")
    }
}

