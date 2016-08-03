//
//  ImageUploaderViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 7/27/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ImageUploaderViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var imagePicker: UIImagePickerController
    private var viewModel: UserPackService
    private var imageProcessed: Bool = false
    private var navigationView: AddContentNavigationView
    
    init(viewModel: UserPackService) {
        imagePicker = UIImagePickerController()
        
        navigationView = AddContentNavigationView()
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.setTitleText("Add Image")
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        imagePicker.delegate = self
        
        navigationView.leftButton.addTarget(self, action: #selector(ImageUploaderViewController.cancelButtonDidTap), forControlEvents: .TouchUpInside)

        view.backgroundColor = MainBackgroundColor
        
        view.addSubview(imagePicker.view)
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imagePicker.view.frame = view.frame
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        navigationController?.navigationBar.barStyle = .Default
    }
    
    func setupLayout() {
        view.addConstraints([
            navigationView.al_top == view.al_top,
            navigationView.al_left == view.al_left,
            navigationView.al_right == view.al_right,
            navigationView.al_height == 65
        ])
    }
    
    func generateUniqueID() -> String {
        let id = NSUUID().UUIDString
        let utf8str = id.dataUsingEncoding(NSUTF8StringEncoding)
        
        if let base64Encoded = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) {
            return base64Encoded
                .stringByReplacingOccurrencesOfString("/", withString: "_")
                .stringByReplacingOccurrencesOfString("+", withString: "-")
                .substringWithRange(Range<String.Index>(base64Encoded.startIndex..<base64Encoded.startIndex.advancedBy(9)))
        }
        
        return ""
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        navigationController?.popViewControllerAnimated(true)
    }

    func cancelButtonDidTap() {
        dismissViewControllerAnimated(true, completion: nil)
    }


    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image that the user picked + source url
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let compareString: NSString = info[UIImagePickerControllerReferenceURL]?.absoluteString {
            
            var uploadTask = FIRStorageUploadTask()
            uploadTask = imageRepresentationForImage(image, compareString: compareString)

            let viewModel = AssignCategoryViewModel(mediaItem: ImageMediaItem(data: [:]))
            let vc = ImageCategoryAssigmentViewController(viewModel: viewModel, localImage: image)

            self.navigationController?.pushViewController(vc, animated: true)

            uploadTask.observeStatus(.Progress) { snapshot in
                if let progress = snapshot.progress {
                    let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)

                    // use percent complete to make waiting loader
                    vc.progressView.setProgress(Float(percentComplete), animated: true)
                }
            }

            uploadTask.observeStatus(.Success) { snapshot in
                guard let metadata = snapshot.metadata,
                    let downloadURLs = metadata.downloadURLs,
                    let downloadURL = downloadURLs.first else {
                    return
                }

                UIView.animateWithDuration(0.2) {
                    vc.progressView.alpha = 0
                    vc.maskView.alpha = 0
                }

                vc.imageUploaded = true
                self.imageDidSuccessfullyUpload(downloadURL, viewModel: viewModel, completion: { success in
                    vc.imageUploaded = vc.imageUploaded
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
    
    func imageRepresentationForImage(image: UIImage, compareString: NSString) -> FIRStorageUploadTask {
        let date = NSDate().timeIntervalSince1970
        print(date)
        
        // Check if the image is a PNG or a JPG and user respective methods + Put in Firebase Storage
        let pngRange: NSRange = compareString.rangeOfString("png", options: [.BackwardsSearch, .CaseInsensitiveSearch])
        if pngRange.location != NSNotFound {
            if let imageData: NSData = UIImagePNGRepresentation(image) {
                return FIRStorage.storage()
                                .referenceForURL("gs://firebase-often-dev.appspot.com/")
                                .child("images/users/\(viewModel.userId)/packPhoto-\(date).png")
                                .putData(imageData)
            }
        }
        
        let jpgRange: NSRange = compareString.rangeOfString("jpg", options: [.BackwardsSearch, .CaseInsensitiveSearch])
        if jpgRange.location != NSNotFound {
            if let imageData: NSData = UIImageJPEGRepresentation(image, 1.0) {
                return FIRStorage.storage()
                                .referenceForURL("gs://firebase-often-dev.appspot.com/")
                                .child("images/users/\(viewModel.userId)/packPhoto-\(date).jpg")
                                .putData(imageData)
            }
        }

        return FIRStorageUploadTask()
    }
    
    func imageDidSuccessfullyUpload(downloadURL: NSURL, viewModel: AssignCategoryViewModel, completion: ((Bool) -> Void)?) {
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
                viewModel.updateMediaItem(image)

                self.imageProcessed = true
                completion?(true)
            } else {
                completion?(false)
            }
        })
    }
}
