//
//  ViewController8.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-07-01.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

class ViewController8: UIViewController, EPNavControllerDelegate {
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        let vc = DemoViewController1()
        navigationController?.show(vc, sender: nil)
    }

    func supplementary() -> EPSupplementary {
        return EPSupplementary(largeTitle: "Animation Tests")
    }
}
