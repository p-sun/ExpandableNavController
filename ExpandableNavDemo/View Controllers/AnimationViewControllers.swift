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

class AnimationViewController1: DemoViewController, EPNavControllerDelegate {
    
    func supplementary() -> EPSupplementary {
        return EPSupplementary(
            largeTitle: "A long title and \na long left button",
            subtitle: "Left and right buttons always expands to their content size")
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
        return EPSupplementary(
            largeTitle: "A long title and \na long right button",
            subtitle: "The title fits into the width of the remaining space between the buttons, with a small padding on both sides",
            viewHeight: 170)
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
        return EPSupplementary(
            largeTitle: "A center image of any height and \na short right button",
            subtitle: "The image view's height is determined by the delegate (the view controller), and its contentMode is sizeToFit",
        viewHeight: 170)
    }
    
    func navBarCenter() -> EPNavBarCenter? {
        return .image(#imageLiteral(resourceName: "water"), height: 60)
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
        return EPSupplementary(largeTitle: "A center image and \na long right button", fontSize: 20)
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
        return EPSupplementary(
            largeTitle: "A center image and \na long left button",
            subtitle: "When there is a left button, the back button animates away")
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
        return EPSupplementary(
            largeTitle: "Back to a long title",
            subtitle: "When the left button is removed, the back button animates back in")
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
        return EPSupplementary(
            largeTitle: "Animations are Interactive!",
            subtitle: "Pan from the left edge to view transition animations!")
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
        return EPSupplementary(largeTitle: "☝️ This button turns on Party Mode",
                               subtitle: "Party Mode allows you to tap any view to change its colors",
                               viewHeight: 130)
    }
    
    func navBarCenter() -> EPNavBarCenter? {
        return .image(#imageLiteral(resourceName: "sushi"), height: 60)
    }
    
    func navBarLeft() -> EPBarButtonItem? {
        return EPBarButtonItem(title: "Bonus: Swizzle All Colors!!! 🌈",
            didTapButton: { [weak self] in
                ColorSwizzler.swizzle()
                self?.popToRoot()
        })
    }
    
    private func popToRoot() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
}

private extension EPBarButtonItem {
    init(titleWithTapAction title: String) {
        self.init(title: title, didTapButton: {
            print("Button tapped")
        })
    }
}
