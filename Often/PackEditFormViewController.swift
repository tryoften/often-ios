//
//  PackEditFormViewController.swift
//  Often
//
//  Created by Luc Succes on 8/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class PackEditFormViewController: UIViewController, UITextFieldDelegate {
    var viewModel: PackItemViewModel
    var editFormView: PackEditFormView
    var colorPickerController: ColorPickerController
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
        navigationView.rightButton.enabled = true

        colorPickerController = ColorPickerController(
            svPickerView: editFormView.colorPicker,
            huePickerView: editFormView.huePicker,
            colorWell: editFormView.colorWell)

        super.init(nibName: nil, bundle: nil)

        editFormView.titleField.delegate = self
        editFormView.descriptionField.delegate = self
        editFormView.uploadPhotoButton.addTarget(self, action: #selector(PackEditFormViewController.didTapUploadButton), forControlEvents: .TouchUpInside)
        navigationView.leftButton.addTarget(self, action: #selector(PackEditFormViewController.didTapCancelButton), forControlEvents: .TouchUpInside)
        navigationView.rightButton.addTarget(self, action: #selector(PackEditFormViewController.didTapSaveButton), forControlEvents: .TouchUpInside)

        view.backgroundColor = WhiteColor

        view.addSubview(editFormView)
        view.addSubview(navigationView)

        setupLayout()
        reloadData()

        colorPickerController.onColorChange = { (color, finished) in
            self.editFormView.packBackgroundColor.backgroundColor = color
        }
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

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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

    func reloadData() {
        guard let pack = viewModel.pack else {
            return
        }

        editFormView.titleField.text = pack.name
        editFormView.descriptionField.text = pack.description
        editFormView.packBackgroundColor.backgroundColor = pack.backgroundColor

        if let color = pack.backgroundColor {
            colorPickerController.color = color
            editFormView.colorPicker.color = color
            editFormView.colorWell.color = color
            editFormView.huePicker.setHueFromColor(color)
        }

        if let largeImageURL = pack.largeImageURL {
            editFormView.coverPhoto.nk_setImageWith(largeImageURL)
        }
    }

    func didTapUploadButton() {

    }

    func didTapCancelButton() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func didTapSaveButton() {
        viewModel.pack?.name = editFormView.titleField.text
        viewModel.pack?.description = editFormView.descriptionField.text
        viewModel.pack?.backgroundColor = colorPickerController.color

        viewModel.saveChanges()
        dismissViewControllerAnimated(true, completion: nil)


    }

    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
