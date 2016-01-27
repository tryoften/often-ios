//
//  SearchResultsCollectionViewController.swift
//  Surf
//
//  Created by Komran Ghahremani on 7/31/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let SearchResultsInsertLinkEvent = "SearchResultsCollectionViewCell.insertButton"

/// This class displays search results for a given response object
/// TODO(luc): Merge class with BrowseViewController since they're very similar
class SearchResultsCollectionViewController: MediaItemsCollectionBaseViewController, UICollectionViewDelegateFlowLayout, MessageBarDelegate {
    var searchBarController: SearchBarController?
    var browseViewModel: BrowseViewModel?
    var response: SearchResponse? {
        didSet {
            if let response = response {
                browseViewModel = BrowseViewModel(path: "responses/\(response.id)/results")
            }
            refreshTimer?.invalidate()
            emptyStateView?.alpha = 0.0
        }

        willSet(newValue) {
            if let response = response {
                oldResponse = response
            }
        }
    }
    
    // object the current response needs to be replaced/updated with
    var nextResponse: SearchResponse?
    var lyricsHorizontalVC: TrendingLyricsHorizontalCollectionViewController?
    var artistsHorizontalVC: TrendingArtistsHorizontalCollectionViewController?
    var refreshResultsButton: RefreshResultsButton
    var refreshResultsButtonTopConstraint: NSLayoutConstraint!
    var refreshTimer: NSTimer?
    var messageBarView: MessageBarView
    var displayedData: Bool
    var messageBarVisibleConstraint: NSLayoutConstraint?

    private var oldResponse: SearchResponse?

    var contentInset: UIEdgeInsets {
        didSet {
            collectionView?.contentInset = contentInset
        }
    }

    var isFullAccessEnabled: Bool {
        let pbWrapped: UIPasteboard? = UIPasteboard.generalPasteboard()
        if let _ = pbWrapped {
            return true
        } else {
            return false
        }
    }

