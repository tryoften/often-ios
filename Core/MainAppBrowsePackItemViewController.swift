//
//  BrowsePackItemViewController.swift
//  Often
//
//  Created by Luc Succes on 3/30/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit
import Nuke
import NukeAnimatedImagePlugin
import Firebase

private let PackPageHeaderViewIdentifier = "packPageHeaderViewIdentifier"

class MainAppBrowsePackItemViewController: BaseBrowsePackItemViewController, FilterTabDelegate, UIActionSheetDelegate {
    override init(viewModel: PackItemViewModel, textProcessor: TextProcessingManager?) {

        super.init(viewModel: viewModel, textProcessor: textProcessor)
        
        packCollectionListener = viewModel.didUpdateCurrentMediaItem.on { [weak self] items in
            self?.collectionView?.setContentOffset(CGPointZero, animated: true)
            self?.collectionView?.reloadData()
            self?.packViewModel.checkCurrentPackContents()
            self?.headerViewDidLoad()
        }
        
        collectionView?.registerClass(PackPageHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: PackPageHeaderViewIdentifier)
        collectionView?.registerClass(MediaItemPageHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: MediaItemPageHeaderViewIdentifier)
        
        hudTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("showHud"), userInfo: nil, repeats: false)
    }

    deinit {
        packCollectionListener = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        headerViewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showHud()
        loadPackData()
    }
    
    override func headerViewDidLoad() {
        let imageURL: NSURL? = packViewModel.pack?.largeImageURL
        let subtitle: String? = packViewModel.pack?.description

        setupHeaderView(imageURL, title: packViewModel.pack?.name, subtitle: subtitle)
    }
    
    override func setupHeaderView(imageURL: NSURL?, title: String?, subtitle: String?) {
        guard let header = headerView as? PackPageHeaderView, let pack = packViewModel.pack else {
            return
        }
        self.hideHud()
        
        if let text = title {
            header.title = text
        }

        if let string = subtitle {
            header.subtitle = string
        }

        if let backgroundColor = pack.backgroundColor {
            header.packBackgroundColor.backgroundColor = backgroundColor
        }
        
        header.tabContainerView.mediaTypes = Array(pack.availableMediaType.keys)

        header.imageURL = imageURL
        header.tabContainerView.delegate = self
        
        let topRightButton = HeaderButton()
        let positionedButtonView = UIView(frame: CGRectMake(0, 0, 100, 30))
        positionedButtonView.addSubview(topRightButton)
        
        if pack.isFavorites {
            header.primaryButton.packState = .User
            header.primaryButton.addTarget(self, action: #selector(MainAppBrowsePackItemViewController.topRightButtonTapped(_:)), forControlEvents: .TouchUpInside)
            
            let topRightButton = HeaderButton()
            topRightButton.text = "Edit Pack"
            topRightButton.textLabel.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
            topRightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 65, bottom: 2, right: -10)
            topRightButton.frame = CGRect(x: 0, y: 0, width: 90, height: 30)
            topRightButton.setImage(StyleKit.imageOfEditIcon(color: WhiteColor, scale: 1), forState: .Normal)

            let item = UIBarButtonItem(customView: topRightButton)
            navigationItem.rightBarButtonItem = item
        } else {
            header.primaryButton.title = pack.callToActionText()
            header.primaryButton.addTarget(self, action: #selector(MainAppBrowsePackItemViewController.primaryButtonTapped(_:)), forControlEvents: .TouchUpInside)
            header.primaryButton.packState = PacksService.defaultInstance.checkPack(pack) ? .Added : .NotAdded

            let topRightButton = PackHeaderProfileButton()
            if let owner = pack.owner, let username = owner["username"] as? String {
                topRightButton.text = "@\(username)"
            }

            topRightButton.frame = CGRect(origin: CGPointZero, size: topRightButton.intrinsicContentSize())
            topRightButton.addTarget(self, action: #selector(MainAppBrowsePackItemViewController.topRightButtonTapped(_:)), forControlEvents: .TouchUpInside)

            let item = UIBarButtonItem(customView: topRightButton)
            navigationItem.rightBarButtonItem = item
        }
    }

    func primaryButtonTapped(sender: UIButton) {
        guard let button = sender as? BrowsePackDownloadButton else {
            return
        }

        showHud()
        hudTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(MediaItemsCollectionBaseViewController.hideHud), userInfo: nil, repeats: false)

        if let pack = packViewModel.pack {
            if PacksService.defaultInstance.checkPack(pack) {
                PacksService.defaultInstance.removePack(pack)
                button.packState = .NotAdded
            } else {
                PacksService.defaultInstance.addPack(pack)
                button.packState = .Added

                if packViewModel.showPushNotificationAlertForPack() {
                    hudTimer?.invalidate()
                    hideHud()

                    let AlertVC = PushNotificationAlertViewController()
                    AlertVC.transitioningDelegate = self
                    AlertVC.modalPresentationStyle = .Custom
                    presentViewController(AlertVC, animated: true, completion: nil)
                }
            }
        }
    }

    func topRightButtonTapped(sender: UIButton) {
        guard let pack = packViewModel.pack, name = pack.name, link = pack.shareLink, id = pack.pack_id else {
            return
        }
        
        let actionSheet = UIAlertController().barButtonActionSheet(name, link: link, sender: sender, id: id)
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: PackPageHeaderViewIdentifier, forIndexPath: indexPath) as? PackPageHeaderView else {
                return UICollectionReusableView()
            }
            
            if headerView == nil {
                headerView = cell
            }
            
            headerViewDidLoad()
            
            return headerView!
        } else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
        }
    }

    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if packViewModel.typeFilter == .Gif || packViewModel.typeFilter == .Image {
            return UIEdgeInsets(top: 9.0, left: 9.0, bottom: 60.0, right: 9.0)
        }
        
        return UIEdgeInsets(top: 9.0, left: 12.0, bottom: 60, right: 12.0)
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let group = packViewModel.getMediaItemGroupForCurrentType() else {
            return CGSizeZero
        }
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        switch group.type {
        case .Gif:
            var width: CGFloat
            
            if screenHeight > screenWidth {
                width = screenWidth / 2 - 12.5
            } else {
                width = screenWidth / 3 - 12.5
            }
            
            let height = width * (4/7)
            return CGSizeMake(width, height)
        case .Quote:
            var width: CGFloat
            
            if screenHeight > screenWidth {
                width = screenWidth / 2 - 15.5
            } else {
                width = screenWidth / 3 - 15.5
            }
            
            let height = screenHeight / 4
            return CGSizeMake(width, height)
        case .Image:
            var width: CGFloat

            if screenHeight > screenWidth {
                width = screenWidth / 3 - 12.5
            } else {
                width = screenWidth / 4 - 12.5
            }

            let height = width
            return CGSizeMake(width, height)
        default:
            return CGSizeZero
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? BaseMediaItemCollectionViewCell,
            let result = cell.mediaLink  else {
                return
        }
        
        let vc = MediaItemDetailViewController(mediaItem: result, textProcessor: textProcessor)
        if let gifCell = cell as? GifCollectionViewCell, let url = result.mediumImageURL {
            // Copy this data to pasteboard
            let actionSheet = UIAlertController().tapStateActionSheet(result, url: url)
            self.presentViewController(actionSheet, animated: true, completion: nil)
        } else {
            let actionSheet = UIAlertController().tapStateActionSheet(result, url: nil)
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
        
        vc.insertText()
    }
    
    override func mediaLinkCollectionViewCellDidToggleCopyButton(cell: BaseMediaItemCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }
        
        if selected {
            NSNotificationCenter.defaultCenter().postNotificationName("mediaItemInserted", object: cell.mediaLink)
            if let gifCell = cell as? GifCollectionViewCell, let url = result.mediumImageURL {
                // Copy this data to pasteboard
                Nuke.taskWith(url) {
                    if let image = $0.image as? AnimatedImage, let data = image.data {
                        UIPasteboard.generalPasteboard().setData(data, forPasteboardType: "com.compuserve.gif")
                        gifCell.showDoneMessage()
                    }
                    }.resume()
                
            } else {
                UIPasteboard.generalPasteboard().string = result.getInsertableText()
            }
            
            Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.insertedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(result.toDictionary()))
            
            if let gifCell = cell as? GifCollectionViewCell, let url = result.mediumImageURL {
                let actionSheet = UIAlertController().tapStateActionSheet(result, url: url)
                self.presentViewController(actionSheet, animated: true, completion: nil)
            } else {
                UIPasteboard.generalPasteboard().string = result.getInsertableText()
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 7.0
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 7.0
    }

    func gifTabSelected() {
        collectionView?.setContentOffset(CGPointZero, animated: true)
        
        if packViewModel.doesCurrentPackContainTypeForCategory(.Gif) {
            packViewModel.typeFilter = .Gif
        }
    }
    
    func quotesTabSelected() {
        collectionView?.setContentOffset(CGPointZero, animated: true)
        
        if packViewModel.doesCurrentPackContainTypeForCategory(.Quote) {
            packViewModel.typeFilter = .Quote
        }
    }
    
    func imagesTabSelected() {
        collectionView?.setContentOffset(CGPointZero, animated: true)

        if packViewModel.doesCurrentPackContainTypeForCategory(.Image) {
            packViewModel.typeFilter = .Image
        }
    }
}
