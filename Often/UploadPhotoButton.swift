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
    var showText: Bool

    init(iconColor: UIColor = UIColor(fromHexString: "#38A5C8"), showText: Bool = true) {
        uploadImageView = UIImageView()
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.contentMode = .ScaleAspectFit
        uploadImageView.image = StyleKit.imageOfCameraIcon(color: iconColor)

        uploadButtonTitle = UILabel()
        uploadButtonTitle.translatesAutoresizingMaskIntoConstraints = false
        uploadButtonTitle.textAlignment = .Center
        uploadButtonTitle.hidden = !showText
        uploadButtonTitle.setTextWith(UIFont(name: "OpenSans", size: 12)!, letterSpacing: 0.5, color: UIColor.oftBlack54Color(), text: "upload image")

        self.showText = showText

        super.init(frame: CGRectZero)

        addSubview(uploadImageView)
        addSubview(uploadButtonTitle)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        let yOffset: CGFloat = showText ? 10 : 0

        addConstraints([
            uploadImageView.al_centerY == al_centerY - yOffset,
            uploadImageView.al_centerX == al_centerX,

            uploadButtonTitle.al_top == uploadImageView.al_bottom - 2,
            uploadButtonTitle.al_left == al_left,
            uploadButtonTitle.al_right == al_right
        ])
    }
}