    init(collectionViewLayout layout: UICollectionViewLayout, textProcessor: TextProcessingManager?) {
    #if KEYBOARD
        contentInset = UIEdgeInsetsMake(2 * KeyboardSearchBarHeight, 0, 0, 0)
    #else
        contentInset = UIEdgeInsetsMake(68, 0, 0, 0)
    #endif
        
        refreshResultsButton = RefreshResultsButton()
        refreshResultsButton.translatesAutoresizingMaskIntoConstraints = false
        
        messageBarView = MessageBarView()

        displayedData = false
        
        super.init(collectionViewLayout: layout)

        self.textProcessor = textProcessor
        
        emptyStateView?.primaryButton.addTarget(self, action: "didTapSettingsButton", forControlEvents: .TouchUpInside)
        emptyStateView?.closeButton.addTarget(self, action: "didTapCancelButton", forControlEvents: .TouchUpInside)
        emptyStateView?.userInteractionEnabled = true
        
        view.layer.masksToBounds = true
        view.addSubview(refreshResultsButton)
        view.backgroundColor = VeryLightGray
        view.addSubview(messageBarView)

        messageBarView.delegate = self
        refreshResultsButton.addTarget(self, action: "didTapRefreshResultsButton", forControlEvents: .TouchUpInside)
        
        // Register cell classes
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView?.registerClass(TrackCollectionViewCell.self, forCellWithReuseIdentifier: songCellReuseIdentifier)
        collectionView?.registerClass(MediaItemsSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier)
        collectionView?.contentInset = contentInset
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textProcessor: TextProcessingManager?) {
        self.init(collectionViewLayout: SearchResultsCollectionViewController.provideCollectionViewFlowLayout(), textProcessor: textProcessor)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.clearColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if isFullAccessEnabled {
            hideMessageBar()
        } else {
            showMessageBar()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    class func provideCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 105)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 5.0
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 40.0, right: 10.0)
        return layout
    }

    private func groupAtIndex(section: Int) -> MediaItemGroup? {
        if let group = response?.groups[section] where section < response?.groups.count {
            return group
        }
        return nil
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let response = response {
            return response.groups.count
        }
        return 0
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let group = groupAtIndex(section) else {
            return 0
        }

        switch group.type {
        case .Track:
            return group.items.count
        default:
            return 1
        }
    }


    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView,
            let group = groupAtIndex(indexPath.section) else {
                return UICollectionReusableView()
        }

        cell.topSeperator.hidden = indexPath.section == 0
        cell.leftText = group.title

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let baseSize = CGSizeMake(screenWidth, 115)

        guard let group = groupAtIndex(indexPath.section) else {
            return baseSize
        }

        switch group.type {
        case .Lyric:
            return CGSizeMake(screenWidth, 125)
        case .Artist:
            return CGSizeMake(screenWidth, 230)
        case .Track:
            return CGSizeMake(screenWidth - 20, 74)
        default:
            return baseSize
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        guard let group = groupAtIndex(section) else {
            return UIEdgeInsetsZero
        }

        switch group.type {
        case .Track:
            return UIEdgeInsets(top: 10, left: 10, bottom: 50, right: 10)
        default:
            return UIEdgeInsetsZero
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        return CGSizeMake(screenWidth, 36)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let group = groupAtIndex(indexPath.section) else {
            return UICollectionViewCell()
        }

        switch group.type {
        case .Lyric:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
            let lyricsHorizontalVC = provideTrendingLyricsHorizontalCollectionViewController()
            lyricsHorizontalVC.group = group

            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.addSubview(lyricsHorizontalVC.view)
            lyricsHorizontalVC.view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            lyricsHorizontalVC.view.frame = cell.bounds

            return cell
        case .Artist:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
            let artistsHorizontalVC = provideTrendingArtistsHorizontalCollectionViewController()
            artistsHorizontalVC.group = group

            cell.contentView.addSubview(artistsHorizontalVC.view)
            artistsHorizontalVC.view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            artistsHorizontalVC.view.frame = cell.bounds

            self.artistsHorizontalVC = artistsHorizontalVC
            return cell
        case .Track:
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(songCellReuseIdentifier, forIndexPath: indexPath) as? TrackCollectionViewCell, let track = group.items[indexPath.row] as? TrackMediaItem else {
                return TrackCollectionViewCell()
            }

            if let imageURLStr = track.song_art_image_url, let imageURL = NSURL(string: imageURLStr) {
                cell.imageView.setImageWithAnimation(imageURL)
            }
            cell.titleLabel.text = track.album_name
            cell.subtitleLabel.text = track.artist_name
            cell.titleLabel.text = track.title
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.mainScreen().scale

            if cellsAnimated[indexPath] != true {
                animateCell(cell, indexPath: indexPath)
                cellsAnimated[indexPath] = true
            }

            return cell
        default:
            return UICollectionViewCell()
        }
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let group = groupAtIndex(indexPath.section) where indexPath.section == 2,
            let viewModel = browseViewModel,
            let track = group.items[indexPath.row] as? TrackMediaItem else {
                return
        }

        let lyricsVC = BrowseLyricsCollectionViewController(trackId: track.id, viewModel: viewModel)
        self.navigationController?.pushViewController(lyricsVC, animated: true)
    }

    func provideTrendingLyricsHorizontalCollectionViewController() -> TrendingLyricsHorizontalCollectionViewController {
        if lyricsHorizontalVC == nil {
            lyricsHorizontalVC = TrendingLyricsHorizontalCollectionViewController()
            lyricsHorizontalVC?.textProcessor = textProcessor
            addChildViewController(lyricsHorizontalVC!)
        }
        return lyricsHorizontalVC!
    }

    func provideTrendingArtistsHorizontalCollectionViewController() -> TrendingArtistsHorizontalCollectionViewController {

        if artistsHorizontalVC == nil {
            artistsHorizontalVC = TrendingArtistsHorizontalCollectionViewController(viewModel: browseViewModel!)
            addChildViewController(artistsHorizontalVC!)
        }
        
        return artistsHorizontalVC!
    }

    func refreshResults() {
        cellsAnimated = [:]
        
        guard let collectionView = collectionView, let response = response else {
            return
        }
        
        if !displayedData {
            collectionView.reloadData()
            displayedData = true
        } else {
            collectionView.performBatchUpdates({
                if let oldResponse = self.oldResponse {
                    let oldRange = NSMakeRange(0, oldResponse.groups.count)
                    collectionView.deleteSections(NSIndexSet(indexesInRange: oldRange))
                }

                let range = NSMakeRange(0, response.groups.count)
                collectionView.insertSections(NSIndexSet(indexesInRange: range))
            }, completion: nil)

        }

        let yOffset = containerViewController?.tabBar == nil ? 0 : -2 * KeyboardSearchBarHeight + 2
        collectionView.setContentOffset(CGPointMake(0, yOffset), animated: false)
    }
    
    func showRefreshResultsButton() {
        refreshTimer = NSTimer(timeInterval: NSTimeInterval(3.0), target: self, selector: "displayRefreshResultsButton", userInfo: nil, repeats: false)
    }
    
    func displayRefreshResultsButton() {
        refreshResultsButtonTopConstraint.constant = 20
        UIView.animateWithDuration(
            0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: .CurveEaseIn,
            animations: {
                self.refreshResultsButton.layoutIfNeeded()
            }, completion: nil)
    }
    
    func didTapRefreshResultsButton() {
        response = nextResponse
        refreshResultsButtonTopConstraint.constant = -40
        
        UIView.animateWithDuration(
            0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: .CurveEaseIn,
            animations: {
                self.refreshResultsButton.layoutIfNeeded()
            }, completion: nil)

        refreshResults()
    }
    
    func setupLayout() {
        refreshResultsButtonTopConstraint = refreshResultsButton.al_top == view.al_top - 40
        
        view.addConstraints([
            refreshResultsButton.al_height == 30,
            refreshResultsButton.al_centerX == view.al_centerX,
            refreshResultsButtonTopConstraint
        ])

        
        messageBarVisibleConstraint = messageBarView.al_bottom == view.al_top
        
        view.addConstraints([
            messageBarView.al_left == view.al_left,
            messageBarView.al_right == view.al_right,
            messageBarVisibleConstraint!,
            messageBarView.al_height == 39
        ])
    }
    
    // MediaItemCollectionViewCellDelegate
    override func mediaLinkCollectionViewCellDidToggleFavoriteButton(cell: MediaItemCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }

        FavoritesService.defaultInstance.toggleFavorite(selected, result: result)
        cell.itemFavorited = selected
    }

    // MARK: MessageBarViewDelegate
    func showMessageBar() {
        messageBarVisibleConstraint?.constant = 39
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func hideMessageBar() {
        messageBarVisibleConstraint?.constant = 0
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: EmptySetDelegate
    func updateEmptyStateContent(state: UserState, animated: Bool) {
        if animated {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.3)
        }
        
        super.updateEmptyStateContent(state)
        
        if animated {
            UIView.commitAnimations()
        }
    }

    override func setNavigationBarOriginY(y: CGFloat, animated: Bool) {
        guard let containerViewController = containerViewController,
            let searchBarController = searchBarController else {
            return
        }

        var frame = tabBarFrame
        var searchBarFrame = searchBarController.view.frame
        let tabBarHeight = CGRectGetHeight(frame)

        searchBarFrame.origin.y =  fmax(fmin(KeyboardSearchBarHeight + y, KeyboardSearchBarHeight), 0)
        frame.origin.y = fmax(fmin(y, 0), -tabBarHeight)

        UIView.animateWithDuration(animated ? 0.1 : 0) {
            self.searchBarController?.view.frame = searchBarFrame
            containerViewController.tabBar.frame = frame
        }
    }
}

