//
//  ViewController6.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-06-30.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

class ViewController6: UIViewController, EPNavControllerDelegate {
    
    func supplementary() -> EPSupplementary {
        let supplementary = EPSupplementary(largeTitle: "You can swipe \nfrom the left edge to go back",
                                            fontSize: 20)
        supplementary.view?.backgroundColor = #colorLiteral(red: 0.5584893823, green: 0.9611646533, blue: 0.6040813923, alpha: 1)
        return supplementary
    }
}
