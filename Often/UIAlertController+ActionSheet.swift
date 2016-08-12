//
//  TapStateActionViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/11/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit
import Firebase
import Nuke
import NukeAnimatedImagePlugin

extension UIAlertController: UIViewControllerTransitioningDelegate {
    func tapStateActionSheet(result: MediaItem, url: NSURL?) -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        var data: NSData = NSData()
        
        if let url = url {
            Nuke.taskWith(url) {
                if let image = $0.image as? AnimatedImage, let imageData = image.data {
                    data = imageData
                }
                }.resume()
        }
        
        let shareAction = UIAlertAction(title: "Share", style: .Default, handler: { (alert: UIAlertAction) in
            let activityVC: UIActivityViewController
            if url != nil {
                UIPasteboard.generalPasteboard().setData(data, forPasteboardType: "com.compuserve.gif")
                let shareObjects = [data]
                activityVC = UIActivityViewController(activityItems: shareObjects, applicationActivities: nil)
            } else {
                activityVC = UIActivityViewController(activityItems: [result.getInsertableText()], applicationActivities: nil)
            }
            
            activityVC.excludedActivityTypes = [UIActivityTypeAddToReadingList]
            activityVC.popoverPresentationController?.sourceView = self.view
            self.presentViewController(activityVC, animated: true, completion: nil)
        })
        
        let packEditAction: UIAlertAction
        if PacksService.defaultInstance.checkFavoritesMediaItem(result) {
            packEditAction = UIAlertAction(title: "Remove", style: .Default, handler: { (alert: UIAlertAction) in
                UserPackService.defaultInstance.removeItem(result)
            })
        } else {
            packEditAction = UIAlertAction(title: "Add to Pack", style: .Default, handler: { (alert: UIAlertAction) in
                UserPackService.defaultInstance.addItem(result)
                NSNotificationCenter.defaultCenter().postNotificationName(PresentUserProfileEvent, object: nil)
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { alert in
            actionSheet.dismissViewControllerAnimated(true, completion: nil)
        })
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(packEditAction)
        actionSheet.addAction(cancelAction)
        
        return actionSheet
    }
    
    func barButtonActionSheet(name: String, link: String, sender: UIButton, id: String) -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: .Default, handler: { alert in
            let shareObjects = ["Yo check out this \(name) keyboard I found on Often! \(link)"]
            
            let activityVC = UIActivityViewController(activityItems: shareObjects, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityTypeAddToReadingList]
            activityVC.popoverPresentationController?.sourceView = sender
            self.presentViewController(activityVC, animated: true, completion: nil)
        })
        
        let reportAction = UIAlertAction(title: "Report", style: .Default, handler: { alert in
            let reportsRef = FIRDatabase.database().reference().child("reports").childByAutoId()
            let reportItem = ["pack_id": id]
            
            reportsRef.setValue(reportItem)
            actionSheet.dismissViewControllerAnimated(true, completion: nil)
            
            let AlertVC = ReportAlertViewController()
            AlertVC.transitioningDelegate = self
            AlertVC.modalPresentationStyle = .Custom
            self.presentViewController(AlertVC, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { alert in
            actionSheet.dismissViewControllerAnimated(true, completion: nil)
        })
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)
        
        return actionSheet
    }

}
