//
//  PackProfileImageUploaderViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 8/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class PackProfileImageUploaderViewController: ImageUploaderViewController {
    weak var delegate: PackProfileImageUploaderViewControllerDelegate?

    override func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image that the user picked + source url
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let compareString: NSString = info[UIImagePickerControllerReferenceURL]?.absoluteString {

            var uploadTask = FIRStorageUploadTask()
            uploadTask = imageRepresentationForImage(image, compareString: compareString)

            let viewModel = AssignCategoryViewModel(mediaItem: ImageMediaItem(data: [:]))

            PKHUD.sharedHUD.contentView = HUDProgressView()
            PKHUD.sharedHUD.show()

            uploadTask.observeStatus(.Success) { snapshot in
                guard let metadata = snapshot.metadata,
                    let downloadURLs = metadata.downloadURLs,
                    let downloadURL = downloadURLs.first else {
                        return
                }

                self.imageDidSuccessfullyUpload(downloadURL, viewModel: viewModel, completion: { success in
                    if success {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                })
            }

            uploadTask.observeStatus(.Failure) { snapshot in
                guard let storageError = snapshot.error else { return }
                guard let errorCode = FIRStorageErrorCode(rawValue: storageError.code) else { return }
                switch errorCode {
                case .ObjectNotFound:
                    print("File doesn't exist")
                case .Unauthorized:
                    print("User doesn't have permission to access file")
                case .Cancelled:
                    print("User canceled the upload")
                case .Unknown:
                    print("Unknown error occurred, inspect the server response")
                default:
                    print("File doesn't exist sum")
                }
            }
        }

    }

    override func imageDidSuccessfullyUpload(downloadURL: NSURL, viewModel: AssignCategoryViewModel, completion: ((Bool) -> Void)?) {
        let databaseRef = FIRDatabase.database().reference()

        // Get the image from Firebase Storage + Put it in to Image Resizer
        let imageQueue = databaseRef.child("/queues/image_resizing/tasks").childByAutoId()
        let imageId = generateUniqueID()
        let processedImageRef = databaseRef.child("/images/\(imageId)")

        processedImageRef.removeValue()

        imageQueue.setValue([
            "imageId": imageId,
            "url": downloadURL.absoluteString
            ])

        // Listen on image resizer to see if it's done + Pass Image to AssignCategoryViewController
        processedImageRef.observeEventType(.Value, withBlock: { snapshot in
            if let value = snapshot.value as? [String : AnyObject] where self.imageProcessed == false {
                // make the image into an imagemediaitem and then take that to the category assign view controller
                let image = ImageMediaItem(data: value)
                self.delegate?.packProfileImageUploaderViewControllerDidSuccessfullyUpload(self, image: image)
                completion?(true)
            } else {
                completion?(false)
            }
        })
    }
}

protocol PackProfileImageUploaderViewControllerDelegate: class {
    func packProfileImageUploaderViewControllerDidSuccessfullyUpload(imageUploader: PackProfileImageUploaderViewController, image: ImageMediaItem)
}