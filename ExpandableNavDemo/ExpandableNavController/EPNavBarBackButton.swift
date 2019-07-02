//
//  EXNavBarBackButton.swift
//
//  Created by Paige Sun on 2019-06-26.
//

import UIKit

class EPNavBarBackButton: UIControl {
    
    private lazy var button: UIView = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var backImageView: UIView = {
        let imageView = UIImageView()
        imageView.image = UIImage(
            named: "EPExpandableNavBack",
            in: Bundle(for: EPNavBarBackButton.self),
            compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var backTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: "Back",
            attributes: EPNavController.appearance.backTextAttributes)
        label.textColor = tintColor
        return label
    }()
    
    var imageLabelConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        backTitleLabel.textColor = tintColor
    }
    
    private func setup() {
        addSubview(button)
        addSubview(backImageView)
        addSubview(backTitleLabel)
        constraintViews()
    }
    
    private func constraintViews() {
        backTitleLabel.setCompressionResistance(.required, for: .horizontal)
        button.constrainEdges(to: self)
        
        backImageView.setCompressionResistance(.required, for: .horizontal)
        backImageView.constrainEdgesVertically(to: self)
        backImageView.constrainLeft(to: button)

        backTitleLabel.constrainEdgesVertically(to: self)
        imageLabelConstraint = backTitleLabel.constrainLeftToRight(of: backImageView, offset: 5)
        backTitleLabel.constrainRight(to: self, offset: -20)
    }
    
    @objc private func buttonTapped() {
        sendActions(for: .touchUpInside)
    }
}
