//
//  EPNavBarCenter.swift
//  NavExperiment
//
//  Created by Paige Sun on 2019-06-18.
//

import UIKit

public enum EPNavBarCenter {
    case title(_ text: String)
    case image(_ image: UIImage, height: CGFloat)
}

public class EPNavBarView: UIView {
    
    var backButtonPressed: (() -> Void)?

    var centerSubviews: [UIView] {
        get {
            return centerContent.subviews
        }
    }
    
    private var centerContent = UIView()
    
    lazy var backButton: EPNavBarBackButton = {
        let button = EPNavBarBackButton()
        button.alpha = 0
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func addSubview(with centerConfig: EPNavBarCenter) -> UIView {
        switch centerConfig {
        case .title(let title):
            return addTitleLabelSubview(title)
        case .image(let image, let height):
            return addTitleImageViewSubview(image, height: height)
        }
    }
    
    private func addTitleLabelSubview(_ title: String) -> UIView {
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: title,
            attributes: EPNavController.appearance.titleTextAttributes)
        centerContent.addSubview(label)
        label.constrainCenterY(to: centerContent)
        label.constrainCenterX(to: centerContent)
        label.constrainWidth(to: centerContent, relation: .equalOrLess)
        return label
    }
    
    private func addTitleImageViewSubview(_ image: UIImage, height: CGFloat) -> UIView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        centerContent.addSubview(imageView)
        imageView.constrainCenterY(to: centerContent)
        imageView.constrainEdgesHorizontally(to: centerContent)
        imageView.constrainHeight(height)
        return imageView
    }
    
    private func commonInit() {        
        addSubview(backButton)
        addSubview(centerContent)
        constraintViews()
    }
    
    private func constraintViews() {
        backButton.constrainCenterY(to: self, bottomAnchor, offset: -18)
        backButton.constrainLeft(to: self, offset: 10)
        
        centerContent.constrainEdgesHorizontally(to: self, leftInset: 84, rightInset: 84)
        centerContent.constrainCenterY(to: backButton)
    }
    
    @objc private func goBack() {
        backButtonPressed?()
    }
}

