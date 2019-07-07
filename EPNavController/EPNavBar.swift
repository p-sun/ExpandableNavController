//
//  EPNavBar.swift
//  NavExperiment
//
//  Created by Paige Sun on 2019-06-18.
//

import UIKit

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
    
    lazy var backButton: EPNavBarBackButton = {
        let button = EPNavBarBackButton()
        button.alpha = 0
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    var centerWidthConstraint: NSLayoutConstraint!

    private var centerContent = UIView()
    private var leftContent = UIView()
    private var rightContent = UIView()
    private var leftButtonTapped: (() -> Void)?
    private var rightButtonTapped: (() -> Void)?
    
    // Keep references so it doesn't get deallocated
    private var rightButton = UIButton()
    private var leftButton = UIButton()
    
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
        leftButtonTapped = buttonItem.didTapButton

        let button = UIButton()
        leftButton = button
        button.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        
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
        rightButtonTapped = buttonItem.didTapButton

        let button = UIButton()
        rightButton = button
        button.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)

        button.setAttributedTitle(NSAttributedString(
            string: buttonItem.title,
            attributes: EPNavController.appearance.backTextAttributes), for: .normal)
        button.titleLabel?.textColor = tintColor
        
        button.setCompressionResistance(.required, for: .horizontal)
        button.setHugging(.required, for: .horizontal)

        rightContent.addSubview(button)
        bringSubviewToFront(button)
        button.constrainRight(to: rightContent)
        button.constrainLeft(to: rightContent, priority: .defaultLow)
        button.constrainCenterY(to: rightContent)
        
        return button
    }
    
    // MARK: - Private
    
    private func addTitleLabelSubview(_ title: String) -> UIView {
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: title,
            attributes: EPNavController.appearance.titleTextAttributes)
        label.setCompressionResistance(.init(210), for: .horizontal)
        label.setHugging(.required, for: .horizontal)

        centerContent.addSubview(label)
        label.constrainCenterY(to: centerContent)
        label.constrainWidth(to: centerContent, relation: .equalOrLess)
        label.constrainCenterX(to: self)
        return label
    }
    
    private func addTitleImageViewSubview(_ image: UIImage, height: CGFloat) -> UIView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.setCompressionResistance(.init(210), for: .horizontal)

        centerContent.addSubview(imageView)
        imageView.constrainCenterY(to: centerContent)
        imageView.constrainHeight(height)
        imageView.constrainWidth(to: centerContent, relation: .equalOrLess)
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
        //        centerContent.constrainHeight(60, relation: .equalOrGreater)
        // ------------------
        
        backButton.constrainCenterY(to: self, bottomAnchor, offset: -18)
        backButton.constrainLeft(to: self, offset: 10)
        
        // Add height so buttons inside can respond to touch
        leftContent.constrainHeight(60, relation: .equalOrGreater)
        leftContent.constrainCenterY(to: backButton)
        leftContent.constrainLeft(to: self, offset: 20)
        
        centerContent.setCompressionResistance(.init(240), for: .horizontal)
        centerContent.constrainCenterY(to: backButton)
        centerContent.constrainCenterX(to: self)
        centerWidthConstraint = centerContent.constrainWidth(200)
        
        rightContent.constrainHeight(60, relation: .equalOrGreater)
        rightContent.constrainCenterY(to: backButton)
        rightContent.constrainRight(to: self, offset: -20)
    }
    
    @objc private func goBack() {
        backButtonPressed?()
    }
    
    @objc private func leftButtonAction() {
        leftButtonTapped?()
    }
    
    @objc private func rightButtonAction() {
        rightButtonTapped?()
    }
}

