//
//  ProfileSupplementaryView.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-06-28.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

class OceanImageView: UIView, NibLoadable {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    convenience init(title: String) {
        self.init(frame: .zero)
        
        titleLabel.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constrainNibToSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        constrainNibToSelf()
    }
}
