//
//  OnboardingMediaItemPickerViewcontroller.swift
//  Often
//
//  Created by Kervins Valcourt on 8/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class OnboardingMediaItemPickerViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UITextFieldDelegate,
    MediaItemGroupViewModelDelegate {
    private var mediaItemsCollectionView: UICollectionView
    private var HUDMaskView: UIView?
    private var hudTimer: NSTimer?

    var viewModel: OnboardingPackViewModel
    var onboardingHeader: OnboardingHeader
    var progressBar: OnboardingProgressBar

    init(viewModel: OnboardingPackViewModel) {
        self.viewModel = viewModel

        onboardingHeader = OnboardingHeader()
        onboardingHeader.translatesAutoresizingMaskIntoConstraints = false

        mediaItemsCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.dynamicType.provideLayout())
        mediaItemsCollectionView.translatesAutoresizingMaskIntoConstraints = false

        progressBar = OnboardingProgressBar(progressIndex: 4.0, endIndex: 8.0, frame: CGRectZero)
        progressBar.translatesAutoresizingMaskIntoConstraints = false

        super.init(nibName: nil, bundle: nil)

        viewModel.delegate = self
        viewModel.fetchData()

        mediaItemsCollectionView.dataSource = self
        mediaItemsCollectionView.delegate = self
        mediaItemsCollectionView.backgroundColor = UIColor.oftWhiteColor()
        mediaItemsCollectionView.registerClass(GifCollectionViewCell.self, forCellWithReuseIdentifier: gifCellReuseIdentifier)
        mediaItemsCollectionView.registerClass(GifCollectionViewCell.self, forCellWithReuseIdentifier: imageCellReuseIdentifier)
        mediaItemsCollectionView.registerClass(MediaItemCollectionViewCell.self, forCellWithReuseIdentifier: MediaItemCollectionViewCellReuseIdentifier)

        view.backgroundColor = UIColor.oftWhiteColor()

        view.addSubview(onboardingHeader)
        view.addSubview(mediaItemsCollectionView)
        view.addSubview(progressBar)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func nextButtonDidTap(sender: UIButton) {}

    func skipButtonDidTap(sender: UIButton) {}


    class func provideLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.mainScreen().bounds.width/2 - 12.5
        let height = width * (4/7)

        layout.itemSize = CGSizeMake(width, height)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 7.0
        layout.minimumLineSpacing = 7.0
        layout.sectionInset = UIEdgeInsets(top: 9.0, left: 9.0, bottom: 9.0, right: 9.0)
        return layout
    }

    func setupLayout() {
        view.addConstraints([
            onboardingHeader.al_top == view.al_top,
            onboardingHeader.al_left == view.al_left,
            onboardingHeader.al_right == view.al_right,
            onboardingHeader.al_height == 200,

            mediaItemsCollectionView.al_top == onboardingHeader.al_bottom + 47,
            mediaItemsCollectionView.al_left == view.al_left,
            mediaItemsCollectionView.al_right == view.al_right,
            mediaItemsCollectionView.al_bottom == view.al_bottom - 20,

            progressBar.al_left == view.al_left,
            progressBar.al_right == view.al_right,
            progressBar.al_bottom == view.al_bottom,
            progressBar.al_height == 5
            ])
    }

    func showHUD() {
        hudTimer?.invalidate()
        hudTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(GiphySearchViewController.hideHUD), userInfo: nil, repeats: false)
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
    }

    func hideHUD() {
        hudTimer?.invalidate()
        PKHUD.sharedHUD.hide(animated: true)
    }

    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let group = viewModel.getMediaItemGroupForCurrentType() else {
            return 0
        }
        return group.items.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let group = viewModel.getMediaItemGroupForCurrentType() else {
            return UICollectionViewCell()
        }

        guard let item = group.items[indexPath.row] as? MediaItem else {
            return UICollectionViewCell()
        }

        return setupCell(group, item: item, indexPath: indexPath, collectionView: collectionView)

    }

    func setupCell(group: MediaItemGroup, item: MediaItem, indexPath: NSIndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        switch item.type {
        case .Gif:
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(gifCellReuseIdentifier, forIndexPath: indexPath) as? GifCollectionViewCell else {
                return UICollectionViewCell()
            }

            guard let gif = item as? GifMediaItem else {
                return cell
            }

            if let imageURL = gif.mediumImageURL {
                cell.setImageWith(imageURL)
            }

            cell.mediaLink = gif

            for items in viewModel.selectedMediaItems {
                if items.id == cell.mediaLink?.id {
                    cell.searchOverlayView.hidden = false
                }
            }

            return cell
        case .Image:
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(imageCellReuseIdentifier, forIndexPath: indexPath) as? GifCollectionViewCell else {
                return UICollectionViewCell()
            }

            guard let image = item as? ImageMediaItem else {
                return cell
            }

            if let imageURL = image.mediumImageURL {
                cell.setImageWith(imageURL)
            }

            cell.mediaLink = image

            for items in viewModel.selectedMediaItems {
                if items.id == cell.mediaLink?.id {
                    cell.searchOverlayView.hidden = false
                }
            }

            return cell
        case .Quote:
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MediaItemCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as? MediaItemCollectionViewCell else {
                return MediaItemCollectionViewCell()
            }

            guard let quote = item as? QuoteMediaItem else {
                return cell
            }
    
            cell.leftHeaderLabel.text = quote.origin_name
            cell.mainTextLabel.text = quote.text
            cell.leftMetadataLabel.text = quote.owner_name
            cell.mainTextLabel.textAlignment = .Right
            cell.showImageView = false
            cell.avatarImageURL =  quote.smallImageURL
            cell.mediaLink = quote

            for items in viewModel.selectedMediaItems {
                if items.id == cell.mediaLink?.id {
                    cell.searchOverlayView.hidden = false
                }
            }

            return cell

        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if viewModel.typeFilter == .Gif || viewModel.typeFilter == .Image {
            return UIEdgeInsets(top: 9.0, left: 9.0, bottom: 60.0, right: 9.0)
        }

        return UIEdgeInsets(top: 9.0, left: 12.0, bottom: 60, right: 12.0)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let group = viewModel.getMediaItemGroupForCurrentType() else {
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

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? GifCollectionViewCell {
            cell.searchOverlayView.hidden = !cell.searchOverlayView.hidden
            if !cell.searchOverlayView.hidden {
                if let item = cell.mediaLink {
                    UserPackService.defaultInstance.addItem(item)
                    viewModel.addMediaItem(item)
                }
            } else {
                if let item = cell.mediaLink {
                    UserPackService.defaultInstance.removeItem(item)
                    viewModel.removeMediaItem(item)
                }
            }

        }

        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MediaItemCollectionViewCell {
            cell.searchOverlayView.hidden = !cell.searchOverlayView.hidden

            if !cell.searchOverlayView.hidden {
                if let item = cell.mediaLink {
                    UserPackService.defaultInstance.addItem(item)
                    viewModel.addMediaItem(item)
                }
            } else {
                if let item = cell.mediaLink {
                    UserPackService.defaultInstance.removeItem(item)
                    viewModel.removeMediaItem(item)
                }
            }

        }
        
    }
    
    func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        mediaItemsCollectionView.reloadData()
    }
}