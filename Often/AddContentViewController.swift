//
//  AddContentViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 7/25/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class AddContentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var addContentView: AddContentView
    let storage = FIRStorage.storage()

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
        if sender.isEqual(addContentView.addGifButton) {
            let vc = GiphySearchViewController(viewModel: GiphySearchViewModel())
            navigationController?.pushViewController(vc, animated: true)
        }

        if sender.isEqual(addContentView.addImageButton) {
            let vc = PackImagePickerViewController()
            vc.delegate = self
            presentViewController(vc, animated: true, completion: nil)
        }

        if sender.isEqual(addContentView.addQuoteButton) {
            let vc = AddQuoteViewController(viewModel: UserPackService.defaultInstance)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let compareString: NSString = info[UIImagePickerControllerReferenceURL]?.absoluteString,
            let userId = PacksService.defaultInstance.currentUser?.id {

            let storageRef = storage.referenceForURL("gs://firebase-often-dev.appspot.com/")
            var uploadTask: FIRStorageUploadTask = FIRStorageUploadTask()

            let pngRange: NSRange = compareString.rangeOfString("png", options: [.BackwardsSearch, .CaseInsensitiveSearch])
            if pngRange.location != NSNotFound {
                if let imageData: NSData = UIImagePNGRepresentation(image) {
                    let imageRef = storageRef.child("images/users/\(userId)/packPhoto.png")
                    uploadTask = imageRef.putData(imageData)
                }
            }

            let jpgRange: NSRange = compareString.rangeOfString("jpg", options: [.BackwardsSearch, .CaseInsensitiveSearch])
            if jpgRange.location != NSNotFound {
                if let imageData: NSData = UIImageJPEGRepresentation(image, 1.0) {
                    let imageRef = storageRef.child("images/users/\(userId)/packPhoto.jpg")
                    uploadTask = imageRef.putData(imageData)
                }
            }

            uploadTask.observeStatus(.Progress) { snapshot in
                // Upload reported progress
                if let progress = snapshot.progress {
                    let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                }
            }

            uploadTask.observeStatus(.Success) { snapshot in
                // Successful upload
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

            let imageQueue = FIRDatabase.database().reference().child("/queues/image_resizing/tasks").childByAutoId()
            let imageId = generateIdForString(imageQueue.description())
            imageQueue.setValue([
                "imageId": imageId,
                "url": " https://storage.googleapis.com/firebase-often-dev.appspot.com/images/users/\(userId)/packPhoto.png"
                ])

            let processedImageRef = FIRDatabase.database().reference().child("/images/\(imageId)")
            processedImageRef.observeEventType(.Value, withBlock: { snapshot in
                if let value = snapshot.value as? [String : AnyObject] {
                    // write this image back to the pack
                }
            })
        }

        dismissViewControllerAnimated(true, completion: nil)
    }

    func generateIdForString(string: String) -> String {
        let utf8str = string.dataUsingEncoding(NSUTF8StringEncoding)

        if let base64Encoded = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) {
            return base64Encoded
                .stringByReplacingOccurrencesOfString("/", withString: "_")
                .stringByReplacingOccurrencesOfString("+", withString: "-")
                .substringWithRange(Range<String.Index>(base64Encoded.startIndex..<base64Encoded.startIndex.advancedBy(9)))
        }

        return ""
    }
}