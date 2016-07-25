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

        view.addSubview(addContentView)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addContentView.addImageButton.addTarget(self, action: #selector(AddContentViewController.actionButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        addContentView.addGifButton.addTarget(self, action: #selector(AddContentViewController.actionButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        addContentView.addQuoteButton.addTarget(self, action: #selector(AddContentViewController.actionButtonDidTap(_:)), forControlEvents: .TouchUpInside)
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

    func actionButtonDidTap(sender: UIButton) {
        var vc: UIViewController

        if sender.isEqual(addContentView.addGifButton) {
            vc = GiphySearchViewController(viewModel: GiphySearchViewModel())
            navigationController?.pushViewController(vc, animated: true)

        }

        if sender.isEqual(addContentView.addImageButton) {
            print("Image")

        }

        if sender.isEqual(addContentView.addQuoteButton) {
            print("quote")
        }

    }
}