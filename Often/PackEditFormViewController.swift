//
//  PackEditFormViewController.swift
//  Often
//
//  Created by Luc Succes on 8/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class PackEditFormViewController: UIViewController, UITextFieldDelegate,
    PackProfileImageUploaderViewControllerDelegate {
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
        reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barStyle = .Black
            navigationBar.translucent = true
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        updateColorPicker()
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

        if let backgroundColor = pack.backgroundColor {
            editFormView.packBackgroundColor.backgroundColor = backgroundColor
        } else {
            editFormView.packBackgroundColor.backgroundColor = UIColor.blackColor()
        }

        if let largeImageURL = pack.largeImageURL {
            editFormView.coverPhoto.nk_setImageWith(largeImageURL)
        }

        updateColorPicker()
    }

    func updateColorPicker() {
        if let color = viewModel.pack?.backgroundColor {
            colorPickerController.color = color
            editFormView.colorPicker.color = color
            editFormView.colorWell.color = color
            editFormView.huePicker.setHueFromColor(color)
        }
    }

    func didTapUploadButton() {
        let vc = PackProfileImageUploaderViewController(viewModel: UserPackService.defaultInstance)
        vc.delegate = self
        presentViewController(vc, animated: true, completion: nil)
    }

    func didTapCancelButton() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func didTapSaveButton() {
        guard let name = editFormView.titleField.text,
            description = editFormView.descriptionField.text,
            backgroundColor = editFormView.packBackgroundColor.backgroundColor else {
            return
        }

        let data: [String: AnyObject] = [
            "name": name,
            "description": description,
            "backgroundColor": backgroundColor.hexString
        ]

        viewModel.pack?.name = name
        viewModel.pack?.description = description
        viewModel.pack?.backgroundColor = backgroundColor

        viewModel.saveChanges(data)
        
        dismissViewControllerAnimated(true, completion: {
            self.viewModel.delegate?.mediaItemGroupViewModelDataDidLoad(self.viewModel, groups: self.viewModel.mediaItemGroups)
        })
    }

    func packProfileImageUploaderViewControllerDidSuccessfullyUpload(imageUploader: PackProfileImageUploaderViewController, image: ImageMediaItem) {
        guard let imageURL = image.largeImageURL else {
            return
        }

        print(imageURL.absoluteString)
        editFormView.uploadPhotoButton.hidden = true
        viewModel.updatePackProfileImage(image)

        delay(0.5, closure: {
            self.editFormView.coverPhoto.nk_setImageWith(imageURL)
            PKHUD.sharedHUD.hide(animated: true)
        })
    }

    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
