//
//  DemoViewController.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-07-01.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if let vc = nextViewController() {
            navigationController?.show(vc, sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if nextViewController() == nil {
            nextButton.isHidden = true
        }
    }
    
    init() {
        super.init(nibName: "DemoViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func nextViewController() -> UIViewController? {
        return nil
    }
}
