//
//  Nibloadable.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-06-28.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

protocol NibLoadable {
}

extension NibLoadable where Self: UIView {
    
    static var nibName: String {
        return String(describing: self)
    }
    
    func constrainNibToSelf() {
        guard let nibView = loadViewFromNib() else {
            return
        }
        
        nibView.backgroundColor = .clear
        nibView.frame = bounds
        addSubview(nibView)
        nibView.constrainEdges(to: self)
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        return bundle.loadNibNamed(Self.nibName, owner: self, options: nil)?.first as? UIView
    }
}
