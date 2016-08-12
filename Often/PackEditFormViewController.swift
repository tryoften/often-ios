//
//  PackEditFormViewController.swift
//  Often
//
//  Created by Luc Succes on 8/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class PackEditFormViewController: UIViewController {
    var viewModel: PackItemViewModel
    var editFormView: PackEditFormView
    private var navigationView: AddContentNavigationView

    init(viewModel: PackItemViewModel) {
        self.viewModel = viewModel

        editFormView = PackEditFormView()
        editFormView.translatesAutoresizingMaskIntoConstraints = false

        navigationView = AddContentNavigationView()
        navigationView.backgroundColor = UIColor.clearColor()
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.layer.borderColor = UIColor.clearColor().CGColor
        navigationView.setLeftButtonText("Cancel", color: WhiteColor)
        navigationView.setTitleText("Edit Pack", color: WhiteColor)
        navigationView.setRightButtonText("Save", color: WhiteColor)

        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = WhiteColor

        view.addSubview(editFormView)
        view.addSubview(navigationView)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barStyle = .Black
            navigationBar.translucent = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupLayout() {
        view.addConstraints([
            navigationView.al_top == view.al_top,
            navigationView.al_left == view.al_left,
            navigationView.al_right == view.al_right,
            navigationView.al_height == 65,

            editFormView.al_top == view.al_top,
            editFormView.al_left == view.al_left,
            editFormView.al_right == view.al_right,
            editFormView.al_bottom == view.al_bottom
        ])
    }

}
