//
//  UploadPhotoButton.swift
//  Often
//
//  Created by Kervins Valcourt on 8/11/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class UploadPhotoButton: UIButton {
    var uploadImageView: UIImageView
    var uploadButtonTitle: UILabel

    override init(frame: CGRect) {
        uploadImageView = UIImageView()
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.contentMode = .ScaleAspectFit
        uploadImageView.image = StyleKit.imageOfCameraIcon(color: UIColor(fromHexString: "#38A5C8"))

        uploadButtonTitle = UILabel()
        uploadButtonTitle.translatesAutoresizingMaskIntoConstraints = false
        uploadButtonTitle.textAlignment = .Center
        uploadButtonTitle.setTextWith(UIFont(name: "OpenSans", size: 12)!, letterSpacing: 0.5, color: UIColor.oftBlack54Color(), text: "upload image")

        super.init(frame: frame)

        addSubview(uploadImageView)
        addSubview(uploadButtonTitle)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            uploadImageView.al_centerY == al_centerY - 10,
            uploadImageView.al_centerX == al_centerX,

            uploadButtonTitle.al_top == uploadImageView.al_bottom - 2,
            uploadButtonTitle.al_left == al_left,
            uploadButtonTitle.al_right == al_right
            ])
    }
}