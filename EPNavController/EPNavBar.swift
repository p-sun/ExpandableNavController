//
//  EPNavBar.swift
//  NavExperiment
//
//  Created by Paige Sun on 2019-06-18.
//

import UIKit

public class EPNavBar: UIView {
    
    var backButtonPressed: (() -> Void)?

    lazy var backButton: EPNavBarBackButton = {
        let button = EPNavBarBackButton()
        button.alpha = 0
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    var centerWidthConstraint: NSLayoutConstraint!
    
    let centerContent = UIView()
    let leftContent = UIView()
    let rightContent = UIView()
    
    private var leftButtonTapped: (() -> Void)?
    private var rightButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Public
    
    public func setCenter(_ center: EPNavBarCenter?, onCancel: (() -> Void)? = nil) {
        guard let center = center else {
            centerContent.subviews.forEach({ $0.removeFromSuperview() })
            return
        }
        
        let centerView = center.view
        let parentView = UIView()
        parentView.addSubview(centerView)
        centerView.constrainEdges(to: parentView)
        centerContent.addSubview(parentView)

        // Allow center view to be referenced by the VC and its alpha changed from the VC
        // ParentView's alpha is changed during EPTransitionAnimator's animations
        parentView.constrainCenterY(to: centerContent)
        parentView.constrainWidth(to: centerContent, relation: .equalOrLess)
        parentView.constrainCenterX(to: self)
    }
    
    public func setLeftBarButtonItem(_ buttonItem: EPBarButtonItem?) {
        guard let buttonItem = buttonItem else {
            leftContent.subviews.forEach { $0.removeFromSuperview() }
            return
        }
        
        leftButtonTapped = buttonItem.didTapButton

        let button = buttonItem.button
        button.titleLabel?.textColor = tintColor
        button.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        
        let parentView = UIView()
        parentView.addSubview(button)
        button.constrainEdges(to: parentView)
        
        leftContent.addSubview(parentView)
        bringSubviewToFront(parentView)
        parentView.constrainLeft(to: leftContent)
        parentView.constrainCenterY(to: leftContent)
        parentView.constrainRight(to: leftContent, priority: .defaultLow)
    }
    
    public func setRightBarButtonItem(_ buttonItem: EPBarButtonItem?) {
        guard let buttonItem = buttonItem else {
            rightContent.subviews.forEach { $0.removeFromSuperview() }
            return
        }
        rightButtonTapped = buttonItem.didTapButton

        let button = buttonItem.button
        button.titleLabel?.textColor = tintColor
        button.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)

        let parentView = UIView()
        parentView.addSubview(button)
        button.constrainEdges(to: parentView)
        
        rightContent.addSubview(parentView)
        bringSubviewToFront(parentView)
        parentView.constrainRight(to: rightContent)
        parentView.constrainLeft(to: rightContent, priority: .defaultLow)
        parentView.constrainCenterY(to: rightContent)
    }
    
    // MARK: - Private
    
    private func commonInit() {
        addSubview(leftContent)
        addSubview(backButton)
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

