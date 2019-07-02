//
//  AnimationTestViewControllers.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-07-01.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

class AnimationViewController0: DemoViewController, EPNavControllerDelegate {
    func supplementary() -> EPSupplementary {
        return EPSupplementary(largeTitle: "Button Animation Tests")
    }
    
    func navBarLeft() -> EPBarButtonItem? {
        return EPBarButtonItem(title: "Cancel", didTapButton: {
          self.dismiss(animated: true, completion: nil)
        })
    }

    override func nextViewController() -> UIViewController? {
        return AnimationViewController1()
    }
}

private extension EPBarButtonItem {
    init(titleWithTapAction title: String) {
        self.init(title: title, didTapButton: {
            print("Button tapped")
        })
    }
}

class AnimationViewController1: DemoViewController, EPNavControllerDelegate {
    
    func supplementary() -> EPSupplementary {
        return EPSupplementary(largeTitle: "A long title and a long left button", fontSize: 20)
    }
    
    func navBarCenter() -> EPNavBarCenter? {
        return EPNavBarCenter.title("A very long title")
    }
    
    func navBarLeft() -> EPBarButtonItem? {
        return EPBarButtonItem(titleWithTapAction: "Long Left Button")
    }
    
    override func nextViewController() -> UIViewController? {
        return AnimationViewController2()
    }
}


class AnimationViewController2: DemoViewController, EPNavControllerDelegate {

    func supplementary() -> EPSupplementary {
        return EPSupplementary(largeTitle: "A long title and a long right button", fontSize: 20)
    }
    
    func navBarCenter() -> EPNavBarCenter? {
        return EPNavBarCenter.title("A very long title")
    }
    
    func navBarRight() -> EPBarButtonItem? {
        return EPBarButtonItem(titleWithTapAction: "Right Button")
    }
    
    override func nextViewController() -> UIViewController? {
       return AnimationViewController3()
    }
}

class AnimationViewController3: DemoViewController, EPNavControllerDelegate {
    
    func supplementary() -> EPSupplementary {
        return EPSupplementary(largeTitle: "A center image and a short right button", fontSize: 20)
    }
    
    func navBarCenter() -> EPNavBarCenter? {
        return .image(#imageLiteral(resourceName: "sushi"), height: 60)
    }
    
    func navBarRight() -> EPBarButtonItem? {
        return EPBarButtonItem(titleWithTapAction: "Right")
    }
    
    override func nextViewController() -> UIViewController? {
        return AnimationViewController4()
    }
}

class AnimationViewController4: DemoViewController, EPNavControllerDelegate {
    
    func supplementary() -> EPSupplementary {
        return EPSupplementary(largeTitle: "A center image and a long right button", fontSize: 20)
    }
    
    func navBarCenter() -> EPNavBarCenter? {
        return .image(#imageLiteral(resourceName: "sushi"), height: 60)
    }
    
    func navBarRight() -> EPBarButtonItem? {
        return EPBarButtonItem(titleWithTapAction: "Long Right Button")
    }
    
    override func nextViewController() -> UIViewController? {
        return AnimationViewController5()
    }
}


class AnimationViewController5: DemoViewController, EPNavControllerDelegate {
    
    func supplementary() -> EPSupplementary {
        return EPSupplementary(largeTitle: "A center image and a long left button", fontSize: 20)
    }

    func navBarCenter() -> EPNavBarCenter? {
        return .image(#imageLiteral(resourceName: "sushi"), height: 60)
    }

    func navBarLeft() -> EPBarButtonItem? {
        return EPBarButtonItem(titleWithTapAction: "Long Left Button")
    }
    
    override func nextViewController() -> UIViewController? {
        return AnimationViewController6()
    }
}

class AnimationViewController6: DemoViewController, EPNavControllerDelegate {
    
    func supplementary() -> EPSupplementary {
        return EPSupplementary(largeTitle: "Back to a long title", fontSize: 20)
    }
    
    func navBarCenter() -> EPNavBarCenter? {
        return .title("A very very long title")
    }
    
    override func nextViewController() -> UIViewController? {
        return AnimationViewController7()
    }
}


class AnimationViewController7: DemoViewController, EPNavControllerDelegate {
    
    func supplementary() -> EPSupplementary {
        return EPSupplementary(largeTitle: "Long title with Left Button", fontSize: 20)
    }
    
    func navBarCenter() -> EPNavBarCenter? {
        return .title("A very long title")
    }
    
    func navBarLeft() -> EPBarButtonItem? {
        return EPBarButtonItem(titleWithTapAction: "Long Left Button")
    }
 
    override func nextViewController() -> UIViewController? {
        return AnimationViewController8()
    }
}

class AnimationViewController8: DemoViewController, EPNavControllerDelegate {
    
    func supplementary() -> EPSupplementary {
        return EPSupplementary(largeTitle: "A center image and a short left button", fontSize: 20)
    }
    
    func navBarCenter() -> EPNavBarCenter? {
        return .image(#imageLiteral(resourceName: "sushi"), height: 60)
    }
    
    func navBarLeft() -> EPBarButtonItem? {
        return EPBarButtonItem(titleWithTapAction: "Left")
    }
    
}
