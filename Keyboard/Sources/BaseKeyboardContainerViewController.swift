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
    static var oncePredicate: dispatch_once_t = 0

    static func sharedApplication(viewController: UIViewController) throws -> UIApplication {
        var responder: UIResponder? = viewController
        while responder != nil {
            if let application = responder as? UIApplication {
                return application
            }

            responder = responder?.nextResponder()
        }
        throw NSError(domain: "UIInputViewController+sharedApplication.swift", code: 1, userInfo: nil)
    }

    init(extraHeight: CGFloat = 64) {
        containerView = UIView()
        containerView.backgroundColor = UIColor.whiteColor()
        keyboardExtraHeight = extraHeight

        super.init(nibName: nil, bundle: nil)

        view.addSubview(containerView)

        NSUserDefaults.standardUserDefaults().setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }

    override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.init(extraHeight: 64)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHeight = heightForOrientation(interfaceOrientation, withTopBanner: true)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        keyboardHeight = heightForOrientation(interfaceOrientation, withTopBanner: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.bounds == CGRectZero {
            return
        }
        setupKludge()
        containerView.frame = CGRectMake(0, 0, view.bounds.width, heightForOrientation(interfaceOrientation, withTopBanner: true))

    }

    func switchKeyboard() {
        advanceToNextInputMode()
    }

    func showKeyboard(animated: Bool = false) {}

    func hideKeyboard(animated: Bool = false) {}

    override func textDidChange(textInput: UITextInput?) {
        textProcessor?.textDidChange(textInput)
    }

    override func textWillChange(textInput: UITextInput?) {
        textProcessor?.textWillChange(textInput)
    }

    #if !(KEYBOARD_DEBUG)
    override func updateViewConstraints() {
        super.updateViewConstraints()

        if view.bounds == CGRectZero {
            return
        }

        setHeight(keyboardHeight)
    }
    #endif

    func heightForOrientation(orientation: UIInterfaceOrientation, withTopBanner: Bool) -> CGFloat {
        let isPad = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad

        //TODO: hardcoded stuff
        let actualScreenWidth = UIScreen.mainScreen().nativeBounds.size.width / UIScreen.mainScreen().nativeScale
        let canonicalPortraitHeight = (isPad ? CGFloat(264) : CGFloat(orientation.isPortrait && actualScreenWidth >= 400 ? 226 : 216))
        let canonicalLandscapeHeight = (isPad ? CGFloat(352) : CGFloat(162))
        let topBannerHeight: CGFloat = withTopBanner ? keyboardExtraHeight : 0.0

        return CGFloat(orientation.isPortrait ? canonicalPortraitHeight : canonicalLandscapeHeight) + topBannerHeight
    }

    func setHeight(height: CGFloat) {
        if heightConstraint == nil {
            heightConstraint = NSLayoutConstraint(
                item:view,
                attribute:NSLayoutAttribute.Height,
                relatedBy:NSLayoutRelation.Equal,
                toItem:nil,
                attribute:NSLayoutAttribute.NotAnAttribute,
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
            kludge.hidden = true

            view.addConstraints([
                kludge.al_left == view.al_left,
                kludge.al_right == view.al_left,
                kludge.al_top == view.al_top,
                kludge.al_bottom == view.al_bottom
            ])

            self.kludge = kludge
        }
    }

    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        keyboardHeight = heightForOrientation(toInterfaceOrientation, withTopBanner: true)
        NSNotificationCenter.defaultCenter().postNotificationName(KeyboardOrientationChangeEvent, object: self)
    }
}