//
//  KeyboardBaseViewController.swift
//  Often
//
//  Created by Luc Succes on 12/8/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

/// Base class for container keyboard view controller, create subclass for keyboard
/// logic.
class BaseKeyboardContainerViewController: UIInputViewController {
    var heightConstraint: NSLayoutConstraint?
    var constraintsAdded: Bool = false
    var containerView: UIView
    var keyboardExtraHeight: CGFloat
    var textProcessor: TextProcessingManager?

    private var kludge: UIView?
    var keyboardHeight: CGFloat {
        get {
            if let constraint = heightConstraint {
                return constraint.constant
            } else {
                return 0
            }
        }
        set {
            setHeight(newValue)
        }
    }
    static var oncePredicate: Int = 0

    static func sharedApplication(_ viewController: UIViewController) throws -> UIApplication {
        var responder: UIResponder? = viewController
        while responder != nil {
            if let application = responder as? UIApplication {
                return application
            }

            responder = responder?.next()
        }
        throw NSError(domain: "UIInputViewController+sharedApplication.swift", code: 1, userInfo: nil)
    }

    init(extraHeight: CGFloat = 64) {
        containerView = UIView()
        containerView.backgroundColor = UIColor.white()
        keyboardExtraHeight = extraHeight

        super.init(nibName: nil, bundle: nil)

        view.addSubview(containerView)

        UserDefaults.standard().setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }

    override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init(extraHeight: 64)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHeight = heightForOrientation(interfaceOrientation, withTopBanner: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        keyboardHeight = heightForOrientation(interfaceOrientation, withTopBanner: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.bounds == CGRect.zero {
            return
        }
        setupKludge()
        containerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: heightForOrientation(interfaceOrientation, withTopBanner: true))

    }

    func switchKeyboard() {
        advanceToNextInputMode()
    }

    func showKeyboard(_ animated: Bool = false) {}

    func hideKeyboard(_ animated: Bool = false) {}

    override func textDidChange(_ textInput: UITextInput?) {
        textProcessor?.textDidChange(textInput)
    }

    override func textWillChange(_ textInput: UITextInput?) {
        textProcessor?.textWillChange(textInput)
    }

    #if !(KEYBOARD_DEBUG)
    override func updateViewConstraints() {
        super.updateViewConstraints()

        if view.bounds == CGRect.zero {
            return
        }

        setHeight(keyboardHeight)
    }
    #endif

    func heightForOrientation(_ orientation: UIInterfaceOrientation, withTopBanner: Bool) -> CGFloat {
        let isPad = UIDevice.current().userInterfaceIdiom == UIUserInterfaceIdiom.pad

        //TODO: hardcoded stuff
        let actualScreenWidth = UIScreen.main().nativeBounds.size.width / UIScreen.main().nativeScale
        let canonicalPortraitHeight = (isPad ? CGFloat(264) : CGFloat(orientation.isPortrait && actualScreenWidth >= 400 ? 226 : 216))
        let canonicalLandscapeHeight = (isPad ? CGFloat(352) : CGFloat(162))
        let topBannerHeight: CGFloat = withTopBanner ? keyboardExtraHeight : 0.0

        return CGFloat(orientation.isPortrait ? canonicalPortraitHeight : canonicalLandscapeHeight) + topBannerHeight
    }

    func setHeight(_ height: CGFloat) {
        if heightConstraint == nil {
            heightConstraint = NSLayoutConstraint(
                item:view,
                attribute:NSLayoutAttribute.height,
                relatedBy:NSLayoutRelation.equal,
                toItem:nil,
                attribute:NSLayoutAttribute.notAnAttribute,
                multiplier:0,
                constant:height)
            heightConstraint!.priority = 1000
            view.addConstraint(heightConstraint!)
        } else {
            heightConstraint?.constant = height
        }

   #if KEYBOARD_DEBUG
        if let window = view.window {
            var frame = window.frame
            frame.origin.y = UIScreen.mainScreen().bounds.size.height - height
            frame.size.height = height
            window.frame = frame
        }
    #endif
    }

    func setupKludge() {
        if kludge == nil {
            let kludge = UIView()
            view.addSubview(kludge)
            kludge.translatesAutoresizingMaskIntoConstraints = false
            kludge.isHidden = true

            view.addConstraints([
                kludge.al_left == view.al_left,
                kludge.al_right == view.al_left,
                kludge.al_top == view.al_top,
                kludge.al_bottom == view.al_bottom
            ])

            self.kludge = kludge
        }
    }

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        keyboardHeight = heightForOrientation(toInterfaceOrientation, withTopBanner: true)
        NotificationCenter.default().post(name: Foundation.Notification.Name(rawValue: KeyboardOrientationChangeEvent), object: self)
    }
}
