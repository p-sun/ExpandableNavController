//
//  EPNavBar.swift
//  NavExperiment
//
//  Created by Paige Sun on 2019-06-18.
//

import UIKit

public enum EPNavBarCenter {
    case title(_ text: String)
    case image(_ image: UIImage, height: CGFloat)
}

public struct EPBarButtonItem {
    let title: String
    let didTapButton: (() -> Void)?
}

public class EPNavBar: UIView {
    
    var backButtonPressed: (() -> Void)?

    var centerSubviews: [UIView] {
        get {
            return centerContent.subviews
        }
    }
    
    var leftSubviews: [UIView] {
        get {
            return leftContent.subviews
        }
    }
    
    var rightSubviews: [UIView] {
        get {
            return rightContent.subviews
        }
    }
    
    var centerWidthConstraint: NSLayoutConstraint!

    var centerContent = UIView()
    private var leftContent = UIView()
    private var rightContent = UIView()
    
    lazy var backButton: EPNavBarBackButton = {
        let button = EPNavBarBackButton()
        button.backgroundColor = .yellow
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
    
    // MARK: - Public
    
    public func setCenter(_ center: EPNavBarCenter) -> UIView {
        switch center {
        case .title(let title):
            return addTitleLabelSubview(title)
        case .image(let image, let height):
            return addTitleImageViewSubview(image, height: height)
        }
    }
    
    public func setLeftBarButtonItem(_ buttonItem: EPBarButtonItem) -> UIView {
        let button = UIButton()
        button.backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        button.setAttributedTitle(NSAttributedString(
            string: buttonItem.title,
            attributes: EPNavController.appearance.backTextAttributes),for: .normal)
        button.titleLabel?.textColor = tintColor

        button.setCompressionResistance(.required, for: .horizontal)
        button.setHugging(.required, for: .horizontal)
        
        leftContent.addSubview(button)
        button.constrainLeft(to: leftContent)
        button.constrainCenterY(to: leftContent)
        button.constrainRight(to: leftContent, priority: .defaultLow)
        return button
    }

    public func setRightBarButtonItem(_ buttonItem: EPBarButtonItem) -> UIView {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(
            string: buttonItem.title,
            attributes: EPNavController.appearance.backTextAttributes), for: .normal)
        button.titleLabel?.textColor = tintColor
        
        button.setCompressionResistance(.required, for: .horizontal)
        button.setHugging(.required, for: .horizontal)
        
        rightContent.addSubview(button)
        button.constrainRight(to: rightContent)
        button.constrainLeft(to: rightContent, priority: .defaultLow)
        button.constrainCenterY(to: rightContent)
        return button
    }
    
    // MARK: - Private
    
    private func addTitleLabelSubview(_ title: String) -> UIView {
        let label = UILabel()
        label.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
        label.attributedText = NSAttributedString(
            string: title,
            attributes: EPNavController.appearance.titleTextAttributes)
        label.setCompressionResistance(.init(210), for: .horizontal)
        label.setHugging(.defaultLow, for: .horizontal)
        
        centerContent.addSubview(label)
        label.constrainCenterY(to: centerContent)
        label.constrainWidth(to: centerContent, relation: .equalOrLess, priority: UILayoutPriority.defaultLow)
        label.constrainCenterX(to: self)
        return label
    }
    
    private func addTitleImageViewSubview(_ image: UIImage, height: CGFloat) -> UIView {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.setCompressionResistance(.init(210), for: .horizontal)
        imageView.setHugging(.defaultLow, for: .horizontal)
        
        centerContent.addSubview(imageView)
        imageView.constrainCenterY(to: centerContent)
        imageView.constrainHeight(height)
        imageView.constrainWidth(to: centerContent, relation: .equalOrLess, priority: UILayoutPriority.defaultLow)
        imageView.constrainCenterX(to: self)
        return imageView
    }
    
    private func commonInit() {        
        addSubview(backButton)
        addSubview(leftContent)
        addSubview(centerContent)
        addSubview(rightContent)
        constraintViews()
    }
    
    private func constraintViews() {
        // ------------- For debugging
        //        leftContent.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        //        rightContent.backgroundColor = UIColor.purple.withAlphaComponent(0.3)
        //        centerContent.backgroundColor = UIColor.magenta.withAlphaComponent(0.4)
        //
        //        leftContent.constrainHeight(20, relation: .equalOrGreater)
        //        rightContent.constrainHeight(20, relation: .equalOrGreater)
        //        centerContent.constrainHeight(20, relation: .equalOrGreater)
        // ------------------
        
        backButton.constrainCenterY(to: self, bottomAnchor, offset: -18)
        backButton.constrainLeft(to: self, offset: 10)
        
        leftContent.constrainLeft(to: self, offset: 20)
        leftContent.constrainCenterY(to: backButton)
        
        centerContent.constrainCenterY(to: backButton)
        centerContent.constrainCenterX(to: self)
        centerWidthConstraint = centerContent.constrainWidth(200)
        
        rightContent.constrainCenterY(to: backButton)
        rightContent.constrainRight(to: self, offset: -20)
    }
    
    @objc private func goBack() {
        backButtonPressed?()
    }
}

