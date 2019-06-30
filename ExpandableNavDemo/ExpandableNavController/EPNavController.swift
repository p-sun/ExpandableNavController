//
//  EPNavController.swift
//
//  Created by Paige Sun on 2019-06-18.
//

import UIKit

class EPNavController: UINavigationController {
    
    static var appearance = Appearance()
    
    struct Appearance {
        var tintColor: UIColor? = #colorLiteral(red: 0.4520817399, green: 0.3181101084, blue: 0.8320295811, alpha: 1)
        
        var navCornerRadius: CGFloat = 30
        var topNavFromLayoutGuide: CGFloat = 60
        
        var shadowColor: UIColor = #colorLiteral(red: 0.3450980392, green: 0.3843137255, blue: 0.4431372549, alpha: 1)
        var shadowOpacity: Float = 0.4
        
        var headlineFont: UIFont = .systemFont(ofSize: 17, weight: .semibold)
        var backButtonFont: UIFont = .systemFont(ofSize: 17)
    }
    
    lazy var navBar: EPNavBarView = {
        let view = EPNavBarView()
        view.backButtonPressed = { [weak self] in
            _ = self?.popViewController(animated: true)
        }
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = EPNavController.appearance.navCornerRadius
        view.layer.maskedCorners = [.layerMinXMaxYCorner]
        return view
    }()
    
    private lazy var shadowView: UIView = {
        let view = ShadowCard()
        view.backgroundColor = .white
        return view
    }()
    
    private var containerHeightConstraint: NSLayoutConstraint?
    
    private var interactor: EPEdgePanInteractor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarHidden(true, animated: false)
        
        delegate = self
        
        interactor = EPEdgePanInteractor(attachTo: self)
        
        view.tintColor = EPNavController.appearance.tintColor

        view.addSubview(shadowView)
        view.addSubview(containerView)
        view.addSubview(navBar)
        
        constrainViews()
    }
    
    private func constrainViews() {
        navBar.constrainTop(to: view)
        navBar.constrainEdgesHorizontally(to: view)
        _ = navBar.constrainBottomToTopLayoutGuide(of: self, offset: EPNavController.appearance.topNavFromLayoutGuide)
        
        containerView.constrainEdgesHorizontally(to: view)
        containerView.constrainTopToBottom(of: navBar)
        
        shadowView.constrainTopToTopLayoutGuide(of: self)
        shadowView.constrainEdgesHorizontally(to: view, rightInset: -EPNavController.appearance.navCornerRadius)
        shadowView.constrainBottom(to: containerView, relation: .equalOrGreater)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard containerHeightConstraint == nil else {
            return
        }
        
        if let delegate = viewControllers.first as? EPNavControllerDelegate {
            _ = delegate.supplementary().add(to: containerView)
            
            if let centerConfig = delegate.navBarCenter() {
                _ = navBar.addSubview(with: centerConfig)
            }
            
            containerHeightConstraint = containerView.constrainHeight(delegate.supplementary().containerHeight)
        } else {
            containerHeightConstraint = containerView.constrainHeight(EPNavController.appearance.navCornerRadius)
        }
    }
}

extension EPNavController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let containerHeightConstraint = containerHeightConstraint else {
            return nil
        }
        switch operation {
        case .push:
            let animator = EPTransitionAnimator(
                presenting: true,
                toNavDelegate: toVC as? EPNavControllerDelegate,
                fromNavDelegate: fromVC as? EPNavControllerDelegate,
                supplimentaryViewContainer: containerView,
                containerHeightConstraint: containerHeightConstraint,
                navBar: navBar,
                viewControllerCountable: self)
            interactor.shouldBeginDelegate = animator
            return animator
        case .pop:
            let animator = EPTransitionAnimator(
                presenting: false,
                toNavDelegate: toVC as? EPNavControllerDelegate,
                fromNavDelegate: fromVC as? EPNavControllerDelegate,
                supplimentaryViewContainer: containerView,
                containerHeightConstraint: containerHeightConstraint,
                navBar: navBar,
                viewControllerCountable: self)
            interactor.shouldBeginDelegate = animator
            return animator
        default:
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.isActive ? interactor : nil
    }
}

extension EPNavController: EPViewCountrollerCountable {
    func viewControllersCount() -> Int {
        return viewControllers.count
    }
}

private extension UIView {
    func constrainBottomToTopLayoutGuide(of viewController: UIViewController, offset: CGFloat = 0) -> NSLayoutConstraint {
        prepareForAutolayout()
        
        let constraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            constraint = bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: offset)
        } else {
            constraint = bottomAnchor.constraint(equalTo: viewController.topLayoutGuide.bottomAnchor, constant: offset)
        }
        constraint.isActive = true
        
        return constraint
    }
}

private class ShadowCard: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        layer.cornerRadius = EPNavController.appearance.navCornerRadius
        layer.shadowColor = EPNavController.appearance.shadowColor.cgColor
        layer.shadowOpacity = EPNavController.appearance.shadowOpacity
        layer.shadowRadius = 16
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
}
