//
//  ViewController3.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-06-30.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit
import EPNavController

class ViewController3: UIViewController, EPNavControllerDelegate {
    
    func navBarCenter() -> EPNavBarCenter? {
        return .title("Or a Title String")
    }
}

