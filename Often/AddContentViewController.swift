//
//  AddPackViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 7/25/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AddPackViewController: UIViewController {
    var addPackView: AddPackView

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        addPackView = AddPackView()
        addPackView.translatesAutoresizingMaskIntoConstraints = false

        super.init(nibName: nil, bundle: nil)

        view.addSubview(addPackView)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addPackView.addImageButton.addTarget(self, action: #selector(AddPackViewController.actionButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        addPackView.addGifButton.addTarget(self, action: #selector(AddPackViewController.actionButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        addPackView.addQuoteButton.addTarget(self, action: #selector(AddPackViewController.actionButtonDidTap(_:)), forControlEvents: .TouchUpInside)
    }

    func setupLayout() {
        view.addConstraints([
            addPackView.al_top == view.al_top,
            addPackView.al_left == view.al_left,
            addPackView.al_right == view.al_right,
            addPackView.al_bottom == view.al_bottom
            ])
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.hidden = true
        
    }

    func actionButtonDidTap(sender: UIButton) {
        var vc: UIViewController

        if sender.isEqual(addPackView.addGifButton) {
            vc = GiphySearchViewController(viewModel: GiphySearchViewModel())
            navigationController?.pushViewController(vc, animated: true)

        }

        if sender.isEqual(addPackView.addImageButton) {
            print("Image")

        }

        if sender.isEqual(addPackView.addQuoteButton) {
            print("quote")
        }

    }
}