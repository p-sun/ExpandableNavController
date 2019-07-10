//
//  EPNavController.swift
//
//  Created by Paige Sun on 2019-06-18.
//

import UIKit

public class EPNavController: UINavigationController {
    
    // MARK: - Public Vars
    
    public static var appearance = Appearance()
    
    public struct Appearance {
        public var tintColor: UIColor?
        public var backgroundColor: UIColor = .white
        
        public var navCornerRadius: CGFloat = 30
        public var topNavFromLayoutGuide: CGFloat = 60
        
        public var shadowColor: UIColor = #colorLiteral(red: 0.3450980392, green: 0.3843137255, blue: 0.4431372549, alpha: 1)
        public var shadowOpacity: Float = 0.4
        
        public var titleTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)]
        
        public var backTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
    }
    
    public var backgroundColor: UIColor = .white {
        didSet {
            shadowView.backgroundColor = backgroundColor
        }
    }
    
    public var tintColor: UIColor? = nil {
        didSet {
            view.tintColor = tintColor
        }
    }
    
    public lazy var navBar: EPNavBar = {
        let view = EPNavBar()
        view.backButtonPressed = { [weak self] in
            _ = self?.popViewController(animated: true)
        }
        return view
    }()
    
    // MARK: - Private Vars
    
    private var containerHeightConstraint: NSLayoutConstraint?
    
    private var interactor: EPEdgePanInteractor!
    
    private lazy var shadowView: UIView = {
        let view = ShadowCard()
        view.backgroundColor = backgroundColor
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = EPNavController.appearance.navCornerRadius
        view.layer.maskedCorners = [.layerMinXMaxYCorner]
        return view
    }()

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundColor = EPNavController.appearance.backgroundColor
        tintColor = EPNavController.appearance.tintColor
        
        setNavigationBarHidden(true, animated: false)
        
        delegate = self
        
        interactor = EPEdgePanInteractor(attachTo: self)
        
        view.addSubview(shadowView)
        view.addSubview(containerView)
        view.addSubview(navBar)
        
        constrainViews()
    }
    
    private func constrainViews() {
        navBar.constrainTop(to: view)
        navBar.constrainEdgesHorizontally(to: view)
        _ = navBar.constrainBottomToTopLayoutGuide(
            of: self,
            offset: EPNavController.appearance.topNavFromLayoutGuide)
        
        containerView.constrainEdgesHorizontally(to: view)
        containerView.constrainTopToBottom(of: navBar)
        
        shadowView.constrainTop(to: view)
        shadowView.constrainEdgesHorizontally(to: view)
        shadowView.constrainBottom(to: containerView, relation: .equalOrGreater)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard containerHeightConstraint == nil else {
            return
        }
        
        if let delegate = viewControllers.first as? EPNavControllerDelegate {
            _ = delegate.supplementary().add(to: containerView)
            
            if let centerConfig = delegate.navBarCenter() {
                _ = navBar.setCenter(centerConfig)
            }
            
            if let left = delegate.navBarLeft() {
                _ = navBar.setLeftBarButtonItem(left)
            }
            
            if let right = delegate.navBarRight() {
                _ = navBar.setRightBarButtonItem(right)
            }
            
            containerHeightConstraint = containerView.constrainHeight(delegate.supplementary().containerHeight)
        } else {
            containerHeightConstraint = containerView.constrainHeight(EPNavController.appearance.navCornerRadius)
        }
    }
}

extension EPNavController: UINavigationControllerDelegate {
 
    private class ReturnSingleViewControllerCount: EPViewCountrollerCountable {
        func viewControllersCount() -> Int {
            return 1
        }
    }
    
    override public func popToRootViewController(animated: Bool) -> [UIViewController]? {
        guard let containerHeightConstraint = containerHeightConstraint else {
            return nil
        }
        
        if let rootViewController = viewControllers.first {
            let animator = EPTransitionAnimator(
                presenting: true,
                toNavDelegate: rootViewController as? EPNavControllerDelegate,
                fromNavDelegate: self as? EPNavControllerDelegate,
                supplimentaryViewContainer: containerView,
                containerHeightConstraint: containerHeightConstraint,
                navBar: navBar,
                viewControllerCountable: ReturnSingleViewControllerCount())
            animator.animateNavBarTransition(animated: animated)
        }
        
        return super.popToRootViewController(animated: animated)
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
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
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
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
        layer.maskedCorners = [.layerMinXMaxYCorner]
        
        layer.shadowColor = EPNavController.appearance.shadowColor.cgColor
        layer.shadowOpacity = EPNavController.appearance.shadowOpacity
        layer.shadowRadius = 16
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
}
