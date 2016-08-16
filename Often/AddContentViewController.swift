//
//  AddContentViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 7/25/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation


class AddContentViewController: UIViewController {
    var addContentView: AddContentView

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        addContentView = AddContentView()
        addContentView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = UIColor.oftBlackColor().colorWithAlphaComponent(0.5)
        view.addSubview(addContentView)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddContentViewController.addContentViewDidDismiss), name: AddContentViewDismissedEvent, object: nil)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addContentView.addImageButton.addTarget(self, action: #selector(AddContentViewController.actionButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        addContentView.addGifButton.addTarget(self, action: #selector(AddContentViewController.actionButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        addContentView.addQuoteButton.addTarget(self, action: #selector(AddContentViewController.actionButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        addContentView.cancelButton.addTarget(self, action: #selector(AddContentViewController.actionButtonDidTap(_:)), forControlEvents: .TouchUpInside)
    }

    func setupLayout() {
        view.addConstraints([
            addContentView.al_top == view.al_top,
            addContentView.al_left == view.al_left,
            addContentView.al_right == view.al_right,
            addContentView.al_bottom == view.al_bottom
        ])
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.hidden = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        addContentView.animateButtons()

        if !SessionManagerFlags.defaultManagerFlags.hasSeeAddContentPrompt {
            AddContentPrompt().showPrompt()
        }
    }

    func actionButtonDidTap(sender: UIButton) {
         AddContentPrompt().dismissAllPrompt()

        if sender.isEqual(addContentView.addGifButton) {
            let vc = ContainerNavigationController(rootViewController: GiphySearchViewController(viewModel: GiphySearchViewModel()))
            vc.navigationBar.hidden = true
            presentViewController(vc, animated: true, completion: nil)
        }

        if sender.isEqual(addContentView.addImageButton) {
            let vc = ContainerNavigationController(rootViewController: ImageUploaderViewController(viewModel: UserPackService.defaultInstance))
            navigationController?.pushViewController(vc, animated: true)
            vc.navigationBar.hidden = true
            presentViewController(vc, animated: true, completion: nil)
        }

        if sender.isEqual(addContentView.addQuoteButton) {
            let vc = ContainerNavigationController(rootViewController: AddQuoteViewController(viewModel: UserPackService.defaultInstance))
            vc.navigationBar.hidden = true
            presentViewController(vc, animated: true, completion: nil)
        }

        if sender.isEqual(addContentView.cancelButton) {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func addContentViewDidDismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}