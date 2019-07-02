//
//  AnimationRootNavController.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-07-02.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

class AnimationRootNavController: EPNavController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pushViewController(AnimationViewController0(), animated: false)
    }
}
