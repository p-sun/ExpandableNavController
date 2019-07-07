//
//  ViewController8.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-06-30.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit
import EPNavController

class ViewController8: UIViewController, EPNavControllerDelegate {
    
    @IBAction func didTapNext(_ sender: Any) {
        let navController = EPNavController(rootViewController: AnimationViewController0())
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func supplementary() -> EPSupplementary {
        let supplementary = EPSupplementary(
            largeTitle: "👈 Pan from the left edge \nto go back 🌟🌟🌟",
            fontSize: 20)
        supplementary.view?.backgroundColor = #colorLiteral(red: 0.6786003113, green: 1, blue: 0.7185514569, alpha: 1)
        return supplementary
    }
}